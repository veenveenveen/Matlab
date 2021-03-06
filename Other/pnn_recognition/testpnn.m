
%程序是正确的,但泛化能力差，主程序
clc;
clear;

t1=cputime;
num=10;

disp('正在计算数字识别PNN模型...');

for i=1:num
	fname = sprintf('%d.wav',i-1);
	x = wavread(fname);
	%[x1 x2] = vad(x);   %端点检测
	m = mfcc(x);
	%m = m(x1-2:x2-2,:);
    l=length(m(:,1));
	ref(i).mfcc = m';
    ref(i).tc=i*ones(1,l);
end

p=ref(1).mfcc;
tc=ref(1).tc;
for i=1:num-1
    p=[p,ref(i+1).mfcc];
    tc=[tc,ref(i+1).tc];
end
t=ind2vec(tc);

spread=5;
net=newpnn(p,t,spread);


disp('正在计算测试数字识别的结果...');
s=0;
for i=1:num
	fname = sprintf('%d.wav',i-1);
	x = wavread(fname);
	%[x1 x2] = vad(x);
	m = mfcc(x);
	%m = m(x1-2:x2-2,:);
	y=sim(net, m');
    test(i).yc=vec2ind(y);
     test(i).num=0;
     for j=1:length(test(i).yc)
          if  test(i).yc(j)==i
               test(i).num= test(i).num+1;
         end
     end
     fname = sprintf('recognition correct rate for each digit %d',i-1);
     disp(fname);
    t=test(i).num/length(test(i).yc) ; %recognition correct rate for each digit
     s=s+t;
     disp(test(i).yc);
     disp(t);
    figure 
    hist(test(i).yc);
end
disp('average correct rate:s=');
s=s/10    %average correct rate

t2=cputime-t1

%%%%%%%模板匹配程序,dtw
% close all;
% disp('正在进行模板匹配...')
% dist = zeros(10,10);
% for i=1:10
% for j=1:10
% 	dist(i,j) = dtw(test(i).mfcc, ref(j).mfcc);
% end
% end
% 
% disp('正在计算匹配结果...')
% for i=1:10
% 	[d,j] = min(dist(i,:));
% 	fprintf('测试模板 %d 的识别结果为：%d\n', i, j);
% end
