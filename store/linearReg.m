clear sum;

X = [0 1 2 3 4 5];
Y = [2.1 7.7 13.6 27.2 40.9 61.1];
n = length(X);

% Powers
D = X.^2;
G = X.*Y;

% Build system
A = [n sum(X);
     sum(X) sum(D)];

B = [sum(Y); sum(G)];

% Solve for coefficients [a0, a1, a2]
a = A\B;

% Results
Sr = sum((Y - a(1) - a(2).*X).^2);
St = sum((Y - mean(Y)).^2);
r_2 = (St-Sr)/St;

fprintf('a0 = %.4f\n', a(1));
fprintf('a1 = %.4f\n', a(2));
fprintf('r^2    = %.4f\n', r_2);