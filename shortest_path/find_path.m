function [p] = find_path(path, index, n, m)
    p = [(n-1)*m + index];
    for i = size(path, 1):-1:1
        p = [p;path(i,index)+(i-2)*m];
        index = path(i,index);        
    end
end