clc; clear;

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

f = @(x) [(x(1).^2+x(2).^2+x(3).^2-14);
               x(1).^2+2*x(2).^(2)-9;
               x(1)-3*x(2).^2+x(3).^2];

j = @(x) [2*x(1)    2*x(2)    2*x(3);
               2*x(1)    4*x(2)    0;
               1           -6*x(2)   2*x(3)];

ic=0;
es = 1e-4;
ea = inf;
size(f([1 1 1]))
xold = zeros(size(f([1 1 1]), 1),1);
for i = 1:size(f([1 1 1]),1)
    xold(i) = input("Enter Initial Guesses");
end
while ea>es
    ic = ic+1;
    xnew = xold + gem(j(xold),-f(xold));
    ea = max(abs(xnew-xold));
    xold = xnew;
end

disp(xnew)
disp(ic)