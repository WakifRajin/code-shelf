x  = [0, 1, 2, 3, 4, 5];       % x values
y  = [0, 1, 4, 9, 16, 25];     % y values = f(x)
xx = 2.5;                       % point to interpolate at

n  = length(x);

yint = 0;                     

for i = 1 : n
    num = 1;                     % numerator   product
    den = 1;                     % denominator product

    for j = 1 : n
        if j ~= i
            num = num * (xx   - x(j));   % (xx  - xj)
            den = den * (x(i) - x(j));   % (xi  - xj)
        end
    end

    yint = yint + y(i)*(num/den);         

end

fprintf('  Interpolated value y(%.4f) = %.6f\n', xx, yint);