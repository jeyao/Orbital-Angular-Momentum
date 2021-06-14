function St = generateChirp(t,T,B,Tr,f0)
%GENERATELFM �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵
    K=B/T;
    rect = rectPulse(t,T,Tr);
    St = exp(1j*pi*K*t.^2)...
        .* exp(1j*2*pi*f0*t)...
        .* rect;
end

