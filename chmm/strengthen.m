%function y=strengthen(x)


%Bark小波包分解
%x=wavread('E:\voice\matlabcode\myhmm\WN_clean.wav');
x=wavread('jin1-6.wav');
subplot(2,1,1);
plot(x);
axis([0 20000 -1 1]);
wptree=wpdec(x,7,'db5');
%把Bark小波分解包中的第五层的叶结点合并
for k=47:62
wptree=wpjoin(wptree,k);
end
%把Bark小波分解包中的第六层的叶结点合并
for k=79:86
wptree=wpjoin(wptree,k);
end
for k=91:94
wptree=wpjoin(wptree,k);
end
%plot(wptree);
%将各节点按相应阈值进行处理
sorh='n';%所选阈值函数
%-----------
%处理7层节点
%-----------
for i=0:31
c70(:,i+1)=wpcoef(wptree,[7 i]);
q70=median(abs(c70(:,i+1)));
arr70(i+1)=(q70/0.6745).*sqrt(2*log(442));
if(i>0)
c70(:,i+1)=wthresh(c70(:,i+1),sorh,arr70(i+1));
wptree=write(wptree,'data',[7 i],c70(:,i+1));%修改节点系数值
end
end
for i=48:55
c71(:,i-47)=wpcoef(wptree,[7 i]);
q71=median(abs(c71(:,i-47)));
arr71(i-47)=(q71/0.6745).*sqrt(2*log(442));
c71(:,i-47)=wthresh(c71(:,i-47),sorh,arr71(i-47));
wptree=write(wptree,'data',[7 i],c71(:,i-47));
%修改节点系数值
end
%-----------
%处理6层节点
%-----------
for j=16:23
c60(:,j-15)=wpcoef(wptree,[6 j]);
q60=median(abs(c60(:,j-15)));
arr60(j-15)=(q60/0.6745).*sqrt(2*log(876));
c60(:,j-15)=wthresh(c60(:,j-15),sorh,arr60(j-15));
wptree=write(wptree,'data',[6 j],c60(:,j-15));
%修改节点系数值
end
for j=28:31
c61(:,j-27)=wpcoef(wptree,[6 j]);
q61=median(abs(c61(:,j-27)));
arr61(j-27)=(q61/0.6745).*sqrt(2*log(876));
c61(:,j-27)=wthresh(c61(:,j-27),sorh,arr61(j-27));
wptree=write(wptree,'data',[6 j],c61(:,j-27));
%修改节点系数值end
end
%-----------
%处理5层节点
%-----------
for k=16:31
c5(:,k-15)=wpcoef(wptree,[5 k]);
q5=median(abs(c5(:,k-15)));
arr5(k-15)=(q5/0.6745).*sqrt(2*log(1743));
c5(:,k-15)=wthresh(c5(:,k-15),sorh,arr5(k-15));
wptree=write(wptree,'data',[5 k],c5(:,k-15));%修改节点系数值
end
%重建信号
y=wprec(wptree);
subplot(2,1,2);
plot(y);
axis([0 20000 -1 1]);
wavwrite(y,8000,'E:\voice\matlabcode\myhmm\WtDeSpeech.wav');
