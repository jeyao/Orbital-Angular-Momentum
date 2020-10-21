% ***************************************************
% File Name : OAM_OtherArray.m
%
% Description  : 
%   1.分别通过六边形和正方形天线阵列获取模式为2的OAM。
%   2.绘制强度相位图。
%
% History :
%   Yao - 2020.10.21 - v1.0
%       1.创建文件
%
% ***************************************************

clc;
clear;
close all;

try 
    run('..\loadAllPath.m');
catch
    error('Fail to load path.');
end

l =2;
frequency = 9e9;
c = 299792458 ;                   
lambda = c / frequency ; 

% ====== 获取观察平面坐标 ========

opt.Coordinate.active = true;
opt.Coordinate.obsRange = 25*lambda;
opt.Coordinate.Z0 =25*lambda;

[~,sphCoord] = getObsRectPlaneCoordinate(opt.Coordinate);

% ====== 计算六边形阵列辐射场 ========

opt.Array.active = true;
opt.Array.nElem = 12;
opt.Array.frequency = frequency;
opt.Array.sphCoord = sphCoord;
opt.Array.elemPositionPhi = 2*pi/ opt.Array.nElem * (0:opt.Array.nElem-1);
opt.Array.elemPositionRadius = [sqrt(3)/2,1,sqrt(3)/2,1,sqrt(3)/2,1,sqrt(3)/2,1,sqrt(3)/2,1,sqrt(3)/2,1]*2*lambda;
opt.Array.elemExcitation = exp(1i*opt.Array.elemPositionPhi*l);
sig = calcArrayRadiation( opt.Array );

% ====== 绘制强度图像 ========
subplot(2,2,1);
vis.intensity.active = true;
vis.intensity.title = '六边形阵列强度图像';
plotIntensityPattern(sig,vis.intensity);

% ====== 绘制相位图像 ========
subplot(2,2,2);
vis.phase.active = true;
vis.phase.title = '六边形阵列相位图像';
plotPhasePattern(sig,vis.phase);

% ====== 计算正方形阵列辐射场 ========

opt.Array.nElem = 16;
opt.Array.elemPositionPhi = 2*pi/ opt.Array.nElem * (0:opt.Array.nElem-1);
opt.Array.elemPositionRadius = [1,sqrt(5)/2,sqrt(2),sqrt(5)/2,1,sqrt(5)/2,sqrt(2),sqrt(5)/2,1,sqrt(5)/2,sqrt(2),sqrt(5)/2,1,sqrt(5)/2,sqrt(2),sqrt(5)/2]*2*lambda;
opt.Array.elemExcitation = exp(1i*opt.Array.elemPositionPhi*l);
sig = calcArrayRadiation( opt.Array );

% ====== 绘制强度图像 ========
subplot(2,2,3);
vis.intensity.active = true;
vis.intensity.title = '正方形阵列强度图像';
plotIntensityPattern(sig,vis.intensity);

% ====== 绘制相位图像 ========
subplot(2,2,4);
vis.phase.active = true;
vis.phase.title = '正方形阵列相位图像';
plotPhasePattern(sig,vis.phase);

