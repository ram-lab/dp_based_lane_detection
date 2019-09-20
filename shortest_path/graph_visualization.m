n = 5;
m = 5;
k = 1;
f = zeros(n*m, n*m);

% graph construction
for r = 1:n-1
    for c = 1:m
        num_1 = (r-1)*m + c;        
        for d = -1:1
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

% for i = n*m-m+1:n*m
%     f(i, i) = 0.00000000000000001;
% end

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
% edge_left = flipud(edge_left);
% edge_right = flipud(edge_right);

G = digraph(edge_left, edge_right, edge_score);
% pl = plot(G, 'EdgeLabel',G.Edges.Weight);
pl = plot(G);
pl.MarkerSize = 11;
pl.EdgeColor = 'r';
pl.NodeColor = 'k';
% pl.ArrowSize = 10;
axis ij; 
axis off;

% hold on;
% pl2 = plot(G);
% pl2.MarkerSize = 8;
% pl2.EdgeColor = 'r';
% pl2.NodeColor = 'r';

