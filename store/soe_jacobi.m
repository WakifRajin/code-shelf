clc; clear;

function [x, ic] = gs(A, b, xold)
    if size(xold, 2) ~=1
        xold = xold';
    end
    es = 0.1;
    ea = inf;
    n = size(A, 1);
    x = zeros(n, 1);
    aug = [A b];
    ic=0;
    while max(ea) > es
        ic = ic+1;
        for k = 1:n
        sum = 0;
            for i = 1:n
                if i ~= k
                    sum = sum+aug(k,i)*xold(i);
                end
            end
            x(k) = (aug(k, end) - sum) / aug(k, k);
        end
        ea = abs(x - xold);
        xold = x;
    end
end

k1 = 150; k2 = 50; k3 = 75; k4 = 225; m = 2000; g = 9.81; F = m*g;
A = [  k1+k2      -k2            0             0;
         -k2            k2+k3     -k3            0;
          0               -k3          k3+k4    -k4;
          0                0            -k4           k4; ];
b = [0; 0; 0; F];

[x,i]  = gs(A, b, [1 2 4 6])
