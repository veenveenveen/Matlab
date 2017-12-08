clc
clear

close all
N = 32;
nn = 0:N-1;

figure(1); 

subplot(3,1,1);
w = boxcar(N);
stem(nn,w);
xlabel('点数');
ylabel('幅度');
title('矩形窗');

subplot(3,1,2);

w = hamming(N);
stem(nn,w);
xlabel('点数');
ylabel('幅度');
title('汉明窗');

subplot(3,1,3);
w = hanning(N);
stem(nn,w);
xlabel('点数');
ylabel('幅度');
title('海宁窗');