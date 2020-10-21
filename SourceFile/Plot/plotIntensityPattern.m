function []  = plotIntensityPattern( sig, opt )

% 绘制强度图样
%
% ========== INPUT PARAMETER ===========
%
% sig            : 绘制信号平面
% varargin       ：
%
%   - active     ：判断该模块是否可用
%   - nFigure    ：指定图像
%   - title      : 图像标题
%   - haveColorBar   : 是否显示色标
%   - obsRange     : 图像范围
%
% ============ OUTPUTS ===================
addpath('..\Common');

% 判断是否可用
if (isfield(opt, 'active') && ~opt.active)
  return;
end  

if ~isfield(opt,'obsRange') ||...
    isempty(opt.obsRange) 
    c = 299792458 ;                        % 光速 m/s
    lambda = c / sig.physical.frequency ;           % 波长 m
    opt.obsRange = 25 * lambda;
end

opt = checkField(opt, 'obsCount', {'numeric'},{'real','nonnan'},2^10);
opt = checkField(opt, 'nFigure', {'numeric'},{'real','positive','nonnan'},1);
opt = checkField(opt, 'title', {'char'},{},'');
opt = checkField(opt, 'colorBar', {'logical'},{},false);

% 得到二维笛卡尔坐标系

X = linspace (-opt.obsRange, opt.obsRange, opt.obsCount);
Y = linspace (-opt.obsRange, opt.obsRange, opt.obsCount);
[x,y] = meshgrid(X,Y);

if ~isfield(opt,'nFigure') ||...
    isempty(opt.nFigure) 
    figure();
else
    figure(opt.nFigure);
end

surf(x,y,sig.samples{1}.*conj(sig.samples{1}));
xlim([min(X),max(X)]);
ylim([min(Y),max(Y)]);
title( opt.title );
shading interp;
view(2);

if opt.colorBar
    colorbar;
end

end



