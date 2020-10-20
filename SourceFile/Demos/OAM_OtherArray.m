% 待完善

clc;
clear;
close all;

try 
    run('..\loadAllPath.m');
catch
    error('Fail to load path.');
end

opt.frequency = 9e9;
l =2;
c = 299792458 ;                   
lambda = c / opt.frequency ; 

obsRange = 25*lambda;
obsCount = 2^10;
Z0 =25*lambda;

X = linspace (-obsRange, obsRange, obsCount);
Y = linspace (-obsRange, obsRange, obsCount);
[~,sphCoord] = getObsPlaneCoordinate(X,Y,Z0);

opt.active = true;
opt.sphCoord = sphCoord;
opt.nElem = 12;
opt.elemPositionPhi = 2*pi/ opt.nElem * (0:opt.nElem-1);
%  opt.elemPositionRadius = [1,sqrt(5)/2,sqrt(2),sqrt(5)/2,1,sqrt(5)/2,sqrt(2),sqrt(5)/2,1,sqrt(5)/2,sqrt(2),sqrt(5)/2,1,sqrt(5)/2,sqrt(2),sqrt(5)/2]*2*lambda;
opt.elemPositionRadius = [sqrt(3)/2,1,sqrt(3)/2,1,sqrt(3)/2,1,sqrt(3)/2,1,sqrt(3)/2,1,sqrt(3)/2,1]*2*lambda;
opt.elemExcitation = exp(1i*opt.elemPositionPhi*l);
sig = calcArrayRadiation( opt );

% ====== 绘制强度图像 ========

vis.intensity.active = true;
vis.intensity.nFigure = 1;
vis.intensity.title = 'OAM强度图像';
vis.intensity.colorBar = true;
plotIntensityPattern(sig,vis.intensity);

% ====== 绘制相位图像 ========

vis.phase.active = true;
vis.phase.nFigure = 2;
vis.phase.title = 'OAM相位图像';
vis.phase.colorBar = true;
plotPhasePattern(sig,vis.phase);
