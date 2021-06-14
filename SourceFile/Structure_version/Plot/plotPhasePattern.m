function [] = plotPhasePattern( sig, opt )

% ����ǿ��ͼ��
%
% ========== INPUT PARAMETER ===========
%
% sig            : �����ź�ƽ��
% varargin       ��
%
%   - active     ���жϸ�ģ���Ƿ����
%   - nFigure    ��ָ��ͼ��
%   - title      : ͼ�����
%   - haveColorBar   : �Ƿ���ʾɫ��
%   - obsRange     : ͼ��Χ
%
% ============ OUTPUTS ===================

addpath('..\Common');
% �ж��Ƿ����
if (isfield(opt, 'active') && ~opt.active)
  return;
end  

if ~isfield(opt,'obsRange') ||...
    isempty(opt.obsRange) 
    c = 299792458 ;                        % ���� m/s
    lambda = c / sig.physical.frequency ;  % ���� m
    opt.obsRange = 25 * lambda;
end

opt = checkField(opt, 'obsCount', {'numeric'},{'real','nonnan'},2^10);
opt = checkField(opt, 'nFigure', {'numeric'},{'real','positive','nonnan'},1);
opt = checkField(opt, 'title', {'char'},{},'');
opt = checkField(opt, 'colorBar', {'logical'},{}, false );

% �õ���ά�ѿ�������ϵ

X = linspace (-opt.obsRange, opt.obsRange, opt.obsCount);
Y = linspace (-opt.obsRange, opt.obsRange, opt.obsCount);
[x,y] = meshgrid(X,Y);

if ~isfield(opt,'nFigure') ||...
    isempty(opt.nFigure) 
    figure();
else
    figure(opt.nFigure);
end

surf(x,y,angle(sig.samples{1})/pi*180);
xlim([min(X),max(X)]);
ylim([min(Y),max(Y)]);
title( opt.title );
shading interp;
view(2);

if opt.colorBar
    h = colorbar('southoutside');
    set(h, 'xlim' , [-180,180]);
    set(h, 'xtick' , -180 : 180 : 180 );
    set(h, 'xticklabel' , {'-180��','0��','180��'});
end

end

