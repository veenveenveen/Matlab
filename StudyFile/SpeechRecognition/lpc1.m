  %包括了 预加重 分帧和提取特征参数
   function c = plc1(x)
    % 预加重滤波器
    w=double(x);
    w=filter([1 -0.9375],1,w);  
    
    % 语音信号分帧
    w=enframe(w,256,128);
    
    % 计算每帧的LPC参数
    for i=1:size(w,1)                                           
    y = w(i,:);
    s = y' .* hamming(256);
    a= lpc(s,14);%调用lpc函数
    end
    
    c=a;