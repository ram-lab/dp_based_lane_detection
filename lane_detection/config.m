%% these parameters are set by users

function [dataDir, nImage, imgList, paramCamera, paramBirdView, paramDP, paramRANSAC] = config()

    dataDir = '/Monster/dataset/KITTI/2011_09_26/2011_09_26_drive_0028_sync/image_02/data/';
    nImage = 1000;
    imgList = dir([dataDir, '*.png']);    

    % set sensor intrinsics and extrinsics
    paramCamera.P_rect_02 = [7.215377e+02 0.000000e+00 6.095593e+02 4.485728e+01 ...
                            0.000000e+00 7.215377e+02 1.728540e+02 2.163791e-01 ...
                            0.000000e+00 0.000000e+00 1.000000e+00 2.745884e-03];
    P = reshape(paramCamera.P_rect_02, [4,3])'; 
    paramCamera.K = P(1:3, 1:3);
    paramCamera.fx = paramCamera.K(1, 1); 
    paramCamera.fy = paramCamera.K(2, 2);
    paramCamera.cx = 0; paramCamera.cy = 0; paramCamera.cz = -1.65;
    paramCamera.isSingleVP = true;

    % set birdview parameters (constant)
    paramBirdView.K = paramCamera.K;
    paramBirdView.cx = paramCamera.cx;
    paramBirdView.cy = paramCamera.cy;
    paramBirdView.cz = paramCamera.cz;
    paramBirdView.height = 30;
    paramBirdView.width = 8;
    paramBirdView.nSplit = 30;
    paramBirdView.isSingleVP = paramCamera.isSingleVP;
    paramBirdView.wEdge = 0.6; % set feature function parameters
    paramBirdView.wGray = 0.4;
    paramBirdView.visualize = false;

    % set dynamic programming parameters (constant)
    paramDP.coefBirdView = [];
    paramDP.pathStepDown = 1;
    paramDP.pathStepAside = 3;
    paramDP.lambda = 1;
    paramDP.nLane = 3;  
    paramDP.visualize = false;

    % set ransac parameters (constant)
    paramRANSAC.nIter = 50;
    paramRANSAC.thDist= 4;
    paramRANSAC.ratioInlier = 0.7;
    paramRANSAC.ratioSample = 0.1;
    paramRANSAC.nPolygen = 2;
    paramRANSAC.nCheck = 50;
    
end