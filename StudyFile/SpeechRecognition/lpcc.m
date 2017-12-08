function ccc=lpcc(x)

x = double(x);
x = filter([1 -0.9375],1,x);
%x=filter([1-0.9375],1,x);

len=160;                    %按照惯例，每一帧信号取20ms，采样8k的话，每帧160个采样点
y=enframe(x,len,len/2); % 分帧处理，一般情况下帧移选择在0.5个帧宽

for i = 1:size(y,1)
    yy = y(i,:);
    s = yy' .*hamming(len);   %提取一帧
    p=10;           %p为阶数,lpc计算阶数，8k的采样率选择10较为合适
    A=real(LPC3(s,p));      
    lpc1=A;
    a=lpc2lpcc(lpc1);
    lpcc(i,:)=a;
end
% ccc=lpcc;
m = lpcc(3:size(lpcc,1)-2,:);
ccc=m;
% 差分参数
% dtm = zeros(size(m));
% for i=3:size(m,1)-2
%     dtm(i,:) = -2*m(i-2,:)-m(i-1,:)+m(i+1,:)+2*m(i+2,:);
% end
% dtm = dtm/3;
% 
% 合并mfcc参数和一阶差分mfcc参数
% ccc = [m dtm];
% 去除首尾两帧，因为这两帧的一阶差分参数为0
% ccc = ccc(3:size(m,1)-2,:);