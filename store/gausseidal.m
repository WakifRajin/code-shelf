% Matrix A and vector b organized such that Matrix A is Diagonally Dominant

A = [ 55,   0, -25; 
       0, -37,  -4; 
     -25,  -4,  29];
b = [-200; -250; 100];

% Initial guess: I1 = I3 = I4 = 1
x = [1; 1; 1]; 
iterations = 20;
n = length(b);
tol=0.00000005;
err=1;


fprintf('Iteration |    I1    |    I3    |    I4    \n');
fprintf('------------------------------------------\n');

for k = 1:iterations
    x_old=x;
    for j = 1:n
        sum = 0;
        for i = 1:n
            if j ~= i
                sum = sum + A(j,i) * x(i);
            end
        end
        x(j) = (b(j) - sum) / A(j,j);
    end
    err=max(abs((x-x_old)./x));
    fprintf('    %d     | %8.3f | %8.3f | %8.3f\n', k, x(1), x(2), x(3));
    if err<=tol
        break;
    end
end