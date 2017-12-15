function ccc = mfcc(x,fftN,freq)
% 功能：归一化mel滤波器组系数
% x：输入数据
% fftN：fft的点数
% freq: 输入音频的采样频率
%bank=melbankm(24,256,8000,0,0.5,'m');
bank=melbankm(24,fftN,freq,0,0.5,'m');
bank=full(bank);
bank=bank/max(bank(:));

% DCT系数,12*24
for k=1:12
  n=0:23;
  dctcoef(k,:)=cos((2*n+1)*k*pi/(2*24));
end

% 归一化倒谱提升窗口
w = 1 + 6 * sin(pi * [1:12] ./ 12);
w = w/max(w);

% 预加重滤波器
xx=double(x);
xx=filter([1 -0.9375],1,xx);

% 语音信号分帧
%xx=enframe(xx,256,80);
xx=enframe(xx,fftN,fix(0.3*fftN));
%xx=enframe(xx,600,200);

% 计算每帧的MFCC参数
for i=1:size(xx,1)
  y = xx(i,:);
  s = y' .* hamming(fftN);
%  s = y' .* hamming(256);
  t = abs(fft(s));
  t = t.^2;
  c1=dctcoef * log(bank * t(1:fix(fftN/2)+1));
%  c1=dctcoef * log(bank * t(1:129));
%  c1=dctcoef * log(bank * t(1:301));
  c2 = c1.*w';
  m(i,:)=c2';
end

%差分系数
dtm = zeros(size(m));
for i=3:size(m,1)-2
  dtm(i,:) = -2*m(i-2,:) - m(i-1,:) + m(i+1,:) + 2*m(i+2,:);
end
dtm = dtm / 3;

ccc = [m];
%去除首尾两帧，因为这两帧的一阶差分参数为0
ccc = ccc(3:size(m,1)-2,:);
