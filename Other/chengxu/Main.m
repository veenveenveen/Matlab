%由于设计时间有限，程序没有做输入参数有效性检测
N = 5;                      % N为读取每种数字音频训练样本的个数
M = 3;                      % M为读取每种数字音频测试样本的个数
UnitLength = 20;            % 认识语音信号短时不变的时长，单位为ms
TestMW = [ 1 2 3];          % 测试样本中数据的标记，向量内容按次序对应1.wav、2.wav……
                            % 1代表该组样本为训练样本、2代表改组样本为A的测试样本、3代表改组样本为B的测试样本
                            % 一组样本由同一个人的1、3、5的音频组成
%这里我们辨别1、3、5
T1 = [1 0 0]'               % 1的输出
T3 = [0 1 0]'               % 3的输出
T5 = [0 0 1]'               % 5的输出
Ttemp = [T1 T3 T5]          % 一个输出单元
T = Ttemp;
for i=1:N-1
    T = [T Ttemp];
end

PS  = SampleCreate('S',N,UnitLength);
PR1 = min(PS');
PR1 = PR1';
PR2 = max(PS');
PR2 = PR2';
PR  = [PR1 PR2];
if size(PS,1)==size(T,1)
    if size(T,2)==size(PS,2)
    %如果位数匹配则训练
        netBP = newff(PR,[30,10,3],{'tansig','tansig','tansig'},'trainbfg');        % 产生网络
        netBP.trainParam.epochs = 100;                                              % 设置训练步数
        %对于trainbfg小于100
        [net tr] = train(netBP,PS,T);
        plotperf(tr);                                               % 观看训练记录
        Test = SampleCreate('T',M,UnitLength);                      % 生成测试数据
        Y = sim(net,Test)                                           % 观看输出
'OK'
    else
        '维数不匹配'
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%制作分辨谱
figure(121);
hold on;
title('分辨谱');
%axis tight;
xlabel('目标值');
ylabel('样本序号');
imagesc([1:size(Y,2)],[1 3 5],abs(Y));
colormap(gray);
hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%识别误差分析
%制作标准结果
Standard = Ttemp;
for j=1:M-1
    Standard = [Standard Ttemp];
end
delta = Standard-Y;                                                 %求出差值
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%使用均方和
deltaSqr = delta.*delta;                                            %求平方
deltaSqrt = sqrt(sum(deltaSqr)/3);                                    %均方误差
figure(1);
plot(deltaSqrt);
hold on;
title('均方根误差');
grid on;
for k=1:length(TestMW)
    for l=3*(k-1)+1:3*k                                             %第k个测试者
        switch(TestMW(k))                                           %选择数据点样式
            case 1
                sign = 'ko';
            case 2
                sign = 'r*';
            case 3
                sign = 'md';
            otherwise
                sign = 'y.';
        end
        plot(l,deltaSqrt(l),sign);                                    %绘制数据点
    end
end
hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%使用绝对值求和
deltaOp  = abs(delta);                                              %求绝对值
deltaOpS = sum(deltaOp)/3;                                           %均绝对值和
figure(2);
plot(deltaOpS);
hold on;
title('误差绝对值和');                                               
grid on;
for k=1:length(TestMW)
    for l=3*(k-1)+1:3*k                                             %第k个测试者
        switch(TestMW(k))                                           %选择数据点样式
            case 1
                sign = 'ko';
            case 2
                sign = 'r*';
            case 3
                sign = 'md';
            otherwise
                sign = 'y.';
        end
        plot(l,deltaOpS(l),sign);                                    %绘制数据点
    end
end
hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
