% [filename,pathname] =uigetfile('*.wav','选择语音文件');
% if isequal(filename,0) || isequal(pathname,0)
%     return;
% end
% str=[pathname filename];
[s1, fs1] = audioread('1234.wav');%读取

[x1,x2] = vad(s1);

