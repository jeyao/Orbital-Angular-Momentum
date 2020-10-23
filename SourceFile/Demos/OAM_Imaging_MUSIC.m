% 基于MUSIC的UCA成像
% 通过分析 MISO 模型，可知回波信号可以分解为 ±pi/2 的峰值
% MUSIC 评估的就是这两个峰值的方位角，也就是 2 * M 个目标值
% 为了直接得到目标的方位角，在最后搜索频谱的时候加入了 90 相移
% 最终得到的是目标方位角和加 180 的伪像。

clc;
clear;
close all;

try 
    run('..\loadAllPath.m');
catch
    error('Fail to load path.');
end

% ====== 基本参数 =======

rangeL = 20;

% ====== 常数项 =======

c = 299792458 ;  

% ====== 载波参数 =======

f = 8e9;
lambda = c/f;
k = 2.0 * pi / lambda; 

N_x = 2^10;
Fs = 2*f;
Ts = 1/Fs;
T = (N_x-1)*Ts;
t = 0 : Ts : T;
st = cos(2.0*pi*f*t);

% ====== UCA参数 =======

N = 32;
K = 14;
a = 50 * lambda;
phi_el = 2.0 * pi / N * (0 : N - 1); % Calculate the angular position of each element

% ====== 待评估点 =======

M = 2 ;
rm = [782.4 , 781.5 ] * lambda;
thetam = [ 60 , 70  ] * pi / 180;
psim = [ 45 , 90  ] *  pi / 180;

% ====== OAM模式数 =======

l = (-1*rangeL:1:rangeL)' ;

% ====== 构造模型 =======

A = zeros(length(l),M);
S = zeros(M,N_x);

for m = 0:M-1
    A(:,m*2+1) = exp(1j * l * (psim(m+1) - (pi/2)));
    A(:,m*2+2) = exp(1j * l * (psim(m+1) + (pi/2)));
    
    S(m*2+1,:) = st...
        * (exp(-1j*2*k*rm(m+1))/rm(m+1)^2)...
        * sqrt(1/(2.0 * pi * k * a * sin(thetam(m+1))))...
        * exp(1j *(k*a*sin(thetam(m+1)-(pi/4))));
    S(m*2+2,:) = st...
        * (exp(-1j*2*k*rm(m+1))/rm(m+1)^2)...
        * sqrt(1/(2.0 * pi * k * a * sin(thetam(m+1))))...
        * exp(-1j *(k*a*sin(thetam(m+1)-(pi/4))));
end

E = A*S;

% ====== 添加噪声 =======

snr = 10;
E=awgn(E,snr,'measured');

% ====== MUSIC =======

opt.active = true;
opt.X = E;
opt.SteeringVector = @(angle) exp( 1i * l * ( angle * pi / 180 - pi/2));
opt.NumSubSignals = K;
opt.NumSignalSource = M;
opt.ScanAngles = 0:0.2:360;
SP = useMUISC(opt);

% ====== 绘图 =======

plot(opt.ScanAngles,SP,'k');
xlabel('方位角');
ylabel('幅值');