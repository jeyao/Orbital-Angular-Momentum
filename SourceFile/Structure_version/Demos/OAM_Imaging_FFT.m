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
nFFT = 2^10 ;

% ====== ������ =======

c = 299792458 ;  

% ====== OAMģʽ�� =======

l = -1*rangeL:1:rangeL ;

% ====== ���ģ�͵Ļز����䳡 =======

opt.active = true ;
opt.frequency = 9e9;
lambda = c / opt.frequency;
opt.nElem = 16;
opt.nScatteringPoint = 2;
opt.mRadius = [500,600] * lambda;
opt.mElevation = [60,90] * pi / 180 ;
opt.mAzimuth = [80,120] * pi / 180;
opt.arrayRadius = 25 * lambda;

s1 = zeros(length(l),1); 
s2 = zeros(length(l),1);

for i = 1 : length(l)
    opt.l = l(i);
    opt.type = 'MISO';
    s1(i) = calcEchoSignal(opt);
    opt.type = 'MIMO';
    s2(i) = calcEchoSignal(opt);
end

% ====== ����FFT��������� =======

Y1 = fft(s1,nFFT);
y1 = abs( Y1 / nFFT );
x1 = (0:(nFFT-1))/nFFT*360;

Y2 = fft(s2,nFFT);
y2 = abs( Y2 / nFFT );
x2 = (0:(nFFT-1))/nFFT*360/2;

% ====== ��ͼ =======

subplot(1,2,1);
plot(x1,y1,'k');
xlabel('��λ��');
ylabel('��ֵ');
title('MISO��һά����');
xlim([min(x1),max(x1)]);
ylim([min(y1),max(y1)]);

subplot(1,2,2);
plot(x2,y2,'k');
xlabel('��λ��');
ylabel('��ֵ');
title('MIMO��һά����');
xlim([min(x2),max(x2)]);
ylim([min(y2),max(y2)]);