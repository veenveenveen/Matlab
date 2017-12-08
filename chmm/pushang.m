clear all
clc

 [x,fs,bits]=wavread('G:\毕业论文相关\record\dang4-1.wav'); %纯净语音

  x=awgn(40*x,10);    %各种不同dB的加性高斯语音生成
% [x,fs,bits]=wavread('录音工具');
%sound(x);
% y1=wgn(length(x),1,10);
% y1=0.01*y1;
% x=y1+x;
%sound(x);
% x=awgn(x,10);
%  x=awgn(x,-5);
x= double(x);
x= x/ max(abs(x));
pi=3.1416;
inc=80;len=256;nwin=256;Q=0.9;Fs=8000;
%y = medfilt3(x,10); 
N=length(x);
d=enframe(x,len,inc);
frame_num=fix((N-len+inc)/inc);
g=zeros(frame_num,len);
G=zeros(frame_num,nwin);
sum=zeros(1,frame_num);
H=zeros(1,frame_num);
E_voice_on=zeros(1,frame_num);
for i=1:frame_num;
    y=hamming(len);
    g(i,:)=d(i,:).*y';
    G(i,1:len)=g(i,:);
    fourier_g(i,:)=fft(G(i,:));
end
for i=1:frame_num;
    for m=1:nwin;
        sum(i)=sum(i)+abs(fourier_g(i,m)+Q);
    end
    for m=1:nwin;
        if m*(Fs/2)/nwin<250||m*(Fs/2)/nwin>3500;
            p(i,m)=0;
        else
            p(i,m)=abs(fourier_g(i,m)+Q)/sum(i);
        end
    end
end
for i=1:frame_num
    for m=1:nwin;
        if p(i,m)~=0;
            H(i)=H(i)-p(i,m)*log2(p(i,m));
        end
    end
end


figure(1);
subplot(211);
% plot(d,'b');
plot(x);
xlabel('Samples/个');
ylabel('Speech');
title('Signal Wave');
axis([1 length(x) -1 1]);

subplot(212)
plot(-H+6.5);
xlabel('Frame/个');
ylabel('SE');
title('Spectral Entropy Wave');
axis([0 186 -1 3]);
% axis([0 200 -1 1]);
