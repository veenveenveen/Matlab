%Daubechies8小波
%%%%%%产生数据%%%%%%%%%%%%%%%
s=wavread('jin1-4.wav');
subplot(2,1,2)
plot(s)
axis([1 length(s) -1 1])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=length(s);
y = 2/n*abs(fft(s,n)); %进行傅立叶变换
%Pyy =y.*conj(y)/n;  %The power spectrum
%ff1= f*(0:410)/n;   
[c,l]=wavedec(s,5,'db8'); 
%取第5层低频近似系数
ca5=appcoef(c,l,'db8',5);
%取各层高频细节系数
cd5=detcoef(c,l,5);
cd4=detcoef(c,l,4);cd3=detcoef(c,l,3);
cd2=detcoef(c,l,2);cd1=detcoef(c,l,1);
%将其它频段的系数置零
ca=zeros(1,length(ca5));   
c5=zeros(1,length(cd5));
c4=zeros(1,length(cd4));  
c3=zeros(1,length(cd3));
c2=zeros(1,length(cd2));
c1=zeros(1,length(cd1)); 
%重构系数，按要求重构第5层细节部分，其它系数则置零，得到第5层细节对应的值        
cc1=[ca,cd5,c4,c3,c2,c1];
%cc1=[ca6,c6,c5,c4,c3,c2,c1];
S2= waverec(cc1,l,'db8'); 
%进行傅立叶变换
Y2 = 2/n*abs(fft(S2,n)); 
%ff2= f*(0:410)/n;   
%输出结果
subplot(2,1,2)
plot(S2)
axis([1 length(S2) -1 1])
plot(S2);
title('Daubechies8 result');xlabel('the point number');ylabel('Amplitude/cm');
