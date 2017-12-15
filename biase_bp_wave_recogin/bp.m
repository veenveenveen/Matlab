%BP神经网络的实现
%bp_data = bp( x)，x为输入的数据

function bp_data = bp( x )
p=x';
[nb,minx,maxx]=premnmx(p);
a=[1,2,3,4,5,6,7,8,9,10];
t=a';
net=newff(minmax(nb),[280,17,10],{'purelin','logsig','purelin'},'traingdx'); 
net.trainParam.show=50; %50轮回显示一次结果
net.trainParam.lr=0.05; %学习速度为0.05
net.trainParam.epoch=1500; %最大训练轮回为1000次
net.trainParam.goal=0.001; %均方误差为0.001
net=train(net,nb,t);    %开始训练
y1= sim(net,nb);    %用训练好的模型进行仿真
plot(y1);
bp_data=net;
end


