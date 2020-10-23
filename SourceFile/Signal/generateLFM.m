function St = generateLFM(t,T,B,Tr,f0)
%GENERATELFM 此处显示有关此函数的摘要
%   此处显示详细说明
    addpath('.\Baisc');
    K=B/T;
    rect = rectPulse(t,T,Tr);
    St = exp(1j*pi*K*t.^2)...
        .* exp(1j*2*pi*f0*t)...
        .* rect;
end

