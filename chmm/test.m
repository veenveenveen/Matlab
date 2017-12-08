clear;
x0=wavread('0.wav');
%soundview('traffic69.wav');
x1=wavread('1.wav');
x2=wavread('2.wav');
x3=wavread('3.wav');
x4=wavread('4.wav');
x5=wavread('5.wav');
x6=wavread('6.wav');
x7=wavread('7.wav');
x8=wavread('8.wav');
x9=wavread('9.wav');

x = {x0 x1};
y = {x2 x3};
z = {x4 x5};
m = {x6 x7}; 
n = {x8 x9};

samples={x y z m n};


    sample=[];
    for k=1:length(samples{3})
        sample(k).wave = samples{3}{k};
        sample(k).data=[];
    end
    
K = length(sample);

%计算语音参数
disp('正在计算语音参数……')
for k=1:K
    if isfield(sample(k),'data')&~isempty(sample(k).data)
        continue;
    else
        sample(k).data = mfcc(sample(k).wave);  
    end
end

hmm = inithmm(sample,[3,3,3]);

loop =1;
    fprintf('\n第%d遍训练\n\n',loop)
    hmm = baum(hmm,sample);
    
    %计算总输出概率
    pout(loop) = 0;
for k=1:K
        
init = hmm.init; %初始概率
trans = hmm.trans; %转移概率
mix = hmm.mix;  %高阶混合
N = hmm.N;  %HMM的状态数
T = size(sample(k).data,1); %语音帧数




end
    
    fprintf('总和输出概率(log)=%d\n',pout(loop));