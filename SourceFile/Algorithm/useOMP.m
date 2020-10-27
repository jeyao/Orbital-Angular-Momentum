function x = useOMP(k, A, y)
    xbeg = zeros(size(A,2),1);

    support=[];

    temp=y;

    count = 1;

    while count < k+1

        ST = abs(A' * temp);

        [~, b] = max(ST);

        support = [support b];

        xfinal = A(:, support)\y;

        temp = y-A(:,support) * xfinal;

        count = count + 1;

    end

    x = xbeg;

    t = support';

    x(t) = xfinal;
end

