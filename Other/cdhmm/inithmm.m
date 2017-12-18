function hmm = inithmm(samples, M)

K = length(samples);	%语音样本数
N = length(M);			%状态数
hmm.N = N;
hmm.M = M;

% 初始概率矩阵
hmm.init    = zeros(N,1);
hmm.init(1) = 1;

% 转移概率矩阵
hmm.trans=zeros(N,N);
for i=1:N-1
	hmm.trans(i,i)   = 0.5;
	hmm.trans(i,i+1) = 0.5;
end
hmm.trans(N,N) = 1;

% 概率密度函数的初始聚类
% 平均分段
for k = 1:K
	T = size(samples(k).data,1);
	samples(k).segment=floor([1:T/N:T T+1]);
end

%对属于每个状态的向量进行K均值聚类,得到连续混合正态分布
for i = 1:N
	%把相同聚类和相同状态的向量组合到一个向量中
	vector = [];
	for k = 1:K
		seg1 = samples(k).segment(i);
		seg2 = samples(k).segment(i+1)-1;
		vector = [vector ; samples(k).data(seg1:seg2,:)];
	end
	mix(i) = getmix(vector, M(i));
end

hmm.mix = mix;

function mix = getmix(vector, M)

[mean esq nn] = kmeans(vector,M);

% 计算每个聚类的标准差, 对角阵, 只保存对角线上的元素
for j = 1:M
	ind = find(j==nn);
	tmp = vector(ind,:);
	var(j,:) = std(tmp);
end

% 计算每个聚类中的元素数, 归一化为各pdf的权重
weight = zeros(M,1);
for j = 1:M
	weight(j) = sum(find(j==nn));
end
weight = weight/sum(weight);

% 保存结果
mix.M      = M;
mix.mean   = mean;		% M*SIZE
mix.var    = var.^2;	% M*SIZE
mix.weight = weight;	% M*1
