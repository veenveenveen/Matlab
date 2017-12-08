[x,fs]=audioread('1.wav');%读入数据
y=resample(x,4,11);%重采样将频率变为8k
N=160;
y1=y(1:N);
w1=hanning(N);
y2=y1.*w1';%加窗 取一帧数据
p=10;%预测阶数
A=real(LPC(y2,p));%用lpc函数求预测系数
for i=1:10
X(i)=y2(i);
end
%用lpc函数所求系数合成语音信号
for i=11:160
sum=0;
for j=2:11
sum= sum+(-A(j).*X(i+1-j)');
end
X(i)=sum;
end
%下面是自编求线性预测系数的程序
%首先求自相关函数
r=zeros(1,p+1);
for k=1:p+1
sum=0;
for m=1:N+1-k
sum=sum+y2(m).*y2(m-1+k)';
end
r(k)=sum;
end
%根据durbin算法求线性预测系数
k=zeros(1,p);
k(1)=r(2)/r(1);
a=zeros(p,p);
a(1,1)=k(1);
e=zeros(1,p);
e(1)=(1-k(1)^2)*r(1);
%递推过程
for i=2:p
c=zeros(1,i);
sum=0;
for j=1:i-1
sum=sum+(a(i-1,j).*r(i+1-j));
end
c(i)=sum;
k(i)=(r(i+1)-c(i))/e(i-1);%求反射系数
a(i,i)=k(i);
for j=1:i-1
a(i,j)=a(i-1,j)-k(i).*a(i-1,i-j);
end
e(i)=(1-k(i)^2)*e(i-1);%求预测误差
end
%递推结束后提取预测系数
d=zeros(1,p);
for t=1:p
d(t)=a(p,t);
end

z=zeros(1,N);
for i=1:p
z(i)=y2(i);
end
%根据预测系数合成语音信号
for i=p+1:N
sum=0;
for j=1:10
sum=sum+(d(j).*z(i-j)');
end
z(i)=sum;
end
sum=0;
for i=1:p
sum=sum+d(i).*r(i+1)';
end 
G=(r(1)-sum).^.5;
E=zeros(1,N);
E=-z+y2;
x1=filter(G,d,E);
figure(1);
subplot(411);plot(y2);title('原始数据')
subplot(412);plot(X);title('用lpc函数所求合成数据')
subplot(413);plot(z);title('用自编程序所求合成数据')
subplot(414);plot(x1) 
