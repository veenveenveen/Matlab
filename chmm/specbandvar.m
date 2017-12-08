clear all;
clc;
%基于频谱方差的语音端点检测
N=256;%
Winsiz=256;%帧长
Shift=80;%帧移
[x,Fs]=wavread('G:\毕业论文相关\record\dang4-1.wav');
x=double(x);
%对信号做预加重处理
x=filter([1 -0.9375], 1, x);
x=5*(x-mean(x));

nseg=floor((length(x)-Winsiz)/Shift)+1;
A=zeros(Winsiz/2,nseg);

%下面循环是x信号的加窗处理并求出各点频谱能量
for i=1:nseg
    n1=(i-1)*Shift+1;n2=n1+(Winsiz-1);
    xx=x(n1:n2);xx=xx.*hamming(Winsiz);
    y=fft(xx,N);
    y=y(1:Winsiz/2);
    A(:,i)=abs(y);
end
%设阀值
d=0;
d=var(A(:,1))+eps;
M=3*d;
%利用频带进行端点检测
D=zeros(nseg,1);D1=zeros(nseg,1);
for i=1:nseg
    D(i)=var(A(:,i))+eps;
    if D(i)<=M
        D1(i)=d/5;
        else
       D1(i)=2*D(i); 
       
    end
end
% subplot(211),plot(x);
% 
% subplot(212),plot(D1);
figure(2);
subplot(2,1,1)
plot(x)
axis([1 length(x) -1 1])

 
subplot(2,1,2)
plot(D1);
axis([1 length(D1) 0 max(D1)])

    