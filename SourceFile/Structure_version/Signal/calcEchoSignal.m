function Sr = calcEchoSignal(opt)
    narginchk(1,1);
    % �ж��Ƿ����
    if (isfield(opt, 'active') && ~opt.active)
      return;
    end  
    if ~isfield(opt,'nScatteringPoint') ||...
        isempty(opt.nScatteringPoint)
        error('����ɢ�����');
    end
    
    if ~isfield(opt,'nElem') ||...
        isempty(opt.nElem)
        error('����������Ԫ����');
    end
    
    if ~isfield(opt,'frequency') ||...
        isempty(opt.frequency) 
        error('�������ź�Ƶ��');
    end
    
    if ~isfield(opt,'mRadius') ||...
        isempty(opt.mRadius)||...
        ~isfield(opt,'mElevation') ||...
        isempty(opt.mElevation)||...
        ~isfield(opt,'mAzimuth') ||...
        isempty(opt.mAzimuth)
        error('��������ȷ��ɢ�������');
    end
    
    if ~isfield(opt,'l') ||...
        isempty(opt.l) 
        error('������OAMģʽ��');
    end
    
    if ~isfield(opt,'carrierSignal') ||...
        isempty(opt.carrierSignal) 
        opt.carrierSignal = ones(opt.nScatteringPoint,1);
    elseif size(opt.carrierSignal,1) == 1
        opt.carrierSignal = ones(opt.nScatteringPoint,1)*opt.carrierSignal;    
    end
    
    c = 299792458 ;                        % ���� m/s
    lambda = c / opt.frequency ;           % ���� m
    k = 2.0 * pi / lambda;                 % ���� 

    opt = checkField(opt, 'carrierSignal', {'numeric'},{'size' [opt.nScatteringPoint,size(opt.carrierSignal,2)]},ones(opt.nScatteringPoint,1));
    opt = checkField(opt, 'rcs', {'numeric'},{'size' [1,opt.nScatteringPoint]},ones(1,opt.nScatteringPoint));
    opt = checkField(opt, 'arrayRadius', {'numeric'},{'real','nonnan'},2*lambda);
    opt = checkField(opt, 'phaseCompensation', {'logical'},{},true);


    if ~isfield(opt,'type') ||...
        isempty(opt.type) ||...
        strcmp(opt.type , 'MISO')
        opt.type = 'MISO';

        Sr = opt.rcs * (...
            opt.carrierSignal * opt.nElem * 1i^opt.l ...
            .* exp(-1i*2.0*k*opt.mRadius') ./ (opt.mRadius'.^2)...
            .* besselj(opt.l,k*opt.arrayRadius*sin(opt.mElevation'))...
            .* exp(1i*opt.l*(opt.mAzimuth'))...
            );

    elseif strcmp(opt.type , 'MIMO')
        
        Sr = opt.rcs * (... 
            opt.carrierSignal * opt.nElem^2 * (1i^opt.l).^2 ...
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

