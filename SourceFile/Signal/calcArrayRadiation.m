function sig = calcArrayRadiation( opt )

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
    
    if ~isfield(opt,'nElem') ||...
        isempty(opt.nElem) 
        error('请输入天线数量');
    end
    
    if ~isfield(opt,'elemPositionPhi') ||...
        isempty(opt.nElem) 
        error('请输入天线方位角');
    end
    
    if ~isfield(opt,'elemPositionRadius') ||...
        isempty(opt.nElem) 
        error('请输入天线方位角');
    end
    
    % ====== 载波参数 =======
    
    c = 299792458 ;                        % 光速 m/s
    lambda = c / opt.frequency ;           % 波长 m
    k = 2.0 * pi / lambda;                 % 波数 
    
    opt = checkField(opt, 'elemExcitation', {'numeric'},{'size' [1,opt.nElem]},ones(1,opt.nElem));
    opt = checkField(opt, 'elemPositionPhi', {'numeric'},{'size' [1,opt.nElem]},ones(1,opt.nElem));
    opt = checkField(opt, 'elemPositionRadius', {'numeric'},{'size' [1,opt.nElem]},ones(1,opt.nElem));
    
    E = zeros(size(sphCoord.azimuth));
    
    for n = 1:opt.nElem
        E = E + exp(-1i*k*sphCoord.radius)./sphCoord.radius ...
        .*exp(1i*k*opt.elemPositionRadius(n)*sin(sphCoord.elevation).*cos(sphCoord.azimuth-opt.elemPositionPhi(n)))...
        * opt.elemExcitation(n);
    end

    sig.samples{1} = E;
    sig.physical.frequency = opt.frequency;
end

