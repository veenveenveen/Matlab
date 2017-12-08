close all
clear
clc
% [x]=wavread('无标题.wav');
% [x]=wavread('G:\毕业论文相关\record\dang4-1.wav');
[x]=wavread('G:\voice\WN_clean.wav');
%幅度归一化到[-1,1]
x = double(x);
x = x / max(abs(x));

%常数设置
FrameLen = 256;
FrameInc = 80;

amp1 = 10;
amp2 = 2;


maxsilence =3; % 10*10ms = 30ms
minlen = 15; % 15*10ms = 150ms
status = 0;
count = 0;
silence = 0;


%计算短时能量
amp = sum(abs(enframe(filter([1 -0.9375], 1, x), FrameLen, FrameInc)), 2);

%调整能量门限
amp1 = min(amp1, max(amp)/4);
amp2 = min(amp2, max(amp)/8);

%开始端点检测
x1 = 0;
x2 = 0;
for n = 1:length(amp)
    goto = 0;
    switch status
        case {0,1}   % 0：静音，1：可能开始
            if amp(n)>amp1   %确信进入语音段
                x1 = max(n-count-1,1)  %起点，用确信进入的语音段的点减去可能处于语音段的时候的点，得到开始进入语音段的点
                status = 2;
                silence = 0;
                count = count+1;
            elseif amp(n)>amp2 %可能处于语音段
                    status = 1;
                    count = count+1;
                else  %没有进入语音段
                    status = 0;
                    count = 0;
                end
        case 2,   % 2：语音段
            if amp(n)>amp2   %保持在语音段
                    count = count+1;
                else
                    silence = silence+1;
                    if silence<maxsilence  %静音还不够长，尚未结束
                        count = count+1;
                    elseif count<minlen
                            status = 0;
                            silence = 0;
                            count = 0;
                        else
                            status = 3;
                        end
                    end
         case 3,  %语音结束
                 break;
         end
     end
                   
count = count-silence/2
x2 = x1+count-1


subplot(211)
plot(x)
axis([1 length(x) -1 1])
ylabel('Speech');
title('语音信号')
line([x1*FrameInc x1*FrameInc], [-1 1], 'Color', 'red');
line([x2*FrameInc x2*FrameInc], [-1 1], 'Color', 'red');

subplot(212)
plot(amp);
axis([1 length(amp) 0 max(amp)])
ylabel('Energy');
title('短时能量')
line([x1 x1], [min(amp),max(amp)], 'Color', 'red');
line([x2 x2], [min(amp),max(amp)], 'Color', 'red');
