function [cartCoord,sphCoord] = getObsRectPlaneCoordinate(opt)
    
    addpath('..\Common');
    
    if (isfield(opt, 'active') && ~opt.active)
      return;
    end
    
    if ~isfield(opt,'obsRange') ||...
        isempty(opt.obsRange) 
        error('«Î ‰»Îπ€≤‚æÿ–Œ∑∂Œß');
    end
    
   if ~isfield(opt,'Z0') ||...
        isempty(opt.Z0) 
        error('«Î ‰»Î¥´≤•æ‡¿Î');
    end
    
    opt = checkField(opt, 'obsCount', {'numeric'},{'real','nonnan'},2^10);
    
    X = linspace (-opt.obsRange, opt.obsRange, opt.obsCount);
    Y = linspace (-opt.obsRange, opt.obsRange, opt.obsCount);
    [cartCoord,sphCoord] = getObsPlaneCoordinate(X,Y,opt.Z0);
    
end

