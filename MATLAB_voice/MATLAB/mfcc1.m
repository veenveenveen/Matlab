function r = mfcc(s, fs)

% MFCC
%
% Inputs: s contains the signal to analize
% fs is the sampling rate of the signal
%
% Output: r contains the transformed signal
%
%
%%%%%%%%%%%%%%%%%%
% Mini-Project: An automatic speaker recognition system
%
% Responsible: Vladan Velisavljevic
% Authors: Christian Cornaz
% Urs Hunkeler
[s,fs]=wavread('1.wav');
fs = 12500;
m = 100;
n = 256;
l = length(s);
nbFrame = floor((l - n) / m) + 1;

s=double(s);
s=filter([1 -0.9375],1,s);

for i = 1:n
    for j = 1:nbFrame
        M(i, j) = s(((j - 1) * m) + i);
    end
end
h = hamming(n);
M2 = diag(h) * M;
for i = 1:nbFrame
    frame(:,i) = fft(M2(:, i));
end

t = n / 2;
tmax = l / fs;

n2 = 1 + floor(n / 2);
z = m * abs(frame(1:n2, :)).^2;
r = dct(log(z));
plot(r);

% 归一化倒谱提升窗口
% w = 1+6*sin(pi*[1:12]./12);
% w=w/max(w);
% r=r.*w';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%2005-12-25 modified by Robin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 获得差分mfcc

% dtm=zeros(size(r));
% for i=3:size(r,1)-2
%     dtm(i,:)=-2*r(i-2,:)-r(i-1,:)+r(i+1,:)+2*r(i+2,:);
% end
% dtm=dtm/3;
% % combine mfcc and △mfcc
% % 连接mfcc和差分mfcc
% ccc = [r dtm];
% 
% % 去除首尾两帧，因为这两帧的一阶差分参数为0
% r=ccc(3:size(r,1)-2,:);