clc
clear

k = 11;
data_matrix=[];%保存训练数据
data_matrix2=[];%保存测试数据

%元胞数组，下标从1开始
strs = {'我','要','一箱','多糖','少糖','正常','核桃','花生','牛奶'}

%重要: 开头的数字代表的含义
%0 NAN 静音
%1 strs{1} = '我';
%2 strs{2} = '要';
%3 strs{3} = '一箱';
%4 strs{4} = '多糖';
%5 strs{5} = '少糖';
%6 strs{6} = '正常';
%7 strs{8} = '核桃';
%8 strs{9} = '花生';
%9 strs{10} = '牛奶';
%  ...   ...   ...

%0~9每个语音录10遍，训练数据为00，01，02，... ，09
%测试数据为000，001，002，... ，009
%每个数字再分别录制一遍 0，1，2，... ，9

%载入训练数据，并提取特征
T_train=[];
%T_test=[];
for i=1:9
    for j=1:9
        s = sprintf('voice_data4/train/%i%i.wav',i,j);%把格式化的数据写入某个字符串中
        [s1 fs1] = audioread(s);%读取
        v = mfcc(s1, fs1);%提取特征参数
        a = vqlbg(v, k); %量化
        data_matrix=[data_matrix,a(:)];
        T_train=[T_train,i];
    end
end

%{
 %载入测试数据，并提取特征
for i=1:9
    for j=1:5
        s = sprintf('voice_data4/test/%i0%i.wav',i,j);
        [s1 fs1] = audioread(s);
        v = mfcc(s1, fs1);
        a= vqlbg(v, k); 
        data_matrix2=[data_matrix2,a(:)];
        T_test=[T_test,i+1];
    end
end
%}

%样本的标签
%把data_matrix归一化处理变P_train，在范围（0,1）内，归一化主要是为了消除不同量纲对结果的影响
[P_train,settings] = mapminmax(data_matrix,0,1);
Tn_train=BP(T_train');

%[P_test]=mapminmax(data_matrix2,'apply',settings);%归一
%Tn_test=BP(T_test');
%P_train=P_train;
%P_test=P_test;

%创建三层前向神经网络,隐层神经元为200输出层神经元为10，traingda 自适应lr梯度下降法
%隐藏层激活函数 tansig（sigmoid函数）
net=newff(minmax(P_train),[200,9],{'tansig' 'tansig'},'traingda');

%设置网络的训练参数
net.trainParam.show=500;         % show：显示的间隔次数，默认：25
net.trainParam.lr=0.5;           % lr：学习率，默认：0.01
net.trainParam.epochs=5000;      % epochs：训练的次数，默认：100 %训练次数取5000
net.trainParam.goal=0.01;        % goal：误差性能目标值，默认：0 %误差门限取0.001

%调用 traingda 算法训练 BP 网络
net=train(net,P_train,Tn_train); %训练神经网络
YY=sim(net,P_train); %对 BP 网络进行仿真

%{
[maxi,ypred]=max(YY);
%maxi=maxi';
ypred=ypred';
CC=ypred-T_train';
n=length(find(CC==0));
Accuracytrain=n/size(P_train,2);%算识别的标签和真实的标签不一样的个数,从而计算出正确率

YY=sim(net,P_test);
[~,ypred]=max(YY);
%maxi=maxi';
ypred=ypred';
CC=ypred-T_test';
n=length(find(CC==0));
Accuracytest=n/size(P_test,2);
%}

%读取单个语音
s = sprintf('voice_data3/%i.wav',1); 
[s1 fs1] = audioread(s);%读取
v = mfcc(s1, fs1);%提取特征参数
a= vqlbg(v, k); %量化
a=a(:);
b=mapminmax('apply',a,settings);%归一
YY=sim(net,b);
[maxi,ypred]=max(YY);
leibie = ypred  %显示类别标签

res = strs{leibie}

save('VoiceRecognition_4.0/neting.mat','settings','net'); 