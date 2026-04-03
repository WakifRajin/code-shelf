function y = signal_cleanup(x, window)
%SIGNAL_CLEANUP Remove offset and smooth a signal using moving average.

if nargin < 2
    window = 5;
end

x = x(:);                      % Force column vector.
x = x - mean(x, "omitnan");   % Remove DC component.

kernel = ones(window, 1) / window;
y = conv(x, kernel, "same");
end
