function Sr = getSr(lRange,t,T,B,Tr,f0,nSteppedFreq,RCS,mPhi,mTheta,a)
    nT = length(t);
    nL = length(lRange);
    Sr = zeros(1,nL*nT);
    for i = 1:nL
        Sr((i-1)*nT+1:i*nT) = getSubSr(t,T,B,Tr,f0,nSteppedFreq,a,lRange(i),RCS,mPhi,mTheta);
    end
end

function Sr = getSubSr(t,T,B,Tr,f0,nSteppedFreq,a,l,RCS,mPhi,mTheta)

c = 299792458 ;
nPulse = floor(t/Tr);
df = B / (nSteppedFreq-1);
f = f0 + nPulse * df ; 
rect = rectPulse(t-T/2,T,Tr);
Sr = RCS * (...
    rect.*exp(1i*2.0*pi*t.*f)...
    .* besselj(l,f*2*pi*a.*sin(mTheta')/c).^2 ...
    .* exp(1i*2.0*l*(mPhi'))...
    );
end