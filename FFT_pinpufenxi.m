clc
clear
fs = 100; %采样频率
N= 128;
n = 0:N-1;
t = n/fs;
f0 = 10;%正弦信号频率

x = sin(2*pi*f0*t);
figure(1);
subplot(2,3,1);
plot(t,x);
xlabel('时间/s');
ylabel('幅值');
title('时域波形');
grid;

y = fft(x,N);%进行FFT变换
mag = abs(y);%求幅值
f = (0:length(y)-1)'*fs/length(y);%进行对应的频率变换
subplot(2,3,2);
plot(f,mag);
axis([0,100,0,80])
xlabel('频率/Hz');
ylabel('幅值');
title('幅频谱图');
grid;

sq = abs(y);%求均方根谱
subplot(2,3,3);
plot(f,sq);
xlabel('频率/Hz');
ylabel('均方根谱');
title('均方根谱图');
grid;

power = sq.^2;%求功率谱
subplot(2,3,4);
plot(f,power);
xlabel('频率/Hz');
ylabel('功率谱');
title('功率谱图');
grid;

ln = log(sq);%求对数谱
subplot(2,3,5);
plot(f,ln);
xlabel('频率/Hz');
ylabel('对数谱');
title('对数谱图');
grid;

xifft = ifft(y);%用IFFT恢复原始信号
magx = real(xifft);
ti = [0:length(xifft)-1]/fs;
subplot(2,3,6);
plot(ti,magx);
xlabel('时间/s');
ylabel('幅值');
title('IFFT后的信号波形');
grid;