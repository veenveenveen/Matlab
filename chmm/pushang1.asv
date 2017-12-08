clear all;
clc;
%基于自适应子带频谱熵的稳健性语音端点检测
N=512;%
Winsiz=512;%帧长
Shift=256;%帧移
[x,Fs]=wavread('G:\毕业论文相关\record\dang4-12.wav');
x=double(x);
%对信号做预加重处理
x=filter([1 -0.9375], 1, x);

nseg=floor((length(x)-Winsiz)/Shift)+1;
A=zeros(Winsiz/2+1,nseg);

%下面循环是x信号的加窗处理并求出各点频谱能量
for i=1:nseg
    n1=(i-1)*Shift+1;n2=n1+(Winsiz-1);
    xx=x(n1:n2);xx=xx.*hamming(Winsiz);
    y=fft(xx,N);
    y=y(1:Winsiz/2+1);
    y=y.*conj(y);
    A(:,i)=y;
end
%计算总能量
Esum=0;
for i=1:nseg
    for j=1:Winsiz/2
        Esum=Esum+A(j,i);
    end
end 
%下面是计算每一帧的谱的能量
for i=1:nseg
    for n=1:Winsiz/2
        E(n,i)=A(n,i);
    end
end   
%下面是计算每帧中每个样本点的概率分布
for i=1:nseg
    for n=1:Winsiz/2
      P(n,i)=E(n,i)/Esum;  
    end
end
%下面是计算每一帧的谱熵值
H=zeros(1,nseg);
for i=1:nseg
    for n=1:Winsiz/2
        H(i)=H(i)-P(n,i)*log(P(n,i)+eps);
    end
end  

figure(3);
%画出wav文件的波形和对应的信息熵
subplot(311)
plot(x);
subplot(312)
plot(H);
%为了消除单个点受噪声的影响，现在把4点放在一起，变成一子带，4*32=128 
Eb=zeros(64,nseg);Ebsum=0;
for i=1:nseg
    for m=1:64
        for k=(4*m-3):4*m
           Eb(m,i)=Eb(m,i)+E(k,i);
        end
        Ebsum=Ebsum+Eb(m,i);
    end
    
end   
%实现文中公式(8)
for i=1:nseg          
    for k=1:64
     Pb(k,i)=Eb(k,i)/Ebsum;
    end
end     
%实现文中公式(9)
Hb=zeros(1,nseg);
for i=1:nseg
    for k=1:64
        Hb(i)=Hb(i)-Pb(k,i)*log(P(k,i)+eps);
    end
end
%画出wav文件的波形和对应的信息熵
subplot(313)
plot(Hb);
    
