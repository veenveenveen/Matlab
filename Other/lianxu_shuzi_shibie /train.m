fs=11025;
x=zeros(2*fs,10);
disp('训练开始，按任意键继续：');
pause;
for i=0:9
    disp(strcat('请说“',num2str(i),'”：'));
    disp('录音开始');
    t=wavrecord(2*fs,fs,'double');
    t=quzao(t);
    x(:,i+1)=t;
    disp('结束录音');
end
for i=0:9
    [x1 x2] = vadtrain(x(:,i+1));
	m = mfcc(x(:,i+1));
	m = m(x1-2:x2-2,:);
	ref(i+1).mfcc = m;
    fid=fopen(strcat('d:/data/',num2str(i),'.txt'),'w');
    fprintf(fid,'%12.16f ',ref(i+1).mfcc);
    status=fclose(fid);
    fid=fopen(strcat('d:/data/',num2str(i),'size.txt'),'w');
    fprintf(fid,'%d ',size(ref(i+1).mfcc,1));
    status=fclose(fid);
end

    

