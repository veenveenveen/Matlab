clc
clear
close all

[bp_lpc_input_voice] = textread('vioce_train.txt','%s'); 
[BP_Frow BP_Fclu]=size(bp_lpc_input_voice);                                  
bp_filename=char(bp_lpc_input_voice);                                     
disp('开始读取语音数据...')                           
for i=1:1:BP_Frow  
    bp_wavfilename1=strcat('1/',bp_filename(i,:));                   
    a1=wavread(bp_wavfilename1);                              
    samples{1}{i}=a1;                                        
    
    bp_wavfilename2=strcat('2/',bp_filename(i,:));                 
    a2=wavread(bp_wavfilename2);                               
    samples{2}{i}=a2;                                         
     
    bp_wavfilename3=strcat('3/',bp_filename(i,:));                  
    a3=wavread(bp_wavfilename3);                                 
    samples{3}{i}=a3;                                        
    
    bp_wavfilename4=strcat('4/',bp_filename(i,:));                  
    a4=wavread(bp_wavfilename4);                                
    samples{4}{i}=a4;                                        
    
    bp_wavfilename5=strcat('5/',bp_filename(i,:));                 
    a5=wavread(bp_wavfilename5);                                
    samples{5}{i}=a5;                                         
    
    bp_wavfilename6=strcat('6/',bp_filename(i,:));                  
    a6=wavread(bp_wavfilename6);                                 
    samples{6}{i}=a6;                                          
    
    bp_wavfilename7=strcat('7/',bp_filename(i,:));                 
    a7=wavread(bp_wavfilename7);                                 
    samples{7}{i}=a7;                                         
    
    bp_wavfilename8=strcat('8/',bp_filename(i,:));                   
    a8=wavread(bp_wavfilename8);                                  
    samples{8}{i}=a8;                                         
    
    bp_wavfilename9=strcat('9/',bp_filename(i,:));                   
    a9=wavread(bp_wavfilename9);                                  
    samples{9}{i}=a9;                                          
    
    bp_wavfilename10=strcat('10/',bp_filename(i,:));                   
    a10=wavread(bp_wavfilename10);                                  
    samples{10}{i}=a10;                                        
end


for i=1:length(samples)                                
	bp_lpc_sample=[];
	for k=1:length(samples{i})
		bp_lpc_sample(k).wave = samples{i}{k};

		bp_lp_c= lpc1(bp_lpc_sample(k).wave);  %求lpc特征系数 
        net{i}=bp(bp_lp_c);  %调用BP神经网络函数
    end                                                        

end

save biase_bp_wave_recogin/lpc_train_bp_mode  net

    


