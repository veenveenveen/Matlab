clear
clc
[x]=audioread('0.wav');
bank=melbankm(24,256,8000,0,0.5,'m');
bank=full(bank);
bank=bank/max(bank(:));
for k=1:12
    n=0:23;
dctcoef(k,:)=cos((2*n+1)*k*pi/(2*24));
end
w=1+6*sin(pi*[1:12]./12);
w=w/max(w);
%?预加重滤波器?
xx=double(x);
xx=filter([1 -0.9375],1,xx);
%?语音信号分帧?
xx=enframe(xx,256,80);
%?计算每帧的MFCC参数?
for i=1:size(xx,1) 
    y=xx(i,:);
s=y'.*hamming(256);
t=abs(fft(s));
t=t.^2;
c1=dctcoef*log(bank*t(1:129));
c2=c1.*w';
m(i,:)=c2';
end
figure
plot(m);
xlabel('帧数');
ylabel('幅度');
title('MFCC');
