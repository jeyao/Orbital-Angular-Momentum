function sig = calcOAM( opt )

    addpath('..\Common');
    % 判断是否可用
    if (isfield(opt, 'active') && ~opt.active)
      return;
    end  
    
    if ~isfield(opt.sphCoord,'radius') ||...
        isempty(opt.sphCoord.radius) ||... 
        ~isfield(opt.sphCoord,'azimuth') ||...
        isempty(opt.sphCoord.azimuth) ||... 
        ~isfield(opt.sphCoord,'elevation') ||...
        isempty(opt.sphCoord.elevation)
        error('请输入信号范围');
    end
    
    sphCoord = opt.sphCoord ;
    
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
    
    % ====== 载波参数 =======
    
    c = 299792458 ;                        % 光速 m/s
    lambda = c / opt.frequency ;           % 波长 m
    k = 2.0 * pi / lambda;                 % 波数 
    
    opt = checkField(opt, 'arrayRadius', {'numeric'},{'real','nonnan'},2*lambda);

    % ====== 计算辐射场 =======
    
    E = exp(-1i * k * sphCoord.radius)./sphCoord.radius...
        * opt.nElem * 1i^(opt.l)...
        .* exp(1i * opt.l * sphCoord.azimuth)...
        .* besselj(opt.l, k * opt.arrayRadius * sin(sphCoord.elevation));
    
    sig.samples{1} = E;
end

