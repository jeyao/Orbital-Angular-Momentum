% Main Method : Fast Fourier transform (FFT) for MISO
%
% Reference :
%   K. Liu, Y. Cheng, Z. Yang, H. Wang, Y. Qin and X. Li,
%       "Orbital-Angular-Momentum-Based Electromagnetic Vortex Imaging," 
%       in IEEE Antennas and Wireless Propagation Letters, vol. 14, pp. 711-714, 2015, doi: 10.1109/LAWP.2014.2376970.
%

clc;
clear;
close all;

% ====== 基本参数 =======

rangeL = 20;
nFFT = 2^10 ;

% ====== 常数项 =======

c = 299792458 ;  

% ====== 载波参数 =======

f = 9e9;
lambda = c / f;
k = 2.0 * pi / lambda;  

% ====== UCA参数 =======

N = 16;
a = 25 * lambda ;

% ====== 待评估点 =======

M = 2; 
r_m = [500,600] * lambda;
psi_m = [80,120] * pi / 180;
theta_m = [60,90] * pi / 180 ;

% ====== OAM模式数 =======

l = -1*rangeL:1:rangeL ;

% ====== 求解模型的回波辐射场 =======

s = zeros(length(l),1);        % 初始化辐射场

for i = 1 : length(l)
    for j = 1 : M
        s(i) = s(i) + (exp(-1i * 2.0 * k * r_m(j) )/ r_m(j)^2)...
            * exp(1i * l(i) *(psi_m(j)-pi/2))...
            * besselj(l(i), k * a * sin(theta_m(j)));
    end
end

% ====== 利用FFT求解成像参数 =======

Y = fft(s,nFFT);
y = abs( Y / nFFT );
x = (0:(nFFT-1))/nFFT*360;

% ====== 绘图 =======

plot(x,y,'k');
xlabel('方位角');
ylabel('幅值');