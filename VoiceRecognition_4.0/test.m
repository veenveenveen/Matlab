clc
clear
load neting
k = 11;
str1 = [];

x=audioread('voice_data4/2233.wav');

[x1,x2] = vad_lianxu(x);
m = mfcc_lianxu(x);

num = numel(x2);
for i=1:num
    testt(i).mfcc = m(x1(i)-2:x2(i)-2,:);
end

for i=1:num
    
    a = vqlbg(testt(i).mfcc, k); %量化
    a = a(:);
    b=mapminmax(a,0,1);%归一
    
    YY=sim(net,b);

    [maxi,ypred]=max(YY);
    leibie=ypred  %显示类别标签
 
    strss = {'我','要','一箱','多糖','少糖','正常','核桃','花生','牛奶'};
    str1 = [str1,strss{leibie}];

end

res = str1
msgbox(str1)
