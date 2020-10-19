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
k = 2.0 * pi / lambda;                 % 波数 

if ~isfield(opt,'type') ||...
    isempty(opt.type) ||...
    strcmp(opt.type , 'observe')
    opt.type = 'observe';
    opt = checkField(opt, 'obsRange', {'numeric'},{'real','nonnan'},25*lambda);
    opt = checkField(opt, 'obsCount', {'numeric'},{'real','nonnan'},2^10);
    opt = checkField(opt, 'Z0', {'numeric'},{'real','nonnan'},25*lambda);
    opt = checkField(opt, 'tilt', {'numeric'},{'real','nonnan'},0);
    
elseif strcmp(opt.type , 'point')
    isDefPoint = isfield(opt,'mRadius') ...
        && ~isempty(opt.mRadius) ...
        && isfield(opt,'mPsi') ...
        && ~isempty(opt.mPsi) ...
        && isfield(opt,'mTheta') ...
        && ~isempty(opt.mTheta);

    isNumEqual = isequal(size(opt.mRadius) , size(opt.mPsi)) ...
        && isequal(size(opt.mPsi),size(opt.mTheta) ); 
    
    if ( ~isNumEqual || ~isDefPoint ) 
        error('请输入正确评估点数据');
    end
    
else
    error('请输入正确的种类');
end

opt = checkField(opt, 'elemExcitation', {'numeric'},{'real','positive','nonnan','finite'},1);
opt = checkField(opt, 'arrayRadius', {'numeric'},{'real','nonnan'},2*lambda);


% ====== UCA参数 =======

elemPhi = 2.0 * pi  / opt.nElem * ( 0 :  opt.nElem - 1 );  % 天线各阵元的方向角

% ====== 设置信号基本参数 =======

sig.physical.frequency = opt.frequency;
sig.physical.l = opt.l;

if strcmp(opt.type , 'observe')
    % 得到二维笛卡尔坐标系
    sig.type = 'observe';
    X = linspace (-opt.obsRange, opt.obsRange, opt.obsCount);
    Y = linspace (-opt.obsRange, opt.obsRange, opt.obsCount);
    [x,y] = meshgrid(X,Y);
    
    % ====== 求解UCA辐射场 =======

    E = zeros(length(y),length(x));        % 初始化辐射场

    for n = 1 : opt.nElem
        E = E + spherical(...
            k,...
            x - opt.arrayRadius * cos(elemPhi(n))*cos(opt.tilt),...
            y - opt.arrayRadius * sin(elemPhi(n)),...
            opt.Z0 + opt.arrayRadius * cos(elemPhi(n))*sin(opt.tilt)...
            )...
            *opt.elemExcitation * exp( 1i * elemPhi(n) * opt.l);
    end
    
    sig.samples{1} = E;

elseif strcmp(opt.type , 'point')
    
    sig.type = 'point';
    sig.scatteringPoint.radius = opt.mRadius;
    sig.scatteringPoint.phi = opt.mPsi;
    sig.scatteringPoint.theta = opt.mTheta;
    
    E = opt.elemExcitation * exp(-1i * k * opt.mRadius) ./ opt.mRadius ...
        * opt.nElem * 1i^opt.l ...
        .* exp(1i * opt.l * opt.mPsi)...
        .*besselj(opt.l, k * opt.arrayRadius * sin(opt.mTheta));
    
    sig.samples{1} = E;
end

end

function output = spherical(k, x, y, z)
    %
    % 本函数用于计算圆形相位项
    %
    % ======= INPUT PARAMETER =======
    % k         :  波数
    % x , y , z :  观测平面的笛卡尔坐标系
    %
    r = sqrt(x.^2 + y.^2 + z.^2);
    output = exp(-1i*k*r)./r;
end