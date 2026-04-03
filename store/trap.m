function i = trap(a, h)
    if length(a)==2
        i = (h/2) .* (a(1)+a(end));
    else
        i = h/(2) .* (a(1)+2*sum(a(2:1:end-1))+a(end));
    end
end