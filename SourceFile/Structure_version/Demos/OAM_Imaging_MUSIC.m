% ����MUSIC��UCA����
% ͨ������ MISO ģ�ͣ���֪�ز��źſ��Էֽ�Ϊ ��pi/2 �ķ�ֵ
% MUSIC �����ľ�����������ֵ�ķ�λ�ǣ�Ҳ���� 2 * M ��Ŀ��ֵ
% Ϊ��ֱ�ӵõ�Ŀ��ķ�λ�ǣ����������Ƶ�׵�ʱ������� 90 ����
% ���յõ�����Ŀ�귽λ�Ǻͼ� 180 ��α��

clc;
clear;
close all;

try 
    run('..\loadAllPath.m');
catch
    error('Fail to load path.');
end

% ====== �������� =======

rangeL = 20;

% ====== ������ =======

c = 299792458 ;  

% ====== �ز����� =======

f = 8e9;
lambda = c/f;
k = 2.0 * pi / lambda; 

N_x = 2^10;
Fs = 2*f;
Ts = 1/Fs;
T = (N_x-1)*Ts;
t = 0 : Ts : T;
st = cos(2.0*pi*f*t);

% ====== UCA���� =======

N = 32;
K = 14;
a = 50 * lambda;
phi_el = 2.0 * pi / N * (0 : N - 1); % Calculate the angular position of each element

% ====== �������� =======

M = 2 ;
rm = [782.4 , 781.5 ] * lambda;
thetam = [ 60 , 70  ] * pi / 180;
psim = [ 45 , 90  ] *  pi / 180;

% ====== OAMģʽ�� =======

l = (-1*rangeL:1:rangeL)' ;

% ====== ����ģ�� =======

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

% ====== ������� =======

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

% ====== ��ͼ =======

plot(opt.ScanAngles,SP,'k');
xlabel('��λ��');
ylabel('��ֵ');