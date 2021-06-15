%% DEMO - Vortex wave 2D target imaging based on OMP
%
% History :
%   Yao - 2021.6.15 - v1.0
%       1.Create File

%%
clc;clear;close all;  
try 
    run('..\loadAllPath.m');
catch
    error('Fail to load path.');
end

%% Setting Parameters
% Basic
modeRange = 10;
nSteppedFreq = 61;
f0 = 9e9;

c = 299792458;
lambda = c / f0 ;
k = 2.0 * pi / lambda; 

% Target
theta =0.3*pi;
scatteringPointNum = 3;
mRadius = [700,900,800];
mElevation =  theta * ones(1,scatteringPointNum);
mAzimuth = [30,80,50]/180*pi;

%% Parameters
N = 1024;
elemNum = modeRange * 2 + 2;
arrRadius = 25*lambda;

Tp = 1e-6; 
Tr = 2e-6; 
B=180e6;
fs=4*B;

Rmin=500;Rmax=1000; 
Rcount = 80;

PhiMin = 0;PhiMax = pi;
Phicount = 60;

%% Computed Parameters
modes = -modeRange:1:modeRange ;
rcs = ones(1,scatteringPointNum);

ts = 1/fs;
sampleNum = ceil((2*(Rmax-Rmin)/c)/ts);
sampleNum_fft = 2^nextpow2(2*sampleNum-1);
tao = 2*mRadius'/c;
t = linspace(2*Rmin/c,2*Rmax/c,sampleNum); 
td = ones(scatteringPointNum,1)*t-tao*ones(1,sampleNum);

%% Observation plane
R = linspace(Rmin,Rmax,Rcount);
Phi = linspace(PhiMin,PhiMax,Phicount);
Q = Rcount * Phicount;
[r,phi] = meshgrid(R,Phi);

%% Measurement vector
Sr = getSr(modes,td,Tp,B,Tr,f0,nSteppedFreq,rcs ,mAzimuth,mElevation,arrRadius);

tMat = repmat(t,1,length(modes));
Sr = (Sr./exp(-1i*2*pi*f0*tMat))'; 

%% Compressive sensing matrix
S = zeros(length(Sr),Q);

for i = 1: Q
    gTd=t-2*r(i)/c*ones(1,sampleNum);
    S(:,i) = (getSr(modes,gTd,Tp,B,Tr,f0,nSteppedFreq,1,phi(i),theta,arrRadius)./exp(-1i*2*pi*f0*tMat))';
end

Psi =eye(Q);
A = S * Psi;

%% OMP
theta = useOMP(Sr,A,scatteringPointNum);

res = reshape(Psi * theta,[Phicount,Rcount]);

%% Plot
figure(1);
surf(R,Phi/pi*180,abs(res))
shading interp;
xlabel('Range/m');ylabel('Azimuth/бу');title('2D imaging(OMP)');
view(2);