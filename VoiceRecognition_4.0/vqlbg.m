function r = vqlbg(d,k) 
% VQLBG Vector quantization using the Linde-Buzo-Gray algorithme 矢量量化
% 
% Inputs: d contains training data vectors (one per column) d包含训练数据载体（每列）
% k is number of centroids required 需要的质心
% 
% Output: r contains the result VQ codebook (k columns, one for each centroids)R含有结果VQ码书（k列，为每个形心） 
e = .01; 
r = mean(d, 2); 
dpr = 10000; 

for i = 1:log2(k) 
    r = [r*(1+e), r*(1-e)]; 
    
    while (1 == 1) 
        z = disteu(d, r); 
        [m,ind] = min(z, [], 2); 
        t = 0; 
        for j = 1:2^i 
            r(:, j) = mean(d(:, find(ind == j)), 2); 
            x = disteu(d(:, find(ind == j)), r(:, j)); 
            for q = 1:length(x) 
                t = t + x(q); 
            end 
        end 
        if (((dpr - t)/t) < e) 
            break; 
        else 
            dpr = t; 
        end 
    end 
    
end

