function sig = calcOAM( opt )
    narginchk(1,1);
    addpath('..\Common');
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

    if ~isfield(opt,'l') ||...
        isempty(opt.l) 
        error('������OAMģʽ��');
    end
    
    if ~isfield(opt,'nElem') ||...
        isempty(opt.nElem) 
        error('��������������');
    end
    
    % ====== �ز����� =======
    
    c = 299792458 ;                        % ���� m/s
    lambda = c / opt.frequency ;           % ���� m
    k = 2.0 * pi / lambda;                 % ���� 
    
    opt = checkField(opt, 'arrayRadius', {'numeric'},{'real','nonnan'},2*lambda);
    
    radius(:,:) = opt.sphCoord(1,:,:);
    elevation(:,:) = opt.sphCoord(2,:,:) ;
    azimuth(:,:) = opt.sphCoord(3,:,:) ;
    
    % ====== ������䳡 =======
    
    E = exp(-1i * k * radius)./radius...
        * opt.nElem * 1i^(opt.l)...
        .* exp(1i * opt.l * azimuth)...
        .* besselj(opt.l, k * opt.arrayRadius * sin(elevation));
    
    sig.samples{1} = E;
    sig.physical.frequency = opt.frequency;
    sig.physical.l = opt.l;
end

