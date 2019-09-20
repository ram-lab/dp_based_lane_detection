%% A visualization code for dynamic programming to find shortest paths
%%
% clc; close all; clear;
close all; 
n = 7;
m = 7;
k = 1;
f = zeros(n*m, n*m);

% graph construction
for r = 1:n-1
    for c = 1:m
        num_1 = (r-1)*m + c;        
        for d = -k:k
            j = c+d;
            if (j<1) || (j>m) 
                continue;
            end
            num_2 = r*m + j;
            edge = rand() + 0.00000001;
            f(num_1, num_2) = edge;
        end        
    end
end

for i = n*m-m+1:n*m
    f(i, i) = 0.00000000000000001;
end

edge_num = 0;
edge_left = [];
edge_right = [];
edge_score = [];
for r = 1:n*m
    for c = 1:n*m
        if f(r,c) ~= 0 
            edge_num = edge_num + 1;
            edge_left = [edge_left, r];
            edge_right = [edge_right, c];
            edge_score = [edge_score, f(r,c)];
        end
    end
end

% load('dp.mat');

% dynamic programming
energy = ones(n,m)*100;
path = zeros(n,m);
energy(1,:) = 0;
for r = 2:n
    for c = 1:m
        num_1 = (r-2)*m + c;        
        for d = -1:1
            j = c+d;
            if (j<1) || (j>m) 
                continue;
            end
            num_2 = (r-1)*m + j;
            if energy(r, j) > energy(r-1, c) + f(num_1, num_2)
                energy(r, j) = energy(r-1, c) + f(num_1, num_2);
                path(r, j) = c;
            end
        end        
    end
end

% dijstra, graph visualization 1
% path
% energy(5, :)
% for i = 1:m
%     p = find_path(path, i, n, m)'
% end

path_left = [];
path_right = [];
path_score = [];
for k = 1:1:m
    p = find_path(path, k, n, m);
    for i = size(p,1)-1:-1:2
        path_left = [path_left; p(i)];
        path_right = [path_right; p(i-1)];
        if mod(p(i-1), m) == 0
            r = floor(p(i-1)/m) ;
            c = m;    
        else
            r = floor(p(i-1)/m) + 1;
            c = p(i-1) - floor(p(i-1)/m)*m;            
        end
        path_score = [path_score;f(p(i),p(i-1))];
    end
end

x = []; 
y = [];
for r = 1:n
    x = [x;(1:1:m)'];
    y = [y;ones(m,1)*r];
end

% the whole graph structure
% l = length(edge_left);
% edge_left(l) = 49;
% edge_right(l) = 42;
% edge_score(l) = 0;

dp_sp_graph = figure;
G1 = digraph(edge_left, edge_right, edge_score);
% pl = plot(G1, 'EdgeLabel',G1.Edges.Weight, 'XData', x, 'YData', y);
p1 = plot(G1, 'XData', x, 'YData', y);
p1.MarkerSize = 18;
p1.LineWidth = 1;
p1.LineStyle = '-';
p1.EdgeColor = 'k';
p1.NodeColor = 'k';
p1.ArrowSize = 30;
% p1.ShowArrows = 'off';
p1.ArrowPosition = 0.95;
p1.NodeLabel = {}
set(gca, 'FontName', 'Times New Roman', 'FontSize', 40);

% shortest path of dp
for i = 1:length(edge_left)
    el = [edge_left(i); n*m];
    er = [edge_right(i); n*m];
    es = edge_score(i);
    line_width = es*10+1;
    TR = digraph(el, er, es);
    highlight(p1, TR, 'EdgeColor', 'k', 'NodeColor', 'k', 'LineWidth', line_width, 'LineStyle', '-');   
end

for i = 1:length(path_left)
    p1.LineStyle = '-';
    el = [path_left(i); n*m];
    er = [path_right(i); n*m];
    es = path_score(i);
    line_width = es(1)*10+1;
    TR = digraph(el, er, es);
    highlight(p1, TR, 'EdgeColor', 'r', 'NodeColor', 'r', 'LineWidth', line_width, 'LineStyle', '-');
end

TR = digraph([n*m], [n*m], [1]);
highlight(p1, TR, 'EdgeColor', 'k', 'NodeColor', 'r', 'LineWidth', 0.1, 'LineStyle', '-');


% TR = digraph(path_left, path_right, path_score);
% highlight(p1, TR, 'EdgeColor', 'r', 'NodeColor', 'r', 'LineWidth', 1, 'LineStyle', '-');

% lgd = legend(('   Black:edge    Red:shortest path'));
% lgd.FontSize = 40;

% axis ij; 
% axis off;
xlabel('u', 'FontSize', 80, 'FontName', 'Times New Roman');
ylabel('v', 'FontSize', 80, 'FontName', 'Times New Roman');
% title('Shortest paths from the bottom row to each node in the top row of a 7x7 graph', 'FontSize', 30);
% axis([0.5,m+1-0.5, 0.5,n+3]);
% set(gca, 'FontName', 'Times New Roman')

title('Shortest Paths Results');
axis square;
grid on;

% % dijstra, graph visualization 2
% DG = sparse(edge_left, edge_right, edge_score);
% h = view(biograph(DG,[],'ShowWeights','on', 'NodeAutoSize','on', 'ID','sdfs'));
% [dist, dij_path, pred] = graphshortestpath(DG, 2, 21);
% set(h.Nodes(dij_path),'Color',[1 0.4 0.4])
% edges = getedgesbynodeid(h,get(h.Nodes(dij_path),'ID'));
% set(edges,'LineColor',[1 0 0])
% set(edges,'LineWidth',1.5)

















