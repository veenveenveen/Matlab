function hmm = baum(hmm, samples)

mix  = hmm.mix;			%高斯混合
N    = length(mix);		%HMM状态数
K    = length(samples);	%语音样本数
SIZE = size(samples(1).data,2); %参数阶数

% 计算前向, 后向概率矩阵, 考虑多观察序列和下溢问题
disp('计算样本参数...');
for k = 1:K
    fprintf('%d ',k)
	param(k) = getparam(hmm, samples(k).data);
end
fprintf('\n')

% 重估转移概率矩阵A: trans
disp('重估转移概率矩阵A...')
for i = 1:N-1
	denom = 0;
	for k = 1:K
		tmp   = param(k).ksai(:,i,:);
		denom = denom + sum(tmp(:));
	end
	for j = i:i+1
		nom = 0;
		for k = 1:K
			tmp = param(k).ksai(:,i,j);
			nom = nom   + sum(tmp(:));
		end
		hmm.trans(i,j) = nom / denom;
	end
end

% 重估混合高斯的参数
disp('重估混合高斯的参数...')
for l = 1:N
for j = 1:hmm.M(l)
	fprintf('%d,%d ',l,j)
	% 计算各pdf的均值和方差
	nommean = zeros(1,SIZE); 
	nomvar  = zeros(1,SIZE); 
	denom   = 0;
	for k = 1:K
		T = size(samples(k).data,1);
		for t = 1:T
			x	    = samples(k).data(t,:);
			nommean = nommean + param(k).gama(t,l,j) * x;
			nomvar  = nomvar  + param(k).gama(t,l,j) * (x-mix(l).mean(j,:)).^2;
			denom   = denom   + param(k).gama(t,l,j);
		end
	end
	hmm.mix(l).mean(j,:) = nommean / denom;
	hmm.mix(l).var (j,:) = nomvar  / denom;

	% 计算各pdf的权
	nom   = 0;
	denom = 0;
	for k = 1:K
		tmp = param(k).gama(:,l,j);    nom   = nom   + sum(tmp(:));
		tmp = param(k).gama(:,l,:);    denom = denom + sum(tmp(:));
	end
	hmm.mix(l).weight(j) = nom/denom;
end
fprintf('\n')
end
