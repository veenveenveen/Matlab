function prob = mixture(mix,x)
%计算输出概率 
%输入：
% mix--混合高斯结构
% x--输入向量，SIZE*1
%输出：
% prob--输出概率

prob = 0;
for j=1:mix.M
    m = mix.mean(j,:);
    v = mix.var(j,:);
    w = mix.weight(j);
    prob = prob+w*pdf(m,v,x);
end

%防止log(prob)溢出
if prob==0
    prob = realmin;
end
