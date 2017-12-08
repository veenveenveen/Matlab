clear
clc

fs = 8000;%采样率

y = audiorecorder(fs,16,1);
record(y);
pause%按任意键继续
stop(y);%停止
%play(y);%播放

speech = getaudiodata(y);
speechMax = max(abs(speech));%归一化
speech = speech/speechMax;

%save('speech'); 
%pause
audiowrite('original_myspeech.wav',speech,fs);%保存
audiowrite('half_myspeech.wav',speech,fs/2);%保存 采样频率的1/2
audiowrite('double_myspeech.wav',speech,fs*2);%保存 采样频率的2倍

[speech0,fs0] = audioread('original_myspeech.wav');
t0 = (1:length(speech0))/fs0;

[speech1,fs1] = audioread('half_myspeech.wav');
t1 = (1:length(speech1))/fs1;

[speech2,fs2] = audioread('double_myspeech.wav');
t2 = (1:length(speech2))/fs2;

figure(1);
subplot(3,1,1);
axis([0,3,-1,1]);
plot(t0,speech0);
xlabel('时间/s');
ylabel('幅度');
title('初始采样率');

subplot(3,1,2);
axis([0,3,-1,1]);
plot(t1,speech1);
xlabel('时间/s');
ylabel('幅度');
title('1/2采样率');

subplot(3,1,3);
axis([0,3,-1,1]);
plot(t2,speech2);
xlabel('时间/s');
ylabel('幅度');
title('2倍采样率');

y0 = audioplayer(speech0,fs0);
play(y0);
pause;

y1 = audioplayer(speech1,fs1);
play(y1);
pause;

y2 = audioplayer(speech2,fs2);
play(y2);