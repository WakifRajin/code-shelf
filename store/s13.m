function i = s13(a, h)
    if length(a)==3
        i = (h/3) .* (a(1)+4*a(2)+a(3));
    elseif length(a)==2
        i = trap(a,h);
    else
        i = (h/3) .* (a(1)+4*sum(a(2:2:end-1))+2*sum(a(3:2:end-2))+a(end));
    end
end