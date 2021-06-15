%% DEMO - Vortex wave generation based on UCA
%
% Description: 
%   1.产生模式数为2的OAM。
%
% History :
%   Yao - 2021.6.14 - v1.0
%       1.Create File

%%
clc;clear;close all;  

%% Parameters
f0 = 20e9;

c = 299792458;
lambda = c / f0 ;
k = 2.0 * pi / lambda; 

mode = 2;
elemNum = 20;
arrRadius = 5*lambda;

Z0 = 500*lambda;
obsRange = 100*lambda;
obsCount = 1024;

%% Coordinate System
X = linspace (-obsRange, obsRange, obsCount);
Y = linspace (-obsRange, obsRange, obsCount);

z = ones(length(Y),length(X)) * Z0;
[x,y] = meshgrid(X,Y);
[azimuth, elevation, radius] = cart2sph(x,y,z);   
elevation = pi/2 - elevation;

%% 
E = exp(-1i * k * radius)./radius...
        * elemNum * 1i^mode...
        .* besselj(mode,k*arrRadius*sin(elevation'))...
        .* exp(1i * mode * azimuth);
    
intensity = E.*conj(E);
phase = angle(E)/pi*180;

%% Plot
figure(1);
subplot(221);surf(x,y,intensity);
xlim([min(X),max(X)]);ylim([min(Y),max(Y)]);
title('Intensity distribution of OAM');
shading interp;view(2);

subplot(222);surf(x,y,phase);
xlim([min(X),max(X)]);ylim([min(Y),max(Y)]);
title('Wavefront distribution of OAM');
shading interp;view(2);

subplot(223);plot(X,intensity(floor(obsCount/2),:),'k');
xlim([min(X),max(X)]);
title('Intensity axial distribution of OAM');

subplot(224);plot(X,phase(floor(obsCount/2),:),'k');
xlim([min(X),max(X)]);
title('Wavefront axial distribution of OAM');
