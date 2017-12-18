function param = getparam(hmm, O)
%给定输出序列O, 计算前向概率alpha, 后向概率beta, 标定系数c, 及ksai,gama
%输入:
%  hmm -- HMM模型参数
%  O   -- n*d 观察序列
%输出:
%  param -- 包含各种参数的结构

T = size(O,1);	%序列的长度

init  = hmm.init;	%初始概率
trans = hmm.trans;	%转移概率
mix   = hmm.mix;	%高斯混合
N     = hmm.N;		%HMM状态数

% 给定观察序列O, 计算前向概率alpha
alpha = zeros(T,N);

% t=1的前向概率
x = O(1,:);
for i = 1:N
	alpha(1,i) = init(i) * mixture(mix(i),x);	
end

% 标定t=1的前向概率
c    = zeros(T,1);
c(1) = 1/sum(alpha(1,:));		
alpha(1,:) = c(1) * alpha(1,:);

% t=2:T的前向概率和标定
for t = 2:T
	for i = 1:N
		temp = 0;
		for j = 1:N
			temp = temp + alpha(t-1,j) * trans(j,i);
		end
		alpha(t,i) = temp * mixture(mix(i),O(t,:));
	end
	c(t) = 1/sum(alpha(t,:));
	alpha(t,:) = c(t)*alpha(t,:);
end

% 给定观察序列O, 计算后向概率beta
beta = zeros(T,N);

% t=T的后向概率及标定
for l = 1:N
	beta(T,l) = c(T);	
end

% t=T-1:1的后向概率和标定
for t = T-1:-1:1
	x = O(t+1,:);
	for i = 1:N
	for j = 1:N
		beta(t,i) = beta(t,i) + beta(t+1,j) * mixture(mix(j),x) * trans(i,j);
	end
	end
	beta(t,:) = c(t) * beta(t,:);
end

%过渡概率ksai
ksai = zeros(T-1,N,N);
for t = 1:T-1
	denom = sum(alpha(t,:).*beta(t,:));
	for i = 1:N-1
	for j = i:i+1
		nom = alpha(t,i) * trans(i,j) * mixture(mix(j),O(t+1,:)) * beta(t+1,j);
		ksai(t,i,j) = c(t) * nom/denom;
	end
	end
end

%混合输出概率:gama
gama = zeros(T,N,max(hmm.M));
for t = 1:T
	pab = zeros(N,1);
	for l = 1:N
		pab(l) = alpha(t,l) * beta(t,l);
	end
	x = O(t,:);
	for l = 1:N
		prob = zeros(mix(l).M,1);
		for j = 1:mix(l).M
			m = mix(l).mean(j,:);
			v = mix(l).var (j,:);
			prob(j) = mix(l).weight(j) * pdf(m, v, x);
		end
		tmp  = pab(l)/sum(pab);
		for j = 1:mix(l).M
			gama(t,l,j) = tmp * prob(j)/sum(prob);
		end
	end
end

param.c     = c;
param.alpha = alpha;
param.beta  = beta;
param.ksai  = ksai;
param.gama  = gama;
