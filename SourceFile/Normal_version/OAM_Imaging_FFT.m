%% DEMO - Vortex wave target imaging based on FFT
%
% History :
%   Yao - 2021.6.14 - v1.0
%       1.Create File

%%
clc;clear;close all;  

%% Setting Parameters 
% Basic
modeRange = 20;
f0 = 20e9;

c = 299792458;
lambda = c / f0 ;
k = 2.0 * pi / lambda; 

% Target 
scatteringPointNum = 2;
mRadius = [500,600] * lambda;
mElevation = [0.3,0.3]*pi;
mAzimuth = [80,120] * pi / 180;

%% Parameters
N = 1024;
elemNum = 16;
arrRadius = 5*lambda;

%% Computed Parameters
modes = -modeRange:1:modeRange ;
rcs = ones(1,scatteringPointNum);

%% Echo Signal
sr_miso = zeros(length(modes),1); 
sr_mimo = zeros(length(modes),1);

for i = 1 : length(modes)
   mode = modes(i);
   sr_miso(i) = rcs * (...
        elemNum * 1i^mode ...
        .* exp(-1i*2.0*k*mRadius') ./ (mRadius'.^2)...
        .* besselj(mode,k*arrRadius*sin(mElevation'))...
        .* exp(1i*mode*(mAzimuth')));
    
    sr_mimo(i)  = rcs * (... 
        elemNum^2 * (1i^mode).^2 ...
        .* exp(-1i*2.0*k*mRadius') ./ (mRadius'.^2)...
        .* besselj(mode,k*arrRadius*sin(mElevation')).^2 ...
        .* exp(1i* 2.0 *mode*mAzimuth'));
    
    % Phase compensation
    sr_miso(i) = sr_miso(i) * (-1i)^mode;
    sr_mimo(i) = sr_mimo(i) * ((-1i)^mode)^2;
end

%% Processing of Echo Signal
Y_miso = fft(sr_miso,N);
y_miso = abs( Y_miso / N );
x_miso = (0:(N-1))/N*360;

Y_mimo = fft(sr_mimo,N);
y_mimo = abs( Y_mimo / N );
x_mimo = (0:(N-1))/N*360/2;

%% Plot
figure(1);
subplot(211);plot(x_miso,y_miso,'k');
xlabel('Azimuth/°');ylabel('Amplitude');title('ID imaging(MISO)');
xlim([min(x_miso),max(x_miso)]);ylim([min(y_miso),max(y_miso)]);

subplot(212);plot(x_mimo,y_mimo,'k');
xlabel('Azimuth/°');ylabel('Amplitude');title('ID imaging(MIMO)');
xlim([min(x_mimo),max(x_mimo)]);ylim([min(y_mimo),max(y_mimo)]);