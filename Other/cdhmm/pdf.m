function p = pdf(m, v, x)
%计算多元高斯密度函数
%输入:
%  m -- 均值向量, SIZE*1
%  v -- 方差向量, SIZE*1
%  x -- 输入向量, SIZE*1
%输出:
%  p -- 输出概率

p = (2 * pi * prod(v)) ^ -0.5 * exp(-0.5 * (x-m) ./ v * (x-m)');
