[x]=wavread('G:\毕业论文相关\record\dang4-12.wav');
%归一化倒谱提升窗口
w = 1+6*sin(pi*[1:12]./12);
w = w/max(w);

%预加重滤波器
y = double(x);
y = y / max(abs(x));
yy = filter([1 -0.9375],1,y);

%语言信号分帧
N=160;
zz = enframe(yy,N,80);

subplot(311)
plot(x)
axis([1 length(x) -1 1])
ylabel('Speech');
title('原始语音信号')

subplot(312)
plot(yy);
axis([1 length(yy) -1 1])
ylabel('Speech');
title('滤波后的语音信号')

subplot(313)
plot(zz);
axis([1 length(zz) -1 1])
ylabel('Speech');
title('加窗分帧后的语音信号')