%BP神经网络的识别实现
%bp_test = bp_test(  x ,net)，x为输入的数据,net为BP网络

function bp_test = bp_test(x ,net)
p=x';
[nb,minx,maxx]=premnmx(p);%归一化

nc= sim(net,nb);    %用训练好的模型进行仿真
c=postmnmx(nc,minx,maxx);%反归一化
x=round(c);             %输出网络识别结果
bp_test=c;
end