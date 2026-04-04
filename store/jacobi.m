clear; clc;

% Matrix A and vector b (Diagonally Dominant)
A = [ 55,   0, -25; 
       0, -37,  -4; 
     -25,  -4,  29];
b = [-200; -250; 100];

% Initial guess
x_old = [1; 1; 1];
iterations = 30;
n = length(b);
x_new = zeros(n,1);
err=1;
tol=0.0005;

fprintf('Iteration |    I1    |    I3    |    I4    \n');
fprintf('------------------------------------------\n');

for k = 1:iterations    
    for i = 1:n
        sum = 0;
        for j = 1:n
            if i ~= j
                sum = sum + A(i,j) * x_old(j);
            end
        end
        x_new(i) = (b(i) - sum) / A(i,i);
    end
    err=max(abs((x_new-x_old)./x_new));
    fprintf('    %d     | %8.3f | %8.3f | %8.3f\n', k, x_new(1), x_new(2), x_new(3));
    if err<=tol
        break;
    end
    x_old=x_new;
end