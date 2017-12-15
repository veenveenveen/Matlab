function [T] = BP(train_data)
%这是个子函数供BP神经网络调用的
T=train_data(:,1)';
P=train_data(:,2:size(train_data,2))';
clear train_data;                                 
NumberofTrainingData=size(P,2);
NumberofInputNeurons=size(P,1);
   
sorted_target=sort(T,2);
label=zeros(1,1);                               
label(1,1)=sorted_target(1,1);
j=1;
for i = 2:NumberofTrainingData
    if sorted_target(1,i) ~= label(1,j)
        j=j+1;
        label(1,j) = sorted_target(1,i);
    end
end
number_class=j;
NumberofOutputNeurons=number_class;
    
%%%%%%%%%% Processing the targets of training训练的目标处理
temp_T=zeros(NumberofOutputNeurons, NumberofTrainingData);
for i = 1:NumberofTrainingData
    for j = 1:number_class
        if label(1,j) == T(1,i)
            break; 
        end
    end
    temp_T(j,i)=1;
end
T=temp_T*2-1;
                                              
end