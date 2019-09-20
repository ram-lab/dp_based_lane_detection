%% reproject the model in bird view image to the original image
function [coef, v, u] = generatelaneresult(X, Y, paramBirdView, paramRANSAC)

    vpy_tmp = paramBirdView.vp(1, 1);
    vpx_tmp = paramBirdView.vp(2, 1);        

    roll = 0;
    pitch = atan(tan(paramBirdView.alphaV) * (1 - 2 * vpy_tmp / size(paramBirdView.imgRGB, 1)));
    yaw = atan(tan(paramBirdView.alphaU) * (2 * vpx_tmp / size(paramBirdView.imgRGB, 2) - 1));
%     pitch = 0;
%     yaw = 0;    

    angles = [0 pitch 0];
    R_y = eul2rotm(angles, 'ZYX');
    angles = [yaw 0 0];
    R_z = eul2rotm(angles, 'ZYX');
    R = R_z * R_y;
    C = [paramBirdView.cx; paramBirdView.cy; paramBirdView.cz];

    [coef, v, u] = backprojecttoorigin(R, C, paramBirdView.K, X, Y, ...
        size(paramBirdView.imgBirdView), paramRANSAC.nPolygen);

end
                                
                                
                                