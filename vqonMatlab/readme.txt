在MATLAB环境下实现基于矢量量化的说话人识别系统。在实时录音的情况下，利用该说话人识别系统，对不同的人的1s～7s的语音进行辨识。实现与文本无关的自动说话人确认的实时识别。
使用说明：

1 训练
打开Matlab 使Current Directory为VQ所在的文件夹(比如：E:\vq)
在Command windows中输入
train('1s\',7) 
这是将1s中的wav文件进行特征提取并产生VQ码本，
在workspace中有个ans的文件保存为.m文件，比如7.m，保存在1s文件夹下。（1s表示语音长1秒）

2 识别
在Command windows中输入
test('4s/',7,ans)
其中的ans 就是步骤1产生的码本。（必须保证7.m在workspace中打开）此时就会显示结果。
Speaker 1 matches with speaker 2
Speaker 2 matches with speaker 3
Speaker 3 matches with speaker 4
Speaker 4 matches with speaker 6
Speaker 5 matches with speaker 2
Speaker 6 matches with speaker 7
Speaker 7 matches with speaker 7

1s、4s分别是7个不同的人说话的录音，只是打乱了次序。


感谢  Christian Cornaz
感谢   湖北工业大学模式及智能控制实验室的同学帮忙录音。
Usr    annya_156@163.com


 
 