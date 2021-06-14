% ***************************************************
% File Name : OAM_OtherArray.m
%
% Description  : 
%   1.�ֱ�ͨ�������κ��������������л�ȡģʽΪ2��OAM��
%   2.����ǿ����λͼ��
%
% History :
%   Yao - 2020.10.21 - v1.0
%       1.�����ļ�
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

% ====== ��ȡ�۲�ƽ������ ========

opt.Coordinate.active = true;
opt.Coordinate.obsRange = 25*lambda;
opt.Coordinate.Z0 =25*lambda;

[~,sphCoord] = getObsRectPlaneCoordinate(opt.Coordinate);

% ====== �������������з��䳡 ========

opt.Array.active = true;
opt.Array.nElem = 12;
opt.Array.frequency = frequency;
opt.Array.sphCoord = sphCoord;
opt.Array.elemPositionPhi = 2*pi/ opt.Array.nElem * (0:opt.Array.nElem-1);
opt.Array.elemPositionRadius = [sqrt(3)/2,1,sqrt(3)/2,1,sqrt(3)/2,1,sqrt(3)/2,1,sqrt(3)/2,1,sqrt(3)/2,1]*2*lambda;
opt.Array.elemExcitation = exp(1i*opt.Array.elemPositionPhi*l);
sig = calcArrayRadiation( opt.Array );

% ====== ����ǿ��ͼ�� ========
subplot(2,2,1);
vis.intensity.active = true;
vis.intensity.title = '����������ǿ��ͼ��';
plotIntensityPattern(sig,vis.intensity);

% ====== ������λͼ�� ========
subplot(2,2,2);
vis.phase.active = true;
vis.phase.title = '������������λͼ��';
plotPhasePattern(sig,vis.phase);

% ====== �������������з��䳡 ========

opt.Array.nElem = 16;
opt.Array.elemPositionPhi = 2*pi/ opt.Array.nElem * (0:opt.Array.nElem-1);
opt.Array.elemPositionRadius = [1,sqrt(5)/2,sqrt(2),sqrt(5)/2,1,sqrt(5)/2,sqrt(2),sqrt(5)/2,1,sqrt(5)/2,sqrt(2),sqrt(5)/2,1,sqrt(5)/2,sqrt(2),sqrt(5)/2]*2*lambda;
opt.Array.elemExcitation = exp(1i*opt.Array.elemPositionPhi*l);
sig = calcArrayRadiation( opt.Array );

% ====== ����ǿ��ͼ�� ========
subplot(2,2,3);
vis.intensity.active = true;
vis.intensity.title = '����������ǿ��ͼ��';
plotIntensityPattern(sig,vis.intensity);

% ====== ������λͼ�� ========
subplot(2,2,4);
vis.phase.active = true;
vis.phase.title = '������������λͼ��';
plotPhasePattern(sig,vis.phase);

