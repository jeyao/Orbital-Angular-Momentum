function Sr = calcEchoSignal(opt)
    narginchk(1,1);
    % 判断是否可用
    if (isfield(opt, 'active') && ~opt.active)
      return;
    end  
    if ~isfield(opt,'nScatteringPoint') ||...
        isempty(opt.nScatteringPoint)
        error('请输散射点数');
    end
    
    if ~isfield(opt,'nElem') ||...
        isempty(opt.nElem)
        error('请输天线阵元数量');
    end
    
    if ~isfield(opt,'frequency') ||...
        isempty(opt.frequency) 
        error('请输入信号频率');
    end
    
    if ~isfield(opt,'mRadius') ||...
        isempty(opt.mRadius)||...
        ~isfield(opt,'mElevation') ||...
        isempty(opt.mElevation)||...
        ~isfield(opt,'mAzimuth') ||...
        isempty(opt.mAzimuth)
        error('请输入正确的散射点坐标');
    end
    
    if ~isfield(opt,'l') ||...
        isempty(opt.l) 
        error('请输入OAM模式数');
    end    
    
    c = 299792458 ;                        % 光速 m/s
    lambda = c / opt.frequency ;           % 波长 m
    k = 2.0 * pi / lambda;                 % 波数 

    opt = checkField(opt, 'rcs', {'numeric'},{'size' [1,opt.nScatteringPoint]},ones(1,opt.nScatteringPoint));
    opt = checkField(opt, 'arrayRadius', {'numeric'},{'real','nonnan'},2*lambda);
    opt = checkField(opt, 'phaseCompensation', {'logical'},{},true);


    if ~isfield(opt,'type') ||...
        isempty(opt.type) ||...
        strcmp(opt.type , 'MISO')
        opt.type = 'MISO';

        Sr = opt.rcs * (...
            opt.nElem * 1i^opt.l ...
            .* exp(-1i*2.0*k*opt.mRadius') ./ (opt.mRadius'.^2)...
            .* besselj(opt.l,k*opt.arrayRadius*sin(opt.mElevation'))...
            .* exp(1i*opt.l*(opt.mAzimuth'-pi/2))...
            );

    elseif strcmp(opt.type , 'MIMO')
        
        Sr = opt.rcs * (...
            opt.nElem^2 * (1i^opt.l).^2 ...
            .* exp(-1i*2.0*k*opt.mRadius') ./ (opt.mRadius'.^2)...
            .* besselj(opt.l,k*opt.arrayRadius*sin(opt.mElevation')).^2 ...
            .* exp(1i* 2.0 *opt.l*opt.mAzimuth')...
            );
    end
    if opt.phaseCompensation
        Sr = phaseCompensation(Sr,opt.l,opt.type);
    end
end

function Sr = phaseCompensation(Sr,l,type)
    if strcmp( type , 'MISO')
        Sr = Sr * (-1i)^l;
    else
        Sr = Sr * ((-1i)^l)^2;
    end
end

