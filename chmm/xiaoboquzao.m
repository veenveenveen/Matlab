clear
%在噪声环境下语音信号的增强
%语音信号为读入的声音文件
%噪声为正态随机噪声
% sound=wavread('c12345.wav');
% count1=length(sound);
% noise=0.05*randn(1,count1);
% for i=1:count1
% signal(i)=sound(i);
% end
% for i=1:count1
% y(i)=signal(i)+noise(i);
% end

x=wavread('dang1-3.wav');
%在小波基'db3'下进行一维离散小波变换
[coefs1,coefs2]=dwt(x,'db3'); %[低频 高频]

count2=length(coefs1);
count3=length(coefs2);

energy1=sum((abs(coefs1)).^2);
energy2=sum((abs(coefs2)).^2);
energy3=energy1+energy2;

for i=1:count2
recoefs1(i)=coefs1(i)/energy3;
end
for i=1:count3
recoefs2(i)=coefs2(i)/energy3;
end

%低频系数进行语音信号清浊音的判别
zhen=160;
count4=fix(count2/zhen);
for i=1:count4
n=160*(i-1)+1:160+160*(i-1);
s=x(n);
w=hamming(160);
sw=s.*w;
a=aryule(sw,10); %AP参数估计
sw=filter(a,1,sw);
sw=sw/sum(sw);
r=xcorr(sw,'biased');
corr=max(r);
%为清音（unvoice）时，输出为1；为浊音（voice）时，输出为0
if corr>=0.8
output1(i)=0;
elseif corr<=0.1
output1(i)=1;
end
end
for i=1:count4
n=160*(i-1)+1:160+160*(i-1);
if output1(i)==1
switch abs(recoefs1(i))
case abs(recoefs1(i))<=0.002
recoefs1(i)=0;
case abs(recoefs1(i))>0.002 & abs(recoefs1(i))<=0.003
recoefs1(i)=sgn(recoefs1(i))*(0.003*abs(recoefs1(i))-0.000003)/0.002;
otherwise recoefs1(i)=recoefs1(i);
end
elseif output1(i)==0
recoefs1(i)=recoefs1(i);
end
end

%对高频系数进行语音信号清浊音的判别
count5=fix(count3/zhen);
for i=1:count5
n=160*(i-1)+1:160+160*(i-1);
s=x(n);
w=hamming(160);
sw=s.*w;
a=aryule(sw,10);
sw=filter(a,1,sw);
sw=sw/sum(sw);
r=xcorr(sw,'biased');
corr=max(r);
%为清音（unvoice）时，输出为1；为浊音（voice）时，输出为0
if corr>=0.8
output2(i)=0;
elseif corr<=0.1
output2(i)=1;
end
end
for i=1:count5
n=160*(i-1)+1:160+160*(i-1);
if output2(i)==1
switch abs(recoefs2(i))
case abs(recoefs2(i))<=0.002
recoefs2(i)=0;
case abs(recoefs2(i))>0.002 & abs(recoefs2(i))<=0.003
recoefs2(i)=sgn(recoefs2(i))*(0.003*abs(recoefs2(i))-0.000003)/0.002;
otherwise recoefs2(i)=recoefs2(i);
end
elseif output2(i)==0
recoefs2(i)=recoefs2(i);
end
end

%在小波基'db3'下进行一维离散小波反变换 
output3=idwt(recoefs1, recoefs2,'db3');

%对输出信号抽样点值进行归一化处理
maxdata=max(output3);
output4=output3/maxdata;

subplot(2,1,1)
plot(x)
axis([1 length(x) -1 1])
title('带噪语音信号');

subplot(2,1,2)
plot(output4)
axis([1 length(output4) -1 1])
title('处理后语音信号');
wavwrite(output4,8000,'E:\voice\matlabcode\myhmm\WtDeSpeech.wav');

%读出带噪语音信号，存为'101.wav'
%wavwrite(y,5500,16,'c101'); 

%读出处理后语音信号，存为'102.wav'
%wavwrite(output4,5500,16,'c102');