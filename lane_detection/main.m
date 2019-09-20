%% main program for lane detection, created by Jianhao JIAO, 20190402
% TODO: multiple vanishing point to calculate gradient direction; 

% clc; 
% clear; 
close all;
addpath('./utils');

%% set prelimary parameters
[dataDir, nImage, imgList, paramCamera, paramBirdView, paramDP, paramRANSAC] = config();

%% main process
for iImg = 1:1:length(imgList)
    close all;    
    if iImg > nImage
        break;
    end    
    imgName = imgList(iImg).name;
    sprintf("%s", imgName)
    
    imgRGB = imread([dataDir, imgName]);
    lanePositionY = [1; 1241];
    vp = [size(imgRGB, 1); size(imgRGB, 2)] / 2;
    alphaU = atan(size(imgRGB, 2) / (2 * paramCamera.fx));
    alphaV = atan(size(imgRGB, 1) / (2 * paramCamera.fy));
   
    %% generate birdview image
    % set birdview parameters (variable)
    paramBirdView.imgRGB = imgRGB;
    paramBirdView.lanePositionY = lanePositionY;    
    paramBirdView.vp = vp;
    paramBirdView.alphaU = alphaU;    
    paramBirdView.alphaV = alphaV;    
    paramBirdView.imgBirdView = generatebirdview(paramBirdView);                     
    paramBirdView.Size = size(paramBirdView.imgBirdView);
    paramBirdView.imgHeight = size(paramBirdView.imgBirdView, 1);
    paramBirdView.imgWidth = size(paramBirdView.imgBirdView, 2);    

    paramBirdView.imgEdge = edge(rgb2gray(paramBirdView.imgBirdView),'Canny'); % edge function
    paramBirdView.imgGray = double(rgb2gray(paramBirdView.imgBirdView)) / 255; % gray function
    paramBirdView.imgFeature = paramBirdView.wEdge * paramBirdView.imgEdge + ...
        paramBirdView.wGray * paramBirdView.imgGray; % combined feature function

    if paramBirdView.visualize
%         figure, imshow(paramBirdView.imgGray, []), title('gray');
%         figure, imshow(paramBirdView.imgEdge, []), title('edge');    
        figure, imshow(paramBirdView.imgFeature, []); title('feature');
%         figure, imshow(1-paramBirdView.imgFeature, []); title('graph');
    end
    
    %% construct the designed graph and apply dynamic programming to find the shortest path
    % set dynamic programming parameters (variable)
    paramDP.Graph = 1 - paramBirdView.imgFeature;
    paramDP.V = paramBirdView.imgHeight;
    paramDP.U = paramBirdView.imgWidth;
    if (paramDP.V ~= size(paramDP.Graph, 1)) || (paramDP.U ~= size(paramDP.Graph, 2))
        printf('! graph size ~= V*U \n');
    end
    [vCost, vBeta] = dpforlanedetection(paramDP, paramRANSAC);
  
    %% Lane detection result
    fBridView = figure; figure(fBridView), imshow(paramBirdView.imgBirdView);
    fResult = figure; figure(fResult), imshow(paramBirdView.imgRGB);

    tCost = 250;
    vCoef = zeros(paramDP.nLane, paramRANSAC.nPolygen+1);
    for i = 1:paramDP.nLane
        Y = 1:0.5:paramBirdView.imgHeight; % from bottom to the top on the IPM
        X = max(0, min(paramBirdView.imgWidth, polyval(vBeta(i, :), Y)));

        [coef, v, u] = generatelaneresult(X, Y, paramBirdView, paramRANSAC);
        if (vCost(i) < tCost) 
            x = 1:0.1:paramBirdView.imgHeight;
            y = max(0, min(paramBirdView.imgWidth, polyval(vBeta(i, :), x)));  
            figure(fBridView); hold on
            plot(y, x, 'r-', 'LineWidth', 1);            
            figure(fResult); hold on
            plot(u, v, 'r-', 'LineWidth', 3.5);
        end
    end
end





