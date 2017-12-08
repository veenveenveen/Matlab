%================================求解倒谱程序，以每一帧为单位
function lpcc=lpc2lpcc(lpc1)       %lpc1为线性预测参数
n_lpc=10;
n_lpcc=12;
lpcc=zeros(1,n_lpcc);                %12个元素的数组，用来存放特征
lpcc(1)=lpc1(1);                     %第一个值相同

for n=2:n_lpc                       %求8前面的阶数
    lpcc(n)=lpc1(n);
        for l=1:n-1 
        lpcc(n)=lpcc(n)+lpc1(l)*lpcc(n-l)*(n-l)/n;
         end
end

for n=n_lpc+1:n_lpcc                     %求8后面的阶数
    lpcc(n)=0;
    for l=1:n_lpc
     lpcc(n)=lpcc(n)+lpc1(l)*lpcc(n-l)*(n-l)/n;
    end
end

% lpcc=-lpcc;