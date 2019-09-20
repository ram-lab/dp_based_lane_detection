%% disparity calculation from point cloud, created Jianhao JIAO, 20180815
% clc; 
clear; close all;

%% Camera intrinsics and extrinsics
%% 
% definition of P can refer to KITTI paper 20110926
P_rect_02 = [7.215377e+02 0.000000e+00 6.095593e+02 4.485728e+01 ...
            0.000000e+00 7.215377e+02 1.728540e+02 2.163791e-01 ...
            0.000000e+00 0.000000e+00 1.000000e+00 2.745884e-03];
P_02 = reshape(P_rect_02, [4,3])'; 
K = P_02(1:3, 1:3);
image_size = [375 1242 3];
focalLength = [K(1,1) K(2, 2)];
principalPoint = [K(1,3) K(2,3)];
camIntrinsics = cameraIntrinsics(focalLength,principalPoint,image_size(1:2));

R_velo_to_cam = [7.533745e-03 -9.999714e-01 -6.166020e-04; ...
                1.480249e-02 7.280733e-04 -9.998902e-01; ...
                9.998621e-01 7.523790e-03 1.480755e-02; ...
                0 0 0];              
t_velo_to_cam = [-4.069766e-03 -7.631618e-02 -2.717806e-01 1]';
T_velo_to_cam = [R_velo_to_cam, t_velo_to_cam];
% x = Pi * Tr * X

%% Read pointcloud
%%
N_pc = 1;
P_project_to_camera = [];
for i=1:N_pc
    filename_im = strcat(int2str(i), '.png');
    im = imread(filename_im);
    filename_pc = strcat(int2str(i), '.pcd');
    cloud_input = pcread(filename_pc); 
    for j=1:cloud_input.Count
        P = [cloud_input.Location(j, :), 1]';
        P_camera = T_velo_to_cam * P;
        p = P_02 * P_camera;
        p = p / p(3);
        if (p(1) < 1) || (p(1) > image_size(2)) || (p(2) < 1) || (p(2) > image_size(1))
            continue;
        end
        P_project_to_camera = [P_project_to_camera, P_camera];
%         im(floor(p(2)), floor(p(1)), :) = [floor(p(2)/image_size(1)*255), ...
%             floor(p(1)/image_size(2)*255), 128];
        im(floor(p(2)), floor(p(1)), :) = [255, 0, 0];
    end
    figure, imshow(im), hold on, title('projection'), hold off;
end

