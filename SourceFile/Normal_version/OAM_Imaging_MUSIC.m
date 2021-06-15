%% DEMO - Vortex wave target imaging based on MUSIC
%
% History :
%   Yao - 2021.6.14 - v1.0
%       1.Create File

%%
clc;clear;close all;  

%% Setting Parameters
% Basic
modeRange = 20;
f0 = 9e9;

c = 299792458;
lambda = c / f0 ;
k = 2.0 * pi / lambda; 

% Target
scatteringPointNum = 2;
mRadius = [600,800];
mElevation = [0.3,0.3]*pi;
mAzimuth = [30,80]/180*pi;

%% Parameters
N = 1024;
elemNum = modeRange * 2 + 2;
subElemNum = modeRange/2;
arrRadius = 25*lambda;
fs=2*f0;

%% Computed Parameters
modes = -modeRange:1:modeRange ;
rcs = ones(1,scatteringPointNum);

ts = 1/fs;
T = (N-1)*ts;
t = 0:ts:T;
carrierSignal = cos(2.0*pi*f0*t);
                              
%% Constructing Model
A = zeros(length(modes),scatteringPointNum);
S = zeros(scatteringPointNum,N);

for m = 0:scatteringPointNum-1
    A(:,m*2+1) = exp(1j * modes * (mAzimuth(m+1) - (pi/2)));
    A(:,m*2+2) = exp(1j * modes * (mAzimuth(m+1) + (pi/2)));
    
    S(m*2+1,:) = carrierSignal...
        * (exp(-1j*2*k*mRadius(m+1))/mRadius(m+1)^2)...
        * sqrt(1/(2.0 * pi * k * arrRadius * sin(mElevation(m+1))))...
        * exp(1j *(k*arrRadius*sin(mElevation(m+1)-(pi/4))));
    
    S(m*2+2,:) = carrierSignal...
        * (exp(-1j*2*k*mRadius(m+1))/mRadius(m+1)^2)...
        * sqrt(1/(2.0 * pi * k * arrRadius * sin(mElevation(m+1))))...
        * exp(-1j *(k*arrRadius*sin(mElevation(m+1)-(pi/4))));
end

E = A*S;

%% MUSIC
ScanAngles = 0:0.2:360;
SteeringVector = @(angle) exp( 1i * modes' * ( angle * pi / 180 - pi/2));

Rs = E*E'/N;

% Spatial Smoothing
J = fliplr(eye(length(modes)));
Rxxb = (Rs+J*Rs.'*J)/2;
Rs_sub = zeros(subElemNum,subElemNum);
for i=1:length(modes)-subElemNum+1
     Rs_sub=Rs_sub+Rxxb(i:i+subElemNum-1,i:i+subElemNum-1);
end

% Eigenvalue Decomposition
[eigVects,eigVals_tmp] = eig(Rs_sub);
eigVals = real(eigVals_tmp);
[eigVals,index] = sort(diag(eigVals));
eigVects= eigVects(:,index);
Vn = eigVects(:,1:subElemNum-2*scatteringPointNum);

aziRange = SteeringVector(ScanAngles);
sv = aziRange(1:subElemNum,:);
SP= 1./sum(abs((sv'*Vn)).^2,2)+eps(1);
SP = 10*log10(abs(SP));

%% Plot
figure(1);
plot(ScanAngles,SP,'k');
xlabel('Range/m');ylabel('Azimuth/°');title('1D imaging base on MUSIC');