clear all;

C=299792458 ;
T=10e-6;
Tr=100e-6;

M = 2;
RCS=[1,1];
R=[10500,13000];
mPhi = [20,40]/180*pi;
mTheta = [0.3,0.3]*pi;
l = -25:1:25;
N = 16;

frequency = 9e9;% 光速 m/s
lambda = C / frequency ;           % 波长 m
k = 2.0 * pi / lambda;  

a = 2*lambda;

B=30e6;
K=B/T; 

Rmin=10000;Rmax=15000; 
Rwid=Rmax-Rmin; 
Twid=2*Rwid/C;

Fs=10*B;Ts=1/Fs;
Nwid=ceil(Twid/Ts);

t=linspace(2*Rmin/C,2*Rmax/C,Nwid);                                   
td=ones(M,1)*t-2*R'/C*ones(1,Nwid);

Nchirp=ceil(T/Ts);
Nfft=2^nextpow2(Nwid+Nwid-1);

% 参考信号
t0=linspace(-T/2,T/2,Nchirp);
St=exp(1j*pi*K*t0.^2);
Sw=fft(St,Nfft);  

for i = 1:length(l)
    Srt=RCS*(exp(1j*pi*K*td.^2)...
        * N * exp(1i*l(i)*pi/2)...
        .*besselj(l(i),k*a*sin(mTheta'))...
        .*exp(1i*l(i)*mPhi')...
        .* exp(1i*2*pi*frequency*td)...
        .*(abs(td)<T/2));
    Srw=fft(Srt,Nfft);
    
    % 卷积
    Sot=ifft(Srw.*conj(Sw));
    Smy(i,:) = Sot./besselj(l(i),k*a*sin(0.3*pi));
end

nLFFT = 1024;

Y = fftshift(fft(Smy,nLFFT));
y = abs( Y / nLFFT );
x = (-(nLFFT)/2:(nLFFT)/2-1)/nLFFT*180;

N0=Nfft/2-Nchirp/2;
Z=y(:,N0:N0+Nwid-1);
% Z=Z./max(Z);
% Z=20*log10(Z+1e-6);

surf(t*C/2,x,Z);
shading interp;
view(2)

% plot(t*C/2,Z)
% axis([10000,15000,-60,0]);
% xlabel('距离/m');ylabel('幅值/dB')
% title('雷达回波经过脉冲压缩');