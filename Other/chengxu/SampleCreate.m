function P = SampleCreate(type,N,UnitLength)
% P = SampleCreate(type,N,UnitLength)
% 音频文件名格式：.\type\Ex\rank.wav——type:为字符，S代表sample，T代表测试；Ex代表音频内容(1、2、3...)；rank为该内容文件的序号
% type：为字符串S/T
% N：表示使用多少个音频序列
% UnitLength：一个语素长度，单位ms
% mfcc系数以列向量的方式存储到矩阵中,每个mfcc系数向量长度为12
% 返回用于训练或者仿真的序列P
P=[];
step = 2;           %音频内容的步进
start= 0;
%rank=1;
for rank=1:N      %顺序1\1.wav 2\1.wav ... 1\2.wav 2\2.wav ...
    for Ex=1:step:7
        filename= ['/Users/himin/Documents/MATLAB/Other/chengxu/' type '/' num2str(Ex) '/' num2str(rank) '.wav']
        [xVoice freq]  = wavread(filename);        % xVoice用于临时存储读入的音频文件
        xMfcc   = mfcc(xVoice,fix(UnitLength*freq/1000),freq);             % 获得mfcc系数矩阵；xMfcc用于存储未经处理的xMfcc矩阵——包含多帧
        reMfcc  = MfccProcess(xMfcc);       % reMfcc用于保存处理好的mfcc列向量
        if eps>start
            P   = reMfcc;
        else
            P   = [P reMfcc];
        end
        start   = 1;
    end
end