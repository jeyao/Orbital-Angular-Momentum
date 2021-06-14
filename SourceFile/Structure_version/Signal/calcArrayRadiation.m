function sig = calcArrayRadiation( opt )
    narginchk(1,1);
    % �ж��Ƿ����
    if (isfield(opt, 'active') && ~opt.active)
      return;
    end  
    
    if ~isfield(opt,'sphCoord') ||...
        isempty(opt.sphCoord)
        error('�������źŷ�Χ');
    end
    
    if ~isfield(opt,'frequency') ||...
        isempty(opt.frequency) 
        error('�������ź�Ƶ��');
    end
    
    if ~isfield(opt,'nElem') ||...
        isempty(opt.nElem) 
        error('��������������');
    end
    
    if ~isfield(opt,'elemPositionPhi') ||...
        isempty(opt.nElem) 
        error('���������߷�λ��');
    end
    
    if ~isfield(opt,'elemPositionRadius') ||...
        isempty(opt.nElem) 
        error('���������߷�λ��');
    end
    
    % ====== �ز����� =======
    
    c = 299792458 ;                        % ���� m/s
    lambda = c / opt.frequency ;           % ���� m
    k = 2.0 * pi / lambda;                 % ���� 
    
    opt = checkField(opt, 'elemExcitation', {'numeric'},{'size' [1,opt.nElem]},ones(1,opt.nElem));
    opt = checkField(opt, 'elemPositionPhi', {'numeric'},{'size' [1,opt.nElem]},ones(1,opt.nElem));
    opt = checkField(opt, 'elemPositionRadius', {'numeric'},{'size' [1,opt.nElem]},ones(1,opt.nElem));
    
    radius(:,:) = opt.sphCoord(1,:,:);
    elevation(:,:) = opt.sphCoord(2,:,:) ;
    azimuth(:,:) = opt.sphCoord(3,:,:) ;
    
    E = zeros(size(azimuth));

    for n = 1:opt.nElem
        E = E + exp(-1i*k*radius)./radius ...
        .*exp(1i*k*opt.elemPositionRadius(n)*sin(elevation).*cos(azimuth-opt.elemPositionPhi(n)))...
        * opt.elemExcitation(n);
    end

    sig.samples{1} = E;
    sig.physical.frequency = opt.frequency;
end

