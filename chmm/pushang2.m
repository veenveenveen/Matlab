clear all;
clc;
close all
%基于自适应子带频谱熵的稳健性语音端点检测
N=256;%FFT变换的点数
Winsiz=256;%帧长
Shift=128;%帧移
%[fname,pname]=uigetfile('*.wav','Open Wave File');
%file=[pname,fname];
%[x1,fs,bits]=wavread(file);


[x1,Fs]=wavread('G:\毕业论文相关\record\dang4-1.wav');
%len=length(x);
%noise=0.001*rand(len,1);
x1=x1(:,1);
leng=length(x1);
[xn,FS1,]=wavread('G:\毕业论文相关\record\dang4-1_baizaoyin.wav',leng);
xn=2.5*xn;
x=x1+xn;

%wavwrite(x,FS,NBITS,'语音信号处理加噪1.wav');
% SNR=snr(x1,xn)

%x=x+noise;

%x=x./max(x);
%xy=x;
% 对信号做预加重处理
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
%Esum=zeros(1,nseg);

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

%%%%%%%%%%%%%%%%检测门限
thr=[max(H)-min(H)]/45+1.6*min(H);



%%%%%%%%%%%%%%%%%%
for  i=1:length(H);
    if   H(i) > thr;
           p(i)=1;
    else
        p(i)=0;
    end
end

figure(1) ,plot(p)
%%%%%%%%%%%%%%%%%%%%%%%
j=1;jj=1;
for i=1:length(H)-1;
    if p(i)<p(i+1) 
        k(j)=i;
        j=j+1;
    else if p(i)>p(i+1);
        kk(jj)=i;
        jj=jj+1;
        end
    end
end      


FrameInc=Shift;

klength=length(k);%红线
kklength=length(kk);%绿线

figure(2)
subplot(3,1,1)
plot(x1)

%title('纯净语音信号的端点检测');
xmax=max(x1);
xmin=min(x1);
axis([1 length(x1) xmin xmax])
xlabel('采样点数')
ylabel('幅度');

for i=1:klength
    line([ k(i)*FrameInc  k(i)*FrameInc],[xmin,xmax],'color','red');
end
for i=1:kklength
    line([kk(i)*FrameInc  kk(i)*FrameInc],[xmin,xmax],'color','green');
end

subplot(3,1,2)
plot(x)
%title('加噪语音信号的端点检测');
xmax=max(x);
xmin=min(x);
axis([1 length(x) xmin xmax])
xlabel('采样点数')
ylabel('幅度');
klength=length(k);
kklength=length(kk);
for i=1:klength
    line([k(i)*FrameInc   k(i)*FrameInc],[xmin,xmax],'color','red');
end
for i=1:kklength
    line([kk(i)*FrameInc  kk(i)*FrameInc],[xmin,xmax],'color','green');
end

subplot(3,1,3)
plot(H)
axis([1 length(H) min(H) max(H)]);
line([1 length(H)],[thr,thr],'color','red');
xlabel('帧数')
ylabel('谱熵 ')
