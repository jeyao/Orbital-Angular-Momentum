function Sr = getSr(modes,t,T,B,Tr,f0,nSteppedFreq,RCS,mPhi,mTheta,arrRadius)
    c = 299792458 ;
    nPulse = floor(t/Tr);
    df = B / (nSteppedFreq-1);
    f = f0 - B/2 + nPulse * df ;
    rect = rectPulse(t-T/2,T,Tr);
    
    nT = length(t); nL = length(modes);
    Sr = zeros(1,nL*nT);
    for i = 1:nL
        mode = modes(i);
        Sr((i-1)*nT+1:i*nT) = RCS * (...
            rect.*exp(1i*2.0*pi*t.*f)...
            .* besselj(mode,f*2*pi*arrRadius.*sin(mTheta')/c).^2 ...
            .* exp(1i*2.0*mode*(mPhi'))...
            );
    end
end