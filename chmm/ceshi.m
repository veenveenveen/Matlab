x = wavread('G:\毕业论文相关\record\my.wav');
[x1 x2] = vad(x);
m = mfcc(x);
m = m(x1-2:x2-2,:);
for k=1:14
    pout(k) = viterbi(hmm{k},m);
end
[d,n] = max(pout);
switch n
    case 1
        disp('识别结果为汉语数字"0"');
    case 2
        disp('识别结果为汉语数字"1"');        
    case 3
        disp('识别结果为汉语数字"2"');        
    case 4
        disp('识别结果为汉语数字"3"');
    case 5
        disp('识别结果为汉语数字"4"');
    case 6
        disp('识别结果为汉语数字"5"');
    case 7
        disp('识别结果为汉语数字"6"');
    case 8
        disp('识别结果为汉语数字"7"');
     case 9
        disp('识别结果为汉语数字"8"');
     case 10
        disp('识别结果为汉语数字"9"');
     case 11
        disp('识别结果为汉字"郑"');  
     case 12
        disp('识别结果为汉字"州"');
     case 13
        disp('识别结果为汉字"大"');
     case 14
        disp('识别结果为汉字"学"');  
     otherwise
        disp('未知汉字');
end
