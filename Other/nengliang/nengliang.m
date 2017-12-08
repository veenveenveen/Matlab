%对语音信号采样分帧
clear
clc
X= wavread('666.wav');
%对信号进行预加重
x=X;
x4=filter([1,-0.9375],1,x);
figure(1)
subplot(2,1,1),plot(x)
title('原始语音信号');
xlabel('样本序列n');
ylabel('幅值');
subplot(2,1,2),plot(x4)
title('原始语音信号的预加重');
xlabel('样本序列n');
ylabel('幅值');


   
% 幅度归一化到[－1，1]
x=double(x);
x=x/max(abs(x));
% 常数设置
FrameLen=240;       % 帧长取30ms,8kHz的采样率
FrameInc=80;        % 帧移取10ms,1/3
amp1=3;            
amp2=2;              
zcr1=10;            
zcr2=5;                
maxsilence=3;        % 3*10ms=30ms
minlen=15;          % 15*10ms=150ms   
status=0;
count=0;
silence=0; 


% 短时过零率(矢量法)
tmp1=enframe(x(1:length(x)-1),FrameLen,FrameInc);
tmp2=enframe(x(2:length(x)),FrameLen,FrameInc);
signs=(tmp1.*tmp2)< 0;
diffs=(tmp1-tmp2)> 0.02;
zcr=sum(signs.*diffs,2);
figure(2)
subplot(2,1,1)
plot(zcr);
title('短时过零率');
ylabel('zcr')

%计算短时能量
amp=sum(abs(enframe(filter([1-0.9375],1,x),FrameLen,FrameInc)),2);
inz=find(amp>1);
amm=amp(inz);
ll=min(amm);
figure(2)
subplot(2,1,2)
plot(amp);
title('短时能量');
ylabel('amp')


%调整能量门限 
amp1 = min(amp1, max(amp)/4);
amp2 = min(amp2, max(amp)/8);
%amp1=ll+(max(amp)-ll)/8;
%amp2=ll+(max(amp)-ll)/16;
%开始端点检测
x1=0;
x2=0;
for n=1:length(zcr)
    goto = 0;
    switch status 
        case{0,1}                    % 0=静音，1=可能开始
            if amp(n) > amp1         % 确信进入语音段
                x1=max(n-count-1,1);
                status=2;
                silence=0;
                count=count+1;
            elseif amp(n) >amp2 | zcr(n) > zcr2     % 可能处于语音段
                status=1;
                count=count+1;
            else                                    % 静音状态 
                status=0;
                count=0;
            end
        case 2,                                     % 2=语音段
            if amp(n) > amp2 | zcr(n) > zcr2        % 保持在语音段
                count=count+1;
            else
                silence=silence+1;
                if silence < maxsilence    % 静音还不够长，尚未结束
                   count=count+1;
                elseif count < minlen      % 语音长度太短，认为是噪声
                   status=0;
                   silence=0;
                   count=0;
                else                       % 语音结束
                   status=3;
                end
            end
        case 3,                       % 3=语音结束    
            break;
    end
end
count=count-silence;
x2=x1+count-1;                  
figure(3)
subplot(2,1,1)
plot(x)
title('语音信号的端点检测');
axis([1 length(x) -1 1])
ylabel('Speech');
line([x1*FrameInc x1*FrameInc],[-1,1],'color','red');
line([x2*FrameInc x2*FrameInc],[-1,1],'color','red');

%n1=(x1*FrameInc-x2*FrameInc)+1;
yy=x(x1*FrameInc:x2*FrameInc);%x1*FrameInc=3760,x2=8320,
 %yy的长度是4560
figure(3)
subplot(2,1,2)
plot(yy)
axis([1 length(yy) -1 1]) %将此处的横坐标改值就可以取不同的语音段现在是整个语音段，
title('原始语音信号进行端点检测后得到的有用的语音信号段')



fs=11.025;%设定采样频率
y=fft(yy);%进行fft变换
mag=abs(y);%求幅值
f=(0:length(y)-1)'*fs/length(y);%进行对应的频率转换
figure(4);
plot(f,mag);%做频谱图
xlabel('频率(Hz)');
ylabel('幅值');
title('信号波幅频谱图');
grid;

z=0.1*rand(1,length(yy));
figure(5);
plot(z)

fs=11.025;%设定采样频率
Z=fft(z);%进行fft变换
mag=abs(Z);%求幅值
f=(0:length(Z)-1)'*fs/length(Z);%进行对应的频率转换
figure(6);
plot(f,mag);%做频谱图
xlabel('频率(Hz)');
ylabel('幅值');
title('噪声波幅频谱图')
grid;

m=yy'+z;
figure(7);
subplot(2,1,1);
plot(m)


fs=11.025;%设定采样频率
M=fft(m);%进行fft变换
mag=abs(M);%求幅值
f=(0:length(M)-1)'*fs/length(M);%进行对应的频率转换
figure(8);
plot(f,mag);%做频谱图
xlabel('频率(Hz)');
ylabel('幅值');
title('混合信号波幅频谱图')
grid;


%wavwrite(m,'s01')

