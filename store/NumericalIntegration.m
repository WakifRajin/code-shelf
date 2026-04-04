x = [0, 1, 2, 3, 4, 5];          % x values (must be in order)
y = [0, 1, 4, 9, 16, 25];         % y values = f(x)

n = length(x);                    % Number of data points
h = 1;                            %considering uniform

% --- Apply Trapezoidal Rule ---
trap = 0;               % Initialize sum

for i = 1 : n-1
    trap = trap + (h / 2) * (y(i) + y(i+1));
end
disp(trap)

% --- Apply Simpson's 1/3 Rule ---  (n-1) no. of steps must be multiple of 2
sim13 = y(1) + y(n);            % First + last
for i = 2 : n-1
    if mod(i,2) == 0
        sim13 = sim13 + 4*y(i); % Even-indexed points
    else
        sim13 = sim13 + 2*y(i); % Odd-indexed points
    end
end
sim13 = (h/3) * sim13;
disp(sim13)

% --- Apply Simpson's 3/8 Rule ---  (n-1) no. of steps must be multiple of 3
sim38 = y(1) + y(n);            % First + last
for i = 2 : n-1
    if mod(i-1, 3) == 0
        sim38 = sim38 + 2*y(i); 
    else
        sim38 = sim38 + 3*y(i); 
    end
end
sim38 = (3*h/8) * sim38;
disp(sim38)

