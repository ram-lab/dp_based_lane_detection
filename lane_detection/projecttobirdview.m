function imgIPM = projecttobirdview(height, width, R, C, K, im)
    hZoom = 15;
    wZoom = 20;
    imgSize = [height*hZoom, width*2*wZoom, 3];
    imgIPM = zeros(imgSize, 'uint8');

    T = [R, C];
    E_2_3 = [1 0 0; 0 0 -1; 0 1 0];
    [rows, cols, channels] = size(im);
    for X = -imgSize(2)/2+1:imgSize(2)/2
        for Y = 50:imgSize(1)
            Z = 0;
            P_W = [X/wZoom; Y/hZoom; Z; 1];
            P_C = E_2_3 * T * P_W;
%             P_C = [P_C(1); -P_C(3); P_C(2)]; % world coordinate to camera coordinate
            p = K*P_C;
            p = p / p(3);
            u = p(1);
            v = p(2);
            if (u < 1) || (u > cols) || (v < 1) || (v > rows) 
                continue;
            end
            pixel = bi_interpolation(u, v, im);
            imgIPM(imgSize(1) - Y + 1, X + imgSize(2) / 2, :) = pixel;
        end 
    end
end





