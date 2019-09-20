function p = getshortestpath(P, i)
    p = zeros(size(P, 1)-1, 2);
    v = 1; u = i;
    while P(v, u) ~= -1
        p(v, :) = [v, u];
        u = P(v, u);
        v = v + 1;
    end
end