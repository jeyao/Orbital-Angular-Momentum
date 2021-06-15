function theta = useOMP(y, A, k)
%% Orthogonal Matching Pursuit (OMP) 
% Inputs:
%   - y Measurement vector
%   - A Compressive sensing matrix
%   - k Iteration step

    [M,N] = size(A);
    theta = zeros(N,1);
    aug = [];theta_pos = size(1,k);
    r_n = y;
    for i = 1: k
        product  = abs(A' * r_n);
        [~, pos] = max(abs(product));
        aug = [aug A(:,pos)];
        A(:,pos) = zeros(M,1);
        theta_ls=(aug'*aug)^(-1)*aug'*y;
        r_n = y-aug*theta_ls;
        theta_pos(i)=pos;
    end
    theta(theta_pos) = theta_ls ;
end
