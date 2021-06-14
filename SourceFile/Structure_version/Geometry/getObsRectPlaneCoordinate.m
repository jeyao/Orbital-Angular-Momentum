function [cartCoord,sphCoord] = getObsRectPlaneCoordinate(opt)
    
    addpath('..\Common');
    
    if (isfield(opt, 'active') && ~opt.active)
      return;
    end
    
    if ~isfield(opt,'obsRange') ||...
        isempty(opt.obsRange) 
        error('������۲���η�Χ');
    end
    
   if ~isfield(opt,'Z0') ||...
        isempty(opt.Z0) 
        error('�����봫������');
    end
    
    opt = checkField(opt, 'obsCount', {'numeric'},{'real','nonnan'},2^10);
    
    X = linspace (-opt.obsRange, opt.obsRange, opt.obsCount);
    Y = linspace (-opt.obsRange, opt.obsRange, opt.obsCount);
    [cartCoord,sphCoord] = getObsPlaneCoordinate(X,Y,opt.Z0);
    
end

