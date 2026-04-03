clc;clear;
function x = gjm(a,b)
    n = size(a,1);
    aug = [a b];
    for k = 1:n
        [~, mr] = max(abs(aug(k:n,k)));
        mr = mr+k-1;
        if mr ~= k
            aug([k mr], :) = aug([mr k], :);
        end
        aug(k,k:end) = aug(k, k:end)./aug(k,k);
        for i=1:n
            if i~=k
                aug(i,k:end) = aug(i,k:end)-aug(k,k:end).*aug(i,k);
            end
        end
    end
    x = aug(:,end);
end
A = [ 6 -2 2 4; 12 -8 6 10; 3 -13 9 3; -6 4 1 -18];
b = [12; 34; 27; -38];
soln = gjm(A,b);