x = wavread('G:\毕业论文相关\record\chang1-5.wav');
[x1 x2] = vad(x);
m = lpcc(x);
for i=1:size(m,2)
    sum(i)=0;
    for j=1:size(m,1)
        sum(i)=sum(i)+m(j,i);
    end
end
sum=abs(sum)/24;
sum=sum*10;
m=m*10;
figure(1)
subplot(3,1,1)
plot(m(:,1))
axis([0 length(m) -10 20])
xlabel('数字5的第一维LPCC系数');
subplot(3,1,2)
plot(m(:,2))
axis([0 length(m) -10 20])
xlabel('数字5的第二维LPCC系数');
subplot(3,1,3)
plot(m)
axis([0 length(m) -30 30])
xlabel('数字5的完整的24维LPCC系数');
figure(2)
bar(sum)
axis([1 12 0 25])