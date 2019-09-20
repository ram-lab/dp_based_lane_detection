function [vCost, vBeta] = dpforlanedetection(paramDP, paramRANSAC)

    graphDynamic = paramDP.Graph;
    maxCost = max(max(graphDynamic));
    vBeta = zeros(paramDP.nLane, paramRANSAC.nPolygen+1);
    vCost = zeros(paramDP.nLane, 1);

    for n = 1:1:paramDP.nLane
        % initialize paramDP.E and paramDP.P
        paramDP.E = ones(paramDP.V+1, paramDP.U) * paramDP.V;
        paramDP.E(paramDP.V+1, :) = 0;        
        paramDP.P = zeros(paramDP.V+1, paramDP.U);        
        paramDP.P(paramDP.V+1, :) = -1;        
        
        % dynamic programming
        for v = paramDP.V:-paramDP.pathStepDown:1
            for u = 1:1:paramDP.U
                for j = -paramDP.pathStepAside:1:paramDP.pathStepAside
                    if (u-j > paramDP.U) || (u-j < 1)
                        continue;
                    end
                    F = graphDynamic(v, u);
                    if paramDP.E(v, u) > paramDP.E(v+1, u-j) + F + paramDP.lambda*j.^2 
                        paramDP.E(v, u) = paramDP.E(v+1, u-j) + F + paramDP.lambda*j.^2;
                        paramDP.P(v, u) = u-j;
                    end
                end
            end
        end
        
        % model fitting
        [miniCost, i] = min(paramDP.E(1,:));
        p = getshortestpath(paramDP.P, i); % findshortestpath
        [bFitting, beta] = modelfitting(p, paramRANSAC); % modelfitting
        
        if bFitting == true
            vCost(n, 1) = miniCost;
            vBeta(n, :) = beta;    
            if paramDP.visualize
                figure; 
                imshow(graphDynamic); hold on;
                plot(p(:, 2), p(:, 1), 'r-', 'LineWidth', 1); hold off;                
            end
            for i = 1:paramDP.V
                uL = max(1, p(i,2)-20);
                uR = min(paramDP.U, p(i,2)+20);
                graphDynamic(i, uL:uR) = maxCost;
            end
        end     
    end    
    sprintf(['cost of shortest path:' repmat('%f ', 1, length(vCost))], vCost)
end
