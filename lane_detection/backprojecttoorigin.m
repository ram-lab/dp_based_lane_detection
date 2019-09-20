function [coef, v, u] = backprojecttoorigin(R, C, K, X, Y, imgSize, nPolygen)
    hZoom = 15;
    wZoom = 20;
    
    T = [R, C];
    E_2_3 = [1 0 0; 0 0 -1; 0 1 0];
          
    P_W = [(X-imgSize(2)/2)/wZoom; (imgSize(1)-Y+1)/hZoom; zeros(1, length(X)); ones(1, length(X))];
    P_C = E_2_3 * T * P_W;
    p = K*P_C;
    p = p ./ p(3, :); % u=p(1), v=p(2), p_3*287
    
    coef = polyfit(p(2,:), p(1,:), nPolygen);
    v = p(2,:);
    u = p(1,:);
end




