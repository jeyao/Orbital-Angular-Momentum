% ***************************************************
% File Name : OAM_Basic.m
%
% Description  : 
%   1.获取模式数为2的OAM。
%   2.绘制强度相位图。
%   3.绘制轴线强度相位图。
%
% History :
%   Yao - 2020.10.19 - v1.0
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

% ====== 生成OAM波 ========

opt.generate.active = true;
opt.generate.frequency = 10e9;
opt.generate.l = 2;
opt.generate.nElem = 16;
[sig] = generateOAM(opt.generate);

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

% ====== 绘制轴向 ========

vis.axial.active = true;
vis.axial.nFigure = 3;
vis.axial.title = 'OAM轴向强度';
vis.axial.type = 'intensity';
plotAxial(sig,vis.axial);

vis.axial.nFigure = 4;
vis.axial.title = 'OAM轴向相位';
vis.axial.type = 'phase';
plotAxial(sig,vis.axial);