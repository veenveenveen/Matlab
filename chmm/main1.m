clear;
 t1=cputime;
tic;
COUNT=14;
PERSON=10;
NUMBER=3;
filename={'chang','dang','feng','li','jiang','jin','shui','xin','zhao','zhou'};
file='G:\��ҵ�������\record\';

%for i=1:COUNT
 %   for j=1:PERSON
  %      tempname=[filename{j},num2str(i-1),'.wav'];
  %      samples{i,j}=wavread(tempname);
   %end
%end




for i=1:COUNT
    for j=1:PERSON
        for m=1:NUMBER
            tempname=[file,filename{j},num2str(m),num2str('-'),num2str(13),'.wav'];
            samples{i,j,m}=wavread(tempname);
        end      
    end
end

%     for j=1:PERSON
%         for m=1:NUMBER
%             tempname=[file,filename{j},num2str(m),num2str('-'),num2str('13'),'.wav'];
%             samples{j,m}=wavread(tempname);
%         end      
%     end

%     for j=1:PERSON
%             tempname=[file,filename{j},num2str('5'),num2str('-'),num2str('7'),'.wav'];
%             samples{1,j,1}=wavread(tempname);
%     end



 sample=[];
 for j=1:size(samples,2)
    sample=[sample samples(:,j)];
end
samples=sample;
    for k=1:size(samples,2)
        sample(k).wave = samples{i,k};
        sample(k).data=[];
    end
    
for i =1:size(samples,1)  %i=1:14
    sample=[];
    for k=1:size(samples,2)
        sample(k).wave = samples{i,k};
        sample(k).data=[];
    end
   fprintf('��ʼѵ����%d����\n',i);
   hmm{i}=train(sample,[3 3 3 3]);
end
 t2=cputime-t1;
fprintf('runtime = %6.2f\n',t2);
%toc;
