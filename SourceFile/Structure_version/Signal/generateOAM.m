function [sig] = generateOAM(opt)

%
% UCA的相控阵产生OAM波（涉及信号源倾斜角）
%
% ========== INPUT PARAMETER ===========
%
% X, Y  : 观察平面的 x 和 y 轴坐标范围
% f     : 载波频率
% l     : OAM 模式数
% N     : 天线阵元数
% a     : 天线半径 m
% amps  : 天线各阵元的激励源幅度
% z0    : 观察平面距天线的距离
% tilt  : 信号源的倾斜角
% ============ OUTPUTS ===================
narginchk(1,1);
addpath('..\Common');
addpath('..\Geometry');
% 判断是否可用
if (isfield(opt, 'active') && ~opt.active)
  return;
end

if ~isfield(opt,'frequency') ||...
    isempty(opt.frequency) 

    error('请输入信号频率');
end

if ~isfield(opt,'l') ||...
    isempty(opt.l) 
    error('请输入OAM模式数');
end

if ~isfield(opt,'nElem') ||...
    isempty(opt.nElem) 
    error('请输入天线数量');
end

% ====== 基本参数 =======

c = 299792458 ;                        % 光速 m/s
lambda = c / opt.frequency ;           % 波长 m

opt = checkField(opt, 'obsRange', {'numeric'},{'real','nonnan'},25*lambda);
opt = checkField(opt, 'obsCount', {'numeric'},{'real','nonnan'},2^10);
opt = checkField(opt, 'Z0', {'numeric'},{'real','nonnan'},25*lambda);
opt = checkField(opt, 'tilt', {'numeric'},{'real','nonnan'},0);
    
opt = checkField(opt, 'elemExcitation', {'numeric'},{'real','positive','nonnan','finite'},1);
opt = checkField(opt, 'arrayRadius', {'numeric'},{'real','nonnan'},2*lambda);


% ====== UCA参数 =======

% elemPhi = 2.0 * pi  / opt.nElem * ( 0 :  opt.nElem - 1 );  % 天线各阵元的方向角

% ====== 设置信号基本参数 =======

X = linspace (-opt.obsRange, opt.obsRange, opt.obsCount);
Y = linspace (-opt.obsRange, opt.obsRange, opt.obsCount);
[~,sphCoord] = getObsPlaneCoordinate(X,Y,opt.Z0);
opt.sphCoord = sphCoord;
sig = calcOAM( opt );

end