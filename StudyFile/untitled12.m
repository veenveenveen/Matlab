[x fs]=audioread('0.wav');
bank=melbankm(24,256,fs,0,0.4,'m');%Mel滤波器的阶数为24，fft变换的长度为256，采样频率为8000Hz?
%归一化mel滤波器组系数?
bank=full(bank);
bank=bank/max(bank(:)); 
for k=1:12%归一化mel滤波器组系数?
    n=0:23;
    dctcoef(k,:)=cos((2*n+1)*k*pi/(2*24));
end
w=1+6*sin(pi*[1:12]./12);%归一化倒谱提升窗口?
w=w/max(w);%预加重滤波器?
xx=double(x);
xx=filter([1-0.9375],1,xx);%语音信号分帧?
xx=enframe(xx,256,80);%对x?256点分为一帧?%计算每帧的MFCC参数?
for i=1:size(xx,1)
    y=xx(i,:);
    s=y'.*hamming(256);
    t=abs(fft(s));%fft快速傅立叶变换?
    t=t.^2;
    c1=dctcoef*log(bank*t(1:129));
    c2=c1.*w';
    m(i,:)=c2';
end
%求取差分系数?
dtm=zeros(size(m));
for i=3:size(m,1)-2
    dtm(i,:)=-2*m(i-2,:)-m(i-1,:)+m(i+1,:)+2*m(i+2,:);
end

dtm=dtm/3;
%合并mfcc参数和一阶差分mfcc参数?
ccc=[m dtm];
%去除首尾两帧，因为这两帧的一阶差分参数为0?
ccc=ccc(3:size(m,1)-2,:);
subplot(2,1,1)
ccc_1=ccc(:,1);
plot(ccc_1);
title('MFCC');
ylabel('幅值');
[h,w]=size(ccc);
A=size(ccc);
subplot(212)
plot([1,w],A);
xlabel('维数');
ylabel('幅值');
title('维数与幅值的关系');