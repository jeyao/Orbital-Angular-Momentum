function sig = calcOAM( opt )
    narginchk(1,1);
    addpath('..\Common');
    % 判断是否可用
    if (isfield(opt, 'active') && ~opt.active)
      return;
    end  
    
    if ~isfield(opt,'sphCoord') ||...
        isempty(opt.sphCoord)
        error('请输入信号范围');
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
    
    % ====== 载波参数 =======
    
    c = 299792458 ;                        % 光速 m/s
    lambda = c / opt.frequency ;           % 波长 m
    k = 2.0 * pi / lambda;                 % 波数 
    
    opt = checkField(opt, 'arrayRadius', {'numeric'},{'real','nonnan'},2*lambda);
    
    radius(:,:) = opt.sphCoord(1,:,:);
    elevation(:,:) = opt.sphCoord(2,:,:) ;
    azimuth(:,:) = opt.sphCoord(3,:,:) ;
    
    % ====== 计算辐射场 =======
    
    E = exp(-1i * k * radius)./radius...
        * opt.nElem * 1i^(opt.l)...
        .* exp(1i * opt.l * azimuth)...
        .* besselj(opt.l, k * opt.arrayRadius * sin(elevation));
    
    sig.samples{1} = E;
    sig.physical.frequency = opt.frequency;
    sig.physical.l = opt.l;
end

