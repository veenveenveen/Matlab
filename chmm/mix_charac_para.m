function cc=mix_charac_para(x)
m=mfcc(x);
n=lpcc(x,12);
y=0
for i=1:12
    y=y+n(i)*x
end
cc=[m n];