% ============================================================
% NEWTON'S DIVIDED DIFFERENCE INTERPOLATION
% ============================================================

x = [0, 1, 2, 3, 4, 5];        % x data points
y = [0, 1, 4, 9, 16, 25];      % y data points = f(x)
xx = 2.5;                       % point to interpolate at

b = zeros(n, n);
b(:,1) = y(:);                  % first column = y values

for j = 2 : n
    for i = 1 : n-j+1
        b(i,j) = (b(i+1,j-1) - b(i,j-1)) / (x(i+j-1) - x(i));
    end
end


xt   = 1;
yint = b(1,1);                  % start with f[x0]

for j = 1 : n-1
    xt   = xt * (xx - x(j));   % build up product term
    yint = yint + b(1,j+1) * xt;
end

disp(yint)