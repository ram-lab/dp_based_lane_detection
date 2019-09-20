n = 5;
m = 5;
k = 1;
f = zeros(n*m, n*m);

load('graph_structure.mat');

% for r = 1:n-1
%     for c = 1:m
%         num_1 = (r-1)*m + c;        
%         for d = -1:1
%             j = c+d;
%             if (j<1) || (j>m) 
%                 continue;
%             end
%             num_2 = r*m + j;
%             edge = rand() + 0.00000001;
%             f(num_1, num_2) = edge;
%         end        
%     end
% end
% 
% for i = n*m-m+1:n*m
%     f(i, i) = 0.00000000000000001;
% end
% 
% edge_num = 0;
% edge_left = [];
% edge_right = [];
% edge_score = [];
% for r = 1:n*m
%     for c = 1:n*m
%         if f(r,c) ~= 0 
%             edge_num = edge_num + 1;
%             edge_left = [edge_left, r];
%             edge_right = [edge_right, c];
%             edge_score = [edge_score, f(r,c)];
%         end
%     end
% end

% disp(edge_num);
% disp(edge_left);
% disp(edge_right);
% disp(edge_score);

% W = [.41 .99 .51 .32 .15 .45 .38 .32 .36 .29 .21];
% DG = sparse([6 1 2 2 3 4 4 5 5 6 1],[2 6 3 5 4 1 6 3 4 3 5],W)

DG = sparse(edge_left, edge_right, edge_score);
% disp(DG);

h = view(biograph(DG,[],'ShowWeights','off'));

[dist, path, pred] = graphshortestpath(DG, 1, 23);
set(h.Nodes(path),'Color',[1 0.4 0.4])
edges = getedgesbynodeid(h,get(h.Nodes(path),'ID'));
set(edges,'LineColor',[1 0 0])
set(edges,'LineWidth',1.5)












