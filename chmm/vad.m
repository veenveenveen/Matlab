function [x1,x2] = vad(x)

%幅度归一化到[-1,1]
x = double(x);
x = x/max(abs(x));

%常数设置
Len = 240;
Inc = 80;

amp1 = 10;
amp2 = 2;
zcr1 = 10;
zcr2 = 5;

maxsilence = 3; % 3*10ms = 30ms
minlen = 15;    %15*10ms = 150ms
status = 0;  %表示当前所处的状态，0为静音，1为过渡段，2为语音段，3为结束
count = 0;   
silence = 0;

%计算过零率
tmp1 = enframe(x(1:length(x)-1),Len,Inc);
tmp2 = enframe(x(2:length(x)),Len,Inc);
signs = (tmp1.*tmp2)<0;
diffs = (tmp1-tmp2)>0.02;
zcr = sum(signs.*diffs,2);

%计算短时能量
amp = sum(abs(enframe(filter([1 -0.9375],1,x),Len,Inc)),2);   %每一帧的短时能量

%调整能量门限
amp1 = min(amp1,max(amp)/4);
amp2 = min(amp2,max(amp)/8);

%开始端点检测
x1 = 0;
x2 = 0;
for n = 1:length(zcr)
    goto = 0;
    switch status
        case {0,1}   % 0：静音，1：可能开始
            if amp(n)>amp1   %确信进入语音段
                x1 = max(n-count-1,1);  %起点，用确信进入的语音段的点减去可能处于语音段的时候的点，得到开始进入语音段的点
                status = 2;
                silence = 0;
                count = count+1;
            elseif amp(n)>amp2|zcr(n)>zcr2  %可能处于语音段
                    status = 1;
                    count = count+1;
                else  %没有进入语音段
                    status = 0;
                    count = 0;
                end
        case 2,   % 2：语音段
            if amp(n)>amp2|zcr(n)>zcr2   %保持在语音段
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
                   
%count = count-silence/2;
x2 = x1+count-1;

% subplot(3,1,1)
% plot(x)
% axis([1 length(x) -1 1])
% ylabel('speech');
% line([x1*Inc x1*Inc],[-1,1],'Color','red');
% line([x2*Inc x2*Inc],[-1,1],'Color','blue');
% 
% subplot(3,1,2)
% plot(amp)
% axis([1 length(amp) 0 max(amp)])
% ylabel('Amp');
% line([x1 x1],[min(amp),max(amp)],'Color','red');
% line([x2 x2],[min(amp),max(amp)],'Color','blue');
% 
% subplot(3,1,3)
% plot(zcr)
% axis([1 length(zcr) 0 max(zcr)])
% ylabel('ZCR');
% line([x1 x1],[min(zcr),max(zcr)],'Color','red');
% line([x2 x2],[min(zcr),max(zcr)],'Color','blue');

