clc;
clear;
close all;

try 
    run('..\loadAllPath.m');
catch
    error('Fail to load path.');
end
% ====== 基本参数 =======

rangeL = 10;

nScatteringPoint = 3;
mRadius = [700,900,800];
mElevation = [0.3,0.3,0.3]*pi;
mAzimuth = [30,80,50]/180*pi;

arrayRadius = 0.03;

% ====== 常数项 =======

c = 299792458 ;  

% ====== OAM模式数 =======

l = -1*rangeL:1:rangeL ;

% ====== 脉冲参数 =======

T=1e-6;    % 脉冲宽度
Tr=2e-6;  % 脉冲周期
B=200e6;   % 带宽
frequency = 9e9;
fs=4*B;
Ts=1/fs;

Rmin=500;Rmax=1000; 
Rcount = 80;

PhiMin = 0;PhiMax = pi;
Phicount = 60;

theta =0.3*pi;

R = linspace(Rmin,Rmax,Rcount);
Phi = linspace(PhiMin,PhiMax,Phicount);
Q = Rcount * Phicount;
[r,phi] = meshgrid(R,Phi);

Rwid=Rmax-Rmin; 
Twid=2*Rwid/c;
Nwid=ceil(Twid/Ts);
Nchirp=ceil(T/Ts);

t=linspace(2*Rmin/c,2*Rmax/c,Nwid);  % 时间序列                                  
td=ones(nScatteringPoint,1)*t-2*mRadius'/c*ones(1,Nwid);  % 添加时延

Sr = getSr(l,td,T,B,Tr,frequency,61, [1,1,1],mAzimuth,mElevation,arrayRadius);

tempT = repmat(t,1,length(l));
Sr = (Sr./exp(-1i*2*pi*frequency*tempT))'; % 解调

S = zeros(length(Sr),Q);
for i = 1: Q
    gTd=t-2*r(i)/c*ones(1,Nwid);
    S(:,i) = (getSr(l,gTd,T,B,Tr,frequency,61,1,phi(i),theta,arrayRadius)./exp(-1i*2*pi*frequency*tempT))';
end

Psi =eye(Q);
A = S * Psi;
theta = useOMP(nScatteringPoint,A,Sr);

figure(1);
res = reshape(Psi * theta,[Phicount,Rcount]);
surf(R,Phi/pi*180,abs(res))
view(2)