
load  lpc_train_bp_mode  net;

%net=lpc_train_bp_mode;
[bp_lpc_input_voice] = textread('vioce_recogin.txt','%s'); 
[Frow Fclu]=size(bp_lpc_input_voice);                                  
bp_filename=char(bp_lpc_input_voice);                                     
disp('开始识别.....')                           
for i=1:1:Frow  
    bp_wavfilename1=strcat('1/',bp_filename(i,:));                   
    a1=audioread(bp_wavfilename1);
    bp_lp_c= lpc1(a1);  
        for k=1:10
            bp_pout = bp_test(bp_lp_c,net{k});   
            pout{k}=bp_pout;
    
        end
        [d,n] = max(pout{k});
        x1=d;
end

for i=1:1:Frow  
    bp_wavfilename2=strcat('2/',bp_filename(i,:));                   
    a2=audioread(bp_wavfilename2);
    bp_lp_c= lpc1(a2);  
        for k=1:10
            bp_pout = bp_test(bp_lp_c,net{k});   
            pout{k}=bp_pout;
    
        end
        [d,n] = max(pout{k}); 
        x2=d;
end

for i=1:1:Frow  
    bp_wavfilename3=strcat('3/',bp_filename(i,:));                   
    a3=audioread(bp_wavfilename3);
    bp_lp_c= lpc1(a3);  
        for k=1:10
            bp_pout = bp_test(bp_lp_c,net{k});   
            pout{k}=bp_pout;
    
        end
        [d,n] = max(pout{k}); 
        x3=d;
end

for i=1:1:Frow  
    bp_wavfilename4=strcat('4/',bp_filename(i,:));                   
    a4=audioread(bp_wavfilename4);
    bp_lp_c= lpc1(a4);  
        for k=1:10
            bp_pout = bp_test(bp_lp_c,net{k});   
            pout{k}=bp_pout;
    
        end
        [d,n] = max(pout{k});
        x4=d;
end

for i=1:1:Frow  
    bp_wavfilename5=strcat('5/',bp_filename(i,:));                   
    a5=audioread(bp_wavfilename5);
    bp_lp_c= lpc1(a5);  
        for k=1:10
            bp_pout= bp_test(bp_lp_c,net{k});   
            pout{k}=bp_pout;
    
        end
        [d,n] = max(pout{k}); 
        x5=d;
end

for i=1:1:Frow  
    bp_wavfilename6=strcat('6/',bp_filename(i,:));                   
    a6=audioread(bp_wavfilename6);
    bp_lp_c= lpc1(a6);  
        for k=1:10
            bp_pout = bp_test(bp_lp_c,net{k});   
            pout{k}=bp_pout;
    
        end
        [d,n] = max(pout{k});
        x6=d;
end

for i=1:1:Frow  
    bp_wavfilename7=strcat('7/',bp_filename(i,:));                   
    a7=audioread(bp_wavfilename7);
    bp_lp_c= lpc1(a7);  
        for k=1:10
            bp_pout = bp_test(bp_lp_c,net{k});   
            pout{k}=bp_pout;
    
        end
        [d,n] = max(pout{k}); 
        x7=d;
end

for i=1:1:Frow  
    bp_wavfilename8=strcat('8/',bp_filename(i,:));                   
    a8=audioread(bp_wavfilename8);
    bp_lp_c= lpc1(a8);  
        for k=1:10
            bp_pout = bp_test(bp_lp_c,net{k});   
            pout{k}=bp_pout;
    
        end
        [d,n] = max(pout{k}); 
        x8=d;
end

for i=1:1:Frow  
    bp_wavfilename9=strcat('9/',bp_filename(i,:));                   
    a9=audioread(bp_wavfilename9);
    bp_lp_c= lpc1(a9);  
        for k=1:10
            bp_pout = bp_test(bp_lp_c,net{k});   
            pout{k}=bp_pout;
    
        end
        [d,n] = max(pout{k}); 
        x9=d;
end

for i=1:1:Frow  
    bp_wavfilename10=strcat('10/',bp_filename(i,:));                   
    a10=audioread(bp_wavfilename10);
    bp_lp_c= lpc1(a10);  
        for k=1:10
            bp_pout = bp_test(bp_lp_c,net{k});
            pout{k}=bp_pout;
    
        end
        [d,n] = max(pout{k});
        x10=d;
end

rate=100-(x1+x2+x3+x4+x5+x6+x7+x8+x9+x10)/10;
success_recog_save = xlswrite('biase_bp_wave_recogin/train_recogin_rate.xls',rate,'sheet2');
