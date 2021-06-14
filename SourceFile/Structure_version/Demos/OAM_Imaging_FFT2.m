clc;
clear;
close all;

try 
    run('..\loadAllPath.m');
catch
    error('Fail to load path.');
end

% ====== �������� =======

rangeL = 10;
nFFT = 2^10 ;

opt.nScatteringPoint = 2;
opt.mRadius = [600,800];
opt.mElevation = [0.3,0.3]*pi;
opt.mAzimuth = [50,100]/180*pi;


% ====== ������ =======

c = 299792458 ;  

% ====== OAMģʽ�� =======

l = -1*rangeL:1:rangeL ;

% ====== ������� =======

T=5e-6;    % ������
Tr=50e-6;  % ��������
B=180e6;   % ����
frequency = 9e9;
fs=10*B;
Ts=1/fs;

Rmin=500;Rmax=1000; 
Rwid=Rmax-Rmin; 
Twid=2*Rwid/c;

Nwid=ceil(Twid/Ts);
Nchirp=ceil(T/Ts);

nFFT1=2^nextpow2(2*Nwid-1);

t=linspace(2*Rmin/c,2*Rmax/c,Nwid);  % ʱ������                                  
td=ones(opt.nScatteringPoint,1)*t-2*opt.mRadius'/c*ones(1,Nwid);  % ʱ��

opt.carrierSignal = generateChirp(td,T,B,Tr,frequency);

% ====== �źŲ��� =======

t0=linspace(-T/2,T/2,Nchirp);
St=exp(1j*pi*(B/T)*t0.^2);
Sw=fft(St,nFFT1);

% ====== �źŲ��� =======

lambda = c / frequency ; 
k = 2.0 * pi / lambda;  

opt.active = true ;
opt.frequency = frequency;
opt.nElem = 80;
opt.arrayRadius = 25*lambda;

Sr = zeros(length(l),nFFT1);

for i = 1:length(l)
    opt.l = l(i);
    % Step I : demodulate signal
    Srt = calcEchoSignal(opt)./ exp(-1j*2*pi*frequency*t);
    
    % Step II : pulse compression
    Srw=fft(Srt,nFFT1);
    Sot=ifft(Srw.*conj(Sw)); % ƥ��
    
    % Step III : envelope correction
    Sr(i,:) = Sot./besselj(l(i),k*opt.arrayRadius *sin(0.3*pi));    
end

% Step IV : FFT 
Z = fftshift(fft(Sr,nFFT1));
z = abs( Z / nFFT1 );


N0=fix(nFFT1/2-Nchirp/2);
x = t*c/2;
y = ((-nFFT1)/2:(nFFT1)/2-1)/nFFT1*180*2;


% plot
surf(x,y,z(:,N0:N0+Nwid-1));
shading interp;
title('OAM��ά����');
xlabel('Range/m');
ylabel('Azimuth/��');
ylim([min(y),max(y)]);
view(2);