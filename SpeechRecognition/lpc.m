%求LPC线性预测系数
%lpc1=lpc(y2,p); y2为输入数据，p是阶数

function lpc1=lpc(y2,p)
r=zeros(1,p+1);
for k=1:p+1
sum=0;
for m=1:160+1-k
sum=sum+y2(m).*y2(m-1+k);
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

lpc1=d;
