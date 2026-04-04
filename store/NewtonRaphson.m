% Problem 1: Newton-Raphson for System of Equations

% 1. Define the system of equations (F)
% x(1)=x, x(2)=y, x(3)=z
f = @(x) [x(1)*x(2)*x(3) - x(1)^2 + x(2)^2 - 1.34;
          x(1)*x(2) - x(3)^2 - 0.09;
          exp(x(1)) - exp(x(2)) + x(3) - 0.41];

% 2. Define the Jacobian Matrix (J)
% Rows are partial derivatives of eq 1, 2, and 3
J = @(x) [ (x(2)*x(3) - 2*x(1)), (x(1)*x(3) + 2*x(2)), (x(1)*x(2));
           (x(2)),               (x(1)),               (-2*x(3));
           (exp(x(1))),          (-exp(x(2))),         1 ];

% 3. Initialization
x_old = [1; 1; 1]; % Initial guesses for [x; y; z]
elimit = 0.01;     % 1% relative error limit
err = 1;
iter = 0;

% 4. Iteration Loop
while err > elimit
    F_val = f(x_old);
    J_val = J(x_old);
    
    % Newton-Raphson step: x_new = x_old - J^-1 * F
    x_new = x_old - J_val\F_val;
    
    % Calculate relative error
    err = max(abs((x_new - x_old) ./ x_new));
    
    x_old = x_new;
    iter = iter + 1;
end

fprintf('Problem 1 Solution after %d iterations:\n', iter);
fprintf('x = %.4f, y = %.4f, z = %.4f\n', x_new(1), x_new(2), x_new(3));