f = @(x) sin(x)-x;    %enter your function here
%can input data points too if h is the same
points = input("How many data points\n");
bracket = zeros(2,1);
for i = 1:2
    bracket(i) = input("Enter Interval Limit " + i + "\n");
end
a = linspace(bracket(1), bracket(2), points);
y=f(a);
segments = points-1;
h = a(2)-a(1);
if segments == 1
    i = trap(y, h);
elseif segments == 2
    i = s13(y,h);
elseif segments == 3
    i = s38(y,h);
elseif segments>3 && rem(segments,2)==0
    i = s13(y,h);
elseif segments==5
    i = s13(y(1:3), h)+s38(y(3:6), h);
elseif segments>6 && rem(segments,2)~=0
    i = s13(y(1:end-3),h)+s38(y(end-3:end),h);
end
