function y=quzao(x)
%axis([1 1024 0 lOO1);
[c,l]=Wavedec(x,3,'db2');%采用db2小波并对信号进行三层分解
ca3=appcoef(c,l,'db2',3);%提取小波分解的低频系数
cd3=detcoef(c,l,3);%提取第三层的高频系数
cd2=detcoef(c,l,2);%提取第二层的高频系数
cdl=detcoef(c,l,1);%提取第一层的高频系数
%下面利用默认阂值进行消噪处理
%用ddencmp函数获得信号的默认阈值，使用wdencmp命令函数来实现消噪过程
[thr,sorh,keepapp]=den('den','wv',x);
thr=thr+0.3;
s2=wdencmp('gbl',c,l,'db2',3,thr,sorh,keepapp);
%axis([1 1024 0 lOO1),
y=s2;