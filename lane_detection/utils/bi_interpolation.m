function pixel = bi_interpolation(u, v, im)
    u_0 = floor(u); v_0 = floor(v); 
    du = u-u_0; dv = v-v_0;
    u_1 = u_0 + 1; v_1 = v_0 + 1;
    pixel = (1-du)*(1-dv) * im(v_0,u_0,:) ...
            + (1-du)*dv * im(v_1,u_0,:) ...
            + du*(1-dv) * im(v_0,u_1,:) ...
            + du*dv * im(v_1,u_1,:);
end