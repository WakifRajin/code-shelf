clear; clc;
A = [ 55,   0, -25; 
       0, -37,  -4; 
     -25,  -4,  29];
b = [-200; -250; 100];
Aug = [A b];
n = size(Aug, 1);

% Gauss-Jordan Elimination
for i = 1:n
    % 1. Normalize the pivot row (make the diagonal element 1)
    Aug(i,:) = Aug(i,:) / Aug(i,i);
    
    % 2. Eliminate all other elements in the current column
    for j = 1:n
        if i ~= j
            key = Aug(j,i);
            Aug(j,:) = Aug(j,:) - key * Aug(i,:);
        end
    end
end

% The solutions are now sitting right in the last column
x = Aug(:, end);

disp('Final Augmented Matrix (Reduced Row Echelon Form):');
disp(Aug);

disp('Solutions:');
disp(x');