% ***************************************************
% File Name : OAM_Basic.m
%
% Description  : 
%   1.��ȡģʽ��Ϊ2��OAM��
%   2.����ǿ����λͼ��
%   3.��������ǿ����λͼ��
%
% History :
%   Yao - 2020.10.19 - v1.0
%       1.�����ļ�
%
% ***************************************************

%%
clc;clear;close all;

%%
try 
    run('..\loadAllPath.m');
catch
    error('Fail to load path.');
end

%% ����OAM��

opt.generate.active = true;
opt.generate.frequency = 20e9;
opt.generate.l = 2;
opt.generate.nElem = 20;

[sig] = generateOAM(opt.generate);

%% ���� OAM ǿ��ͼ��

vis.intensity.active = true;
vis.intensity.nFigure = 1;
vis.intensity.title = 'OAMǿ��ͼ��';
vis.intensity.colorBar = false;
plotIntensityPattern(sig,vis.intensity);

%% ���� OAM ��λͼ��

vis.phase.active = true;
vis.phase.nFigure = 2;
vis.phase.title = 'OAM��λͼ��';
vis.phase.colorBar = false;
plotPhasePattern(sig,vis.phase);

%% ���� OAM ǿ������

vis.axial.active = true;
vis.axial.nFigure = 3;
vis.axial.title = 'OAM����ǿ��';
vis.axial.type = 'intensity';
plotAxial(sig,vis.axial);

%% ���� OAM ��λ����

vis.axial.nFigure = 4;
vis.axial.title = 'OAM������λ';
vis.axial.type = 'phase';
plotAxial(sig,vis.axial);