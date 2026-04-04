% --- Define your ODE here ---
f = @(x, y) x + y;

% --- Initial Conditions ---
x(1) = 0;                    
y(1) = 1;
h    = 0.1;
xn   = 1;

n = round((xn - x(1)) / h);   

% --- RK4 Loop ---
for i = 1 : n
    k1 = h * f(x(i),        y(i));
    k2 = h * f(x(i) + h/2,  y(i) + k1/2);
    k3 = h * f(x(i) + h/2,  y(i) + k2/2);
    k4 = h * f(x(i) + h,    y(i) + k3);

    y(i+1) = y(i) + (1/6)*(k1 + 2*k2 + 2*k3 + k4);
    x(i+1) = x(i) + h;     
end

disp(y(end))