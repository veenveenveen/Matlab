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
    a= lpc(s',14);%调用lpc函数
    m(i,:)=a;
    end
     %线性规整
    leng=size(m,1);
    xi=linspace(1,leng,20);
    for i=1:size(xi,1)                                           
    c1= m(i,:);
    c2=interp1((1:1:size(m,2)),c1',xi,'pchip');
    b(i,:)=c2;
    end 
   
    c=b;