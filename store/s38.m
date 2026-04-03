function i = s38(a, h)
    if length(a)==4
        i = (3*h/8) .* (a(1)+3*(a(2)+a(3))+a(end));
    elseif length(a)==3
        i = s13(a,h);
    elseif length(a)==2
        i = trap(a,h);
    else
        i = (3*h/8) .* (a(1)+3*sum(a(2:3:end-2))+3*sum(a(3:3:end-1))+2*sum(a(4:3:end-3))+a(end));
    end
end