function [] = plotAxial( sig, opt )

addpath('..\Common');
% �ж��Ƿ����
if (isfield(opt, 'active') && ~opt.active)
  return;
end  

if ~isfield(opt,'obsRange') ||...
    isempty(opt.obsRange) 
    c = 299792458 ;                        % ���� m/s
    lambda = c / sig.physical.frequency ;  % ���� m
    opt.obsRange = 25 * lambda;
end

opt = checkField(opt, 'obsCount', {'numeric'},{'real','nonnan'},2^10);
opt = checkField(opt, 'nFigure', {'numeric'},{'real','positive','nonnan'},1);
opt = checkField(opt, 'type', {'char'},{},'intensity');
opt = checkField(opt, 'title', {'char'},{},'');


X = linspace (-opt.obsRange, opt.obsRange, opt.obsCount);

if ~isfield(opt,'nFigure') ||...
    isempty(opt.nFigure) 
    figure();
else
    figure(opt.nFigure);
end

if strcmp(opt.type, 'intensity')
    plot(X,abs(sig.samples{1}(floor(opt.obsCount/2),:)),'k');
    title(opt.title);
    xlim([min(X),max(X)]);
end

if strcmp(opt.type, 'phase')
    plot(X,angle(sig.samples{1}(floor(opt.obsCount/2),:))/pi*180,'k');
    title(opt.title);
    xlim([min(X),max(X)]);
end

end

