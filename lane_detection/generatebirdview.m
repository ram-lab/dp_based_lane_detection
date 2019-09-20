%% project the original image to a bird view image
function [imgBirdView] = generatebirdview(param) 
    for i=1:1
        vpy_tmp = param.vp(1, 1);
        vpx_tmp = param.vp(2, 1);        

        roll = 0;
        pitch = atan(tan(param.alphaV) * (1 - 2 * vpy_tmp / size(param.imgRGB, 1)));
        yaw = atan(tan(param.alphaU) * (2 * vpx_tmp / size(param.imgRGB, 2) - 1));
    %         pitch = 0; 
    %         yaw = deg2rad(-20);

        angles = [0 pitch 0];
        R_y = eul2rotm(angles, 'ZYX');
        angles = [yaw 0 0];
        R_z = eul2rotm(angles, 'ZYX');
        R = R_z * R_y;
        C = [param.cx; param.cy; param.cz];        

        imgIPM = projecttobirdview(param.height, param.width, R, C, param.K, param.imgRGB);
        imgBirdView = imgIPM;
    end
end
                                
                                