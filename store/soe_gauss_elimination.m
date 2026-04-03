clc;clear
function x = gem(A,b)
    n = size(A,1);
    aug = [A b];
    for k = 1:n-1
        for i = k+1:n
            factor = aug(i,k)/aug(k,k);
            aug(i, k:end) = aug(i, k:end) - aug(k,k:end) * factor;
        end
    end
    x = zeros(n,1);
    for j = n:-1:1
        x(j) = (aug(j,end)-aug(j,j+1:n)*x(j+1:n))/aug(j,j);
    end
end
A = [ 6 -2 2 4; 12 -8 6 10; 3 -13 9 3; -6 4 1 -18];
b = [12; 34; 27; -38];
soln = gem(A,b);