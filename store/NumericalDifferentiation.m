x = [0, 1, 2, 3, 4, 5];       % x values (uniformly spaced)
y = [0, 1, 4, 9, 16, 25];      % y values = f(x)
n = length(x);
h = x(2) - x(1);               % step size

dydx=zeros(1,n);

% first order formula
% fwd = (y(i+1) - y(i)) / h;
% bwd = (y(i) - y(i-1)) / h;

% using second order

for i=1:n
    if i==1
        dydx(i)=(-3*y(i) + 4*y(i+1) - y(i+2)) / (2*h);
    elseif i<n
        dydx(i) = (y(i+1) - y(i-1)) / (2*h);
    elseif i==n
        dydx(i) = (3*y(i) - 4*y(i-1) + y(i-2)) / (2*h);
    end
end

disp(dydx);