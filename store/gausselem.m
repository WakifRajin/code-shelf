clear; clc;
A = [ 55,   0, -25; 
       0, -37,  -4; 
     -25,  -4,  29];
b = [-200; -250; 100];
Aug = [A b];
n = size(A, 1);

% Forward Elimination
for i = 1:n-1
    for j = i+1:n
        key = Aug(j,i) / Aug(i,i);
        Aug(j,:) = Aug(j,:) - key * Aug(i,:);
    end
end

% Back Substitution
x = zeros(n, 1); % Initializing as column vector
for i = n:-1:1
    % Use x(i+1:n) to match the known values calculated in previous iterations
    hg = Aug(i, i+1:n) * x(i+1:n); 
    x(i) = (Aug(i, end) - hg) / Aug(i, i);
end

disp('Upper Triangular Matrix:');
disp(Aug);
disp('Solution Vector x:');
disp(x);