%	by lkk@mails.tsinghua.edu.cn

function [lpc_number] = lpc(frames,rank);

%   输入：
%      frames       输入帧 
%      rank         lpc阶数 
%   输出：
%       lpc_number  lpc系数矩阵，rank行n列向量
[windowsize, numframes] = size(frames);


lpc_number = [];


% 用自相关法计算lpc系数
for nFrame = 1:numframes
    R = zeros(rank+1,1);
    alpha = zeros(rank,rank);
    E = zeros(rank+1,1);
    k = zeros(rank,1);
    for i = 1:rank+1
        R(i) = sum(frames(i:windowsize,nFrame).*frames(1:windowsize-i+1,nFrame));
    end
    
    E(1) = R(1);
    for i = 1:rank
        tmpSum = 0;
        for j = 1:i-1
            tmpSum = tmpSum + alpha(j,i-1)*R(i-j+1);
        end
        k(i) = (R(i+1) - tmpSum)/E(i);
        alpha(i,i) = k(i);
        for j = 1:i-1
            alpha(j,i) = alpha(j,i-1) - k(i)*alpha(i-j,i-1);
        end
        E(i+1) = (1-k(i)*k(i))*E(i);
    end
    
    % lpc系数
    lpc_number = [lpc_number,alpha(:,rank)];

end