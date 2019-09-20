function [ bFitting, beta] = modelfitting(pts, param)

%RANSAC Use RANdom SAmple Consensus to fit a line
%	RESCOEF = RANSAC(PTS,ITERNUM,THDIST,THINLRRATIO) PTS is 2*n matrix including 
%	n points, ITERNUM is the number of iteration, THDIST is the inlier 
%	distance threshold and ROUND(THINLRRATIO*SIZE(PTS,2)) is the inlier number threshold. The final 
%	fitted line is RHO = sin(THETA)*x+cos(THETA)*y.
%	Yan Ke @ THUEE, xjed09@gmail.com

ptNum = size(pts,1);
sampleNum = round(ptNum * param.ratioSample);
thInlr = round(ptNum * param.ratioInlier);

inlrNum = zeros(param.nIter, 1);
polyCoef = zeros(param.nIter, param.nPolygen+1);

for k = 1:param.nIter
	% 1. fit using 2 random points
	sampleIdx = randIndex(ptNum, sampleNum);
	ptSample = pts(sampleIdx, :);   
    f = polyfit(ptSample(:,1), ptSample(:,2), param.nPolygen);
    polyCoef(k, :) = f;
    y = polyval(f, pts(:, 1));
    error = sqrt((pts(:, 2) - y).^2);
    inlrNum(k) = sum(error <= param.thDist);  
end

[maxInlrNum, I] = max(inlrNum);
if maxInlrNum >= thInlr
    bFitting = true;
else
    bFitting = false;
end

beta = polyCoef(I, :);

% y = polyval(beta, pts(:,1));
% figure,
% plot(pts(:,1), pts(:,2), 'o'), hold on,
% plot(pts(:,1), y, 'r--');

end
