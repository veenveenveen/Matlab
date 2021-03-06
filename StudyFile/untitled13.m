clear all 
 clc 
 %%%----训练摸板-----%%% 
p=[ 1.0000    0.0013    0.0012    0.0003    0.0000    0.0000    0.0007    0.0000;   
0.9998    0.0199    0.0015    0.0002    0.0001    0.0000    0.0001    0.0000; 
0.9994    0.0344    0.0047    0.0011    0.0002    0.0000    0.0016    0.0003; 
1.0000    0.0003    0.0000    0.0000    0.0000    0.0000    0.0000    0.0000; 
1.0000    0.0025    0.0006    0.0001    0.0000    0.0000    0.0003    0.0000; 
0.9925    0.0358    0.0601    0.0928    0.0006    0.0036    0.0331    0.0161; 
0.9996    0.0299    0.0021    0.0002    0.0001    0.0000    0.0000    0.0000; 
0.9998    0.0110    0.0059    0.0119    0.0001    0.0005    0.0031    0.0018; 
1.0000    0.0014    0.0012    0.0003    0.0000    0.0000    0.0007    0.0000; 
1.0000    0.0013    0.0012    0.0003    0.0000    0.0000    0.0007    0.0000; 
0.9998    0.0210    0.0016    0.0002    0.0001    0.0000    0.0001    0.0000; 
0.9998    0.0198    0.0057    0.0019    0.0001    0.0001    0.0030    0.0004; 
1.0000    0.0003    0.0000    0.0000    0.0000    0.0000    0.0000    0.0000; 
1.0000    0.0016    0.0006    0.0001    0.0000    0.0000    0.0003    0.0000; 
0.5549    0.2515    0.4370    0.6099    0.0044    0.0250    0.2272    0.1171; 
0.9995    0.0175    0.0104    0.0221    0.0001    0.0010    0.0058    0.0034; 
0.9997    0.0226    0.0015    0.0001    0.0001    0.0000    0.0000    0.0000; 
0.0503    0.5068    0.1398    0.8401    0.0042    0.0435    0.0403    0.1090; 
0.0486    0.5066    0.1146    0.8441    0.0078    0.0525    0.0445    0.1027; 
0.9227    0.2779    0.0498    0.2567    0.0070    0.0277    0.0272    0.0391; 
0.0563    0.4379    0.1159    0.8811    0.0062    0.0407    0.0463    0.1073; 
0.0574    0.5441    0.1221    0.8177    0.0077    0.0468    0.0435    0.1138; 
0.0638    0.5889    0.1112    0.7879    0.0076    0.0459    0.0445    0.1084; 
0.0641    0.5153    0.1530    0.8313    0.0069    0.0407    0.0518    0.1079;]'; 
%%%%--------目标输出----%%%%% 
  t=[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1]; 
 %%%%----仿真数据----%%%%% 
 p1=[0.0729    0.5666    0.1865    0.7868    0.0093    0.0487    0.0647    0.1144; 
     0.0729    0.5666    0.1865    0.7868    0.0093    0.0487    0.0647    0.1144; 
     0.0549    0.5225    0.1221    0.8331    0.0051    0.0427    0.0369    0.1088; 
     0.0574    0.5034    0.1267    0.8431    0.0054    0.0436    0.0445    0.1118; 
     0.0563    0.4379    0.1159    0.8811    0.0062    0.0407    0.0463    0.1073; 
     1.0000    0.0003    0.0000    0.0000    0.0000    0.0000    0.0000    0.0000; 
     1.0000    0.0011    0.0006    0.0001    0.0000    0.0000    0.0002    0.0000; 
     0.9998    0.0215    0.0015    0.0001    0.0001    0.0000    0.0001    0.0000 
     0.9920    0.0232    0.0913    0.0322    0.0007    0.0014    0.0764    0.0124; 
     1.0000    0.0004    0.0000    0.0000    0.0000    0.0000    0.0000    0.0000; 
     1.0000    0.0011    0.0005    0.0001    0.0000    0.0000    0.0002    0.0000;]'; 
 %%%------建立BP神经网络-------%%%%%%%% 
net=newff(minmax(p),[8,1],{'logsig','purelin'},'traingdx','learngdm'); 
net.trainParam.epochs=5000; 
net.trainParam.goal=0.0001; 
net.trainParam.show=10; 
net.trainParam.lr=0.01; 
net=init(net); 
%%%%%-----训练神经网络，并用数据仿真，输出结果%%%%% 
net=train(net,p,t); 
y=sim(net,p1);  
 figure(1); 
  plot(y) 
  disp(y) 
