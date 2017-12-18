fs=11025;
disp('初始化中···');
for i=0:9
     fid=fopen(strcat('d:/data/',num2str(i),'size.txt'),'r');
     [d,count]=fscanf(fid,'%d');
     status=fclose(fid);
	 fid=fopen(strcat('d:/data/',num2str(i),'.txt'),'r');
     reff(i+1).mfcc=zeros(d,24);
     [X,count]=fscanf(fid,'%f ');
     for j=1:24
         reff(i+1).mfcc(:,j)=X((j-1)*d+1:j*d);
     end
%     test(i+1).mfcc=reff(i+1).mfcc;
end
disp('模板已加载');
disp('准备录音，按任意键开始：');
pause;
disp('录音开始');
x=wavrecord(8*fs,fs,'double');
x=quzao(x);
disp('结束录音');
[x1 x2] = vad(x);
m = mfcc(x);
nu=11;
for i=1:nu
    testt(i).mfcc = m(x1(i)-2:x2(i)-2,:);
end

dist = zeros(nu,10);
for i=1:nu
for j=1:10
	dist(i,j) = dtw2(testt(i).mfcc, reff(j).mfcc);
end
end

disp('正在计算匹配结果...')
fprintf('识别结果为：');
for i=1:nu
	[d,j] = min(dist(i,:));
	fprintf('%d', j-1);
end
