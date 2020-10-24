clc;
clear;
close all;

try 
    run('..\loadAllPath.m');
catch
    error('Fail to load path.');
end

% ====== 基本参数 =======

rangeL = 25;
nFFT = 2^10 ;

opt.nScatteringPoint = 2;
opt.mRadius = [600,800];
opt.mElevation = [0.3,0.3]*pi;
opt.mAzimuth = [50,100]/180*pi;


% ====== 常数项 =======

c = 299792458 ;  

% ====== OAM模式数 =======

l = -1*rangeL:1:rangeL ;

% ====== 脉冲参数 =======

T=5e-6;    % 脉冲宽度
Tr=50e-6;  % 脉冲周期
B=180e6;   % 带宽
frequency = 9e9;
fs=10*B;
Ts=1/fs;

Rmin=500;Rmax=1000; 
Rwid=Rmax-Rmin; 
Twid=2*Rwid/c;

Nwid=ceil(Twid/Ts);
Nchirp=ceil(T/Ts);

nFFT1=2^nextpow2(2*Nwid-1);

t=linspace(2*Rmin/c,2*Rmax/c,Nwid);  % 时间序列                                  
td=ones(opt.nScatteringPoint,1)*t-2*opt.mRadius'/c*ones(1,Nwid);  % 时延

opt.carrierSignal = generateChirp(td,T,B,Tr,frequency);

% ====== 信号参数 =======

t0=linspace(-T/2,T/2,Nchirp);
St=exp(1j*pi*(B/T)*t0.^2);
Sw=fft(St,nFFT1);

% ====== 信号参数 =======

lambda = c / frequency ; 
k = 2.0 * pi / lambda;  

opt.active = true ;
opt.frequency = frequency;
opt.nElem = 80;
opt.arrayRadius = 25*lambda;

Sr = zeros(length(l),nFFT1);
for i = 1:length(l)
    opt.l = l(i);
    Srt = calcEchoSignal(opt)/besselj(l(i),k*opt.arrayRadius *sin(0.3*pi));
    Srw=fft(Srt,nFFT1);
    
    Sot=ifft(Srw.*conj(Sw)); % 匹配
    Sr(i,:) = Sot;
end

Z = fftshift(fft(Sr,nFFT));
z = abs( Z / nFFT );
y = ((-nFFT)/2:(nFFT)/2-1)/nFFT*180*2;

N0=fix(nFFT1/2-Nchirp/2);
surf(t*c/2,y,z(:,N0:N0+Nwid-1));
shading interp;
title('OAM二维成像');
view(2);
xlabel('Range/m');
ylabel('Azimuth/°');
ylim([min(y),max(y)]);