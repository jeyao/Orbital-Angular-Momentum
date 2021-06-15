%% DEMO - Calculating the purity of OAM
%
% History :
%   Yao - 2021.6.15 - v1.0
%       1.Create File

%%
clc;clear;close all; 

%% Setting Parameters
mode = 2;
modesRange = -10:10;

%% Parameters
f0 = 18e9;

c = 299792458 ;
lambda = c / f0;
k = 2.0 * pi / lambda; 
raduis = 2; 
arrRadius = 0.03 ;

elemNum = 16;
elemPhi = (0:elemNum-1) * 2*pi/elemNum;

%%
fun = @(azimuth,raduis,elevation,n) (1./(4.0 * pi * raduis))...
        .* exp(1i * k .* raduis)...
        .* exp(-1i * k * arrRadius .* sin(elevation) .* cos(azimuth-elemPhi(n)) + 1i*mode*elemPhi(n));
    
pureFun = @(azimuth,raduis,elevation,n,tempL) fun(azimuth,raduis,elevation,n).*exp(-1i*tempL*azimuth);

%% 
puity = zeros(1,length(modesRange));
for i = 1:length(modesRange)
    mode = modesRange(i);
    for n = 1:elemNum
        puity(i) = puity(i) + integral2(@(azimuth,elevation) pureFun(azimuth,raduis,elevation,n,mode),0,2*pi,0,pi/2);
    end
    puity(i) = abs(puity(i))/(2*pi);
end
puity = puity / sum(puity);

%% Plot
figure(1)
bar(modesRange,puity,'k');
xlabel('mode');ylabel('Amplitude');title('Puity of OAM');