% Main Method : the back projection(BP) algorithm
%
% Reference :
%   Gui-ron, Guo. “Electromagnetic vortex based radar target imaging.” 
%   Journal of National University of Defense Technology (2013).

clc;
clear;
close all;

% ====== 常数项 =======

c = 299792458 ;

% ====== 载波参数 =======

frequency = 6e9;
lambda = c / frequency;
k = 2.0 * pi / lambda; 

% ====== 阵列参数 =======

a = 20 * lambda;

% ====== 待评估点 ======= 

rm = 500 * lambda;
thetam = pi/3;
phim = pi/4;

% ====== 模式取值范围 ======= 

maxL = 30;
minL = -30;

% ====== 回波信号 ======= 

s = @(mode) exp(1i*2*k*rm)/rm^2 ...
    .* exp (1i*2*mode*phim) ...
    .* besselj(mode, k * a * sin(thetam)).^2;

% ====== 逆投影法 ======= 

r = @(mode,theta,phi) s(mode)...
    .*  exp (-1i*2*mode*phi) ...
    .* conj((besselj(mode, k * a * sin(theta))).^2);

% 评估方位角范围
phi = -pi:0.01*pi:pi;
theta0 = pi/3;

res = zeros(length(phi));
for i = 1:length(phi)
    res(i) = abs(integral(@(mode) r(mode,theta0,phi(i)),minL,maxL));
end

plot(phi/pi,res,'k');
xlabel('方位角');
ylabel('幅值');