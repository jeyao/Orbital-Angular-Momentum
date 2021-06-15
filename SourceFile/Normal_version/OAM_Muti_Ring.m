%% DEMO - Vortex wave generation based on multi ring circular array
%
% Description: 
%   1.使用多环圆形阵列产生涡旋电磁波。
%   2.ringRadius / ringElemNum 分别表示每环半径和阵元数。
%   3.ringSelect 表示使能哪个环。
%
% History :
%   Yao - 2021.6.14 - v1.0
%       1.Create File

%%
clc;clear;close all;  

%% Setting Parameters
% Basic
f0 = 20e9;
mode = 2;

c = 299792458;
lambda = c / f0 ;
k = 2.0 * pi / lambda; 

% Parameter of UCCA
ringNum = 5;
ringSelect = [1,0,0,1,1];
ringRadius = (1:5)*lambda;
ringElemNum = [12,25,37,50,62];

%% Parameters
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
E = ones(size(elevation));
for i = 1 : ringNum
    E = E + exp(-1i * k * radius)./radius...
        * ringSelect(i) * ringElemNum(i) * 1i^mode...
        .* besselj(mode,k * ringRadius(i) *sin(elevation'))...
        .* exp(1i * mode * azimuth);
end

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

