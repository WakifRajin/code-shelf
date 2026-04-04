clear sum;

X = [0 1 2 3 4 5];
Y = [2.1 7.7 13.6 27.2 40.9 61.1];
n = length(X);

% Powers
D = X.^2;
E = X.^3;
F = X.^4;
G = X.*Y;
H = (X.^2).*Y;

% Build system
A = [n sum(X) sum(D);
     sum(X) sum(D) sum(E);
     sum(D) sum(E) sum(F)];

B = [sum(Y); sum(G); sum(H)];

% Solve for coefficients [a0, a1, a2]
a = A\B;

% Results
Sr = sum((Y - a(1) - a(2).*X - a(3).*(X.^2)).^2);
St = sum((Y - mean(Y)).^2);
r_2 = (St-Sr)/St;

fprintf('a0 = %.4f\n', a(1));
fprintf('a1 = %.4f\n', a(2));
fprintf('a2 = %.4f\n', a(3));
fprintf('r^2    = %.4f\n', r_2);