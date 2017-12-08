A=1:9;
A=reshape(A',3,3)';
A1=10:18;
A(:,:,2)=reshape(A1',3,3)';
A1=19:27;
A(:,:,3)=reshape(A1',3,3)';
B=[];
for i=1:size(A,3)
B=[B A(:,:,i)];
end


