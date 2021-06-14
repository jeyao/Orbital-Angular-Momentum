function St = generateSteppedFreq(t,T,B,Tr,f0,nSteppedFreq)
%GENERATELFM �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵
    nPulse = floor(t/Tr);
    df = B / (nSteppedFreq-1);
    f = f0 + nPulse * df ; 
    rect = rectPulse(t-T/2,T,Tr);
    St = exp(1j*2*pi*f.*t)...
        .* rect;
end

