function [sig] = generateOAM(opt)

%
% UCA����������OAM�����漰�ź�Դ��б�ǣ�
%
% ========== INPUT PARAMETER ===========
%
% X, Y  : �۲�ƽ��� x �� y �����귶Χ
% f     : �ز�Ƶ��
% l     : OAM ģʽ��
% N     : ������Ԫ��
% a     : ���߰뾶 m
% amps  : ���߸���Ԫ�ļ���Դ����
% z0    : �۲�ƽ������ߵľ���
% tilt  : �ź�Դ����б��
% ============ OUTPUTS ===================
narginchk(1,1);
addpath('..\Common');
addpath('..\Geometry');
% �ж��Ƿ����
if (isfield(opt, 'active') && ~opt.active)
  return;
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

% ====== �������� =======

c = 299792458 ;                        % ���� m/s
lambda = c / opt.frequency ;           % ���� m

opt = checkField(opt, 'obsRange', {'numeric'},{'real','nonnan'},25*lambda);
opt = checkField(opt, 'obsCount', {'numeric'},{'real','nonnan'},2^10);
opt = checkField(opt, 'Z0', {'numeric'},{'real','nonnan'},25*lambda);
opt = checkField(opt, 'tilt', {'numeric'},{'real','nonnan'},0);
    
opt = checkField(opt, 'elemExcitation', {'numeric'},{'real','positive','nonnan','finite'},1);
opt = checkField(opt, 'arrayRadius', {'numeric'},{'real','nonnan'},2*lambda);


% ====== UCA���� =======

% elemPhi = 2.0 * pi  / opt.nElem * ( 0 :  opt.nElem - 1 );  % ���߸���Ԫ�ķ����

% ====== �����źŻ������� =======

X = linspace (-opt.obsRange, opt.obsRange, opt.obsCount);
Y = linspace (-opt.obsRange, opt.obsRange, opt.obsCount);
[~,sphCoord] = getObsPlaneCoordinate(X,Y,opt.Z0);
opt.sphCoord = sphCoord;
sig = calcOAM( opt );

end