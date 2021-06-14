function SP = useMUISC(opt)
    
    addpath('..\Common');

    % 判断是否可用
    if (isfield(opt, 'active') && ~opt.active)
      return;
    end
    
    if ~isfield(opt,'X') ||...
        isempty(opt.X)
      error('请输入信号');
    end  
    if ~isfield(opt,'SteeringVector') ||...
        isempty(opt.SteeringVector)
      error('请输入方向矩阵');
    end
    
    if ~isfield(opt,'NumSignalSource') ||...
        isempty(opt.NumSignalSource)
      error('请输入信号源数量');
    end
    
    [numSource,lenSignal]  = size(opt.X);
    
    isSpatialSmoothing = true;
    if (isfield(opt, 'NumSubSignals') && ~opt.NumSubSignals)
        opt.NumSubSignals = numSource;
        isSpatialSmoothing = false;
    end 
    
    opt = checkField(opt, 'ScanAngles', {'numeric'},{},linspace(0,2*pi,1024));
    
    Rx = opt.X*opt.X'/lenSignal;
    if isSpatialSmoothing
        Rx = SpatialSmoothing(Rx,opt.NumSubSignals);
    end
    [~, eigVects] = privEig(Rx) ;
    Vn = eigVects(:,1:opt.NumSubSignals-2*opt.NumSignalSource);
    
    azi = opt.SteeringVector(opt.ScanAngles);
    sv = azi(1:opt.NumSubSignals,:);
    D = sum(abs((sv'*Vn)).^2,2)+eps(1);
    SP= 1./D;
    SP = 10*log10(abs(SP));
end

function [eigVals, eigVects] = privEig(Rx) 
    [eigVects,eigVals_tmp] = eig(Rx);
    eigVals = real(eigVals_tmp);
    [eigVals,index] = sort(diag(eigVals));
    eigVects= eigVects(:,index);
    eigVals(eigVals<0) = 0;
end

function Sx= SpatialSmoothing(Rx,K)

    [M,~]=size(Rx);
    N=M-K+1;
    J=fliplr(eye(M));
    Rxxb=(Rx+J*Rx.'*J)/2;
    Sx=zeros(K,K);
    for i=1:N
        Sx=Sx+Rxxb(i:i+K-1,i:i+K-1);
    end

end
