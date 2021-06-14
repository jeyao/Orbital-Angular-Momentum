function St = generateSteppedFreq(t,T,B,Tr,f0,nSteppedFreq)
%GENERATELFM 此处显示有关此函数的摘要
%   此处显示详细说
    nPulse = floor(t/Tr);
    df = B / (nSteppedFreq-1);
    f = f0 + nPulse * df ; 
    rect = rectPulse(t-T/2,T,Tr);
    St = exp(1j*2*pi*f.*t)...
        .* rect;
end

