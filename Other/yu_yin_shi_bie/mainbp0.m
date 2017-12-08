clc
clear
 k = 11;
 data_matrix=[];
 data_matrix2=[];
 %载入训练数据，并提取特征
for i=0:9
    for j=10:50
s = sprintf('09517/%i%i.wav',i,j);%把格式化的数据写入某个字符串中
[s1 fs1] = wavread(s);
v = mfcc(s1, fs1);
a= vqlbg(v, k); 
data_matrix=[data_matrix,a(:)];
    end
end
 %载入测试数据，并提取特征
for i=0:9
    for j=51:99
s = sprintf('09517/%i%i.wav',i,j);
[s1 fs1] = wavread(s);
v = mfcc(s1, fs1);
a= vqlbg(v, k); 
data_matrix2=[data_matrix2,a(:)];
    end
end
%样本的标签
T_train=[1,1,1,1,1,2,2,2,2,2,3,3,3,3,3,4,4,4,4,4,5,5,5,5,5,6,6,6,6,6,7,7,7,7,7,8,8,8,8,8,9,9,9,9,9,10,10,10,10,10]';
T_test=T_train;


P_train=mapminmax(data_matrix,0,1)';%归一
[P_test,B]=mapminmax(data_matrix2,0,1);%归一
P_test=P_test';
Tn_train=BP(T_train);
P_train=P_train';
P_test=P_test';
net=newff(minmax(P_train),[70,10],{'tansig' 'tansig'} ,'traingda');%建立一个神经网络框架
net.trainParam.show=500;
%训练网络
net.trainParam.lr=1;
net.trainParam.epochs=5000;      %训练次数取10000
net.trainParam.goal=0.001;        %误差门限取0.01
net=train(net,P_train,Tn_train); %训练神经网络
YY=sim(net,P_train);
[maxi,ypred]=max(YY);
maxi=maxi';
ypred=ypred';
CC=ypred-T_train;
n=length(find(CC==0));
Accuracytrain=n/size(P_train,2)

YY=sim(net,P_test);
[maxi,ypred]=max(YY);
maxi=maxi';
ypred=ypred';
CC=ypred-T_test;
n=length(find(CC==0));
Accuracytest=n/size(P_test,2)

%%读取单个语音
s = sprintf('data/%i%i.wav',2,6); %改动路径 比如1 2就是 1的第2个， 2 3就是2的第3个，自己改选择一个语音
[s1 fs1] = wavread(s);%读取
v = mfcc(s1, fs1);%提取特征参数
a= vqlbg(v, k); %量化
a=a(:);
b=mapminmax('apply',a,B);%归一
YY=sim(net,b);
[maxi,ypred]=max(YY);
leibie=ypred-1  %显示类别标签
