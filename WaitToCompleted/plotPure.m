clc;
clear;
close all;

% ====== 可调参数 =======

% 距离
raduis = 2;
% 模式
l = 4;
% 评估范围
tempLRange = -6:6;

% ====== 基本参数 =======

c = 299792458 ;

% ====== 载波参数 =======

frequency = 18e9;
lambda = c / frequency;
k = 2.0 * pi / lambda; 

arrayRadius = 0.03 ;
r0 = 10;

elevation = pi/2;
N = 32;
elemPhi = (0:N-1) * 2*pi/N;
nPhi = elemPhi;

fun = @(azimuth,n,tempL) (1./(4.0 * pi * raduis))...
        .* exp(1i * k * raduis)...
        .* exp(-1i * k * arrayRadius * sin(elevation) * cos(azimuth-elemPhi(n)) + 1i*nPhi(n))...
        .*exp(-1i*tempL*azimuth);


puity = zeros(1,length(tempLRange));
for i = 1:length(tempLRange)
    l = tempLRange(i);
    for n = 1:N
        puity(i) = puity(i) + integral(@(azimuth) fun(azimuth,n,l),-pi,pi);
    end
    puity(i) = abs(puity(i))/(2*pi);
end
puity = puity / sum(puity);
bar(tempLRange,puity);

