clc
clear

k = 11;
data_matrix=[];%保存训练数据
data_matrix2=[];%保存测试数据

%0~9每个语音录10遍，训练数据为00，01，02，... ，09
%测试数据为000，001，002，... ，009
%每个数字再分别录制一遍 0，1，2，... ，9

%载入训练数据，并提取特征
T_train=[];
T_test=[];
for i=0:9
    for j=0:9
        s = sprintf('voice_data/train/%i%i.wav',i,j);%把格式化的数据写入某个字符串中
        [s1 fs1] = audioread(s);%读取
        v = mfcc(s1, fs1);%提取特征参数
        a= vqlbg(v, k); %量化
        data_matrix=[data_matrix,a(:)];
        T_train=[T_train,i+1];
    end
end

 %载入测试数据，并提取特征
for i=0:9
    for j=0:9
        s = sprintf('voice_data/test/%i0%i.wav',i,j);
        [s1 fs1] = audioread(s);
        v = mfcc(s1, fs1);
        a= vqlbg(v, k); 
        data_matrix2=[data_matrix2,a(:)];
        T_test=[T_test,i+1];
    end
end

%样本的标签
% P_train=mapminmax(data_matrix,0,1)';%归一
[P_train,settings] = mapminmax(data_matrix,0,1);
[P_test]=mapminmax(data_matrix2,'aply',settings);%归一
Tn_train=BP(T_train');
Tn_test=BP(T_test');
P_train=P_train;
P_test=P_test;
net=newff(minmax(P_train),[200,10],{'tansig' 'tansig'} ,'traingda');%建立一个神经网络框架
net.trainParam.show=500;

%训练网络
net.trainParam.lr=0.5;
net.trainParam.epochs=25000;      %训练次数取5000
net.trainParam.goal=0.01;        %误差门限取0.001
net=train(net,P_train,Tn_train); %训练神经网络
YY=sim(net,P_train);
[maxi,ypred]=max(YY);
maxi=maxi';
ypred=ypred';
CC=ypred-T_train';
n=length(find(CC==0));
Accuracytrain=n/size(P_train,2)%算识别的标签和真实的标签不一样的个数,从而计算出正确率

YY=sim(net,P_test);
[maxi,ypred]=max(YY);
maxi=maxi';
ypred=ypred';
CC=ypred-T_test';
n=length(find(CC==0));
Accuracytest=n/size(P_test,2)

%%读取单个语音
s = sprintf('voice_data/%i.wav',2); %改动路径 2就是第2个，3就是第3个，自己选择一个语音
[s1 fs1] = audioread(s);%读取
v = mfcc(s1, fs1);%提取特征参数
a= vqlbg(v, k); %量化
a=a(:);
b=mapminmax('apply',a,settings);%归一
YY=sim(net,b);
[maxi,ypred]=max(YY);
leibie = ypred-1  %显示类别标签

save('VoiceRecognition_2.0/neting.mat','settings','net'); 