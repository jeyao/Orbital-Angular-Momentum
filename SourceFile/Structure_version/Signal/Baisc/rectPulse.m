function sig = rectPulse(t,Tp,Ts)
    % 得到矩形脉冲
    % 信号范围为 -Tp/2 ~ Tp/2
    tmp = mod(t+Tp/2,Ts);
    sig = 1*(abs(tmp)<Tp);
end

