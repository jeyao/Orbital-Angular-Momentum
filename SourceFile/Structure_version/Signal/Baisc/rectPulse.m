function sig = rectPulse(t,Tp,Ts)
    % �õ���������
    % �źŷ�ΧΪ -Tp/2 ~ Tp/2
    tmp = mod(t+Tp/2,Ts);
    sig = 1*(abs(tmp)<Tp);
end

