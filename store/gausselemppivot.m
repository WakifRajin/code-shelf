clear; clc;
A = [ 55,   0, -25; 
       0, -37,  -4; 
     -25,  -4,  29];
b = [-200; -250; 100];
Aug=[A b];
n=size(Aug,1);

for i=1:n-1   %  ← "which column am I clearing?" 

    % --- Partial Pivoting ---
    [~, P] = max(abs(Aug(i:n, i)));
    pivot_row = P + i - 1;
    
    % Swap
    Aug([i,pivot_row],:)=Aug([pivot_row, i],:);

    % --- Forward Elimination ---
    for j=i+1:n     % ← "which row below am I zeroing?"   (j,i) mane jei entry gula amra zero banabo
        key=Aug(j,i)/Aug(i,i);
        Aug(j,:)=Aug(j,:)-key*Aug(i,:);
    end
end

disp('Augmented Matrix after Elimination:');
disp(Aug);

% Back Substitution
x=zeros(1,n);

for i=n:-1:1
    hg=sum(Aug(i,i+1:n).*x(i+1:n));
    x(i)=(Aug(i,end)-hg)./Aug(i,i);
end

disp('Solution x:');
disp(x);