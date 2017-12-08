function [x1,x2]=vad(x)

%���ȹ�һ����[-1,1]
x=wavread('G:\��ҵ�������\record\dang4-5.wav');
% [x]=wavread('G:\voice\WN_clean.wav');
x=double(x);
x=x/max(abs(x));

%��������
framelen=256;
framelnc=80;

amp1=10;
amp2=2;
zcr1=10;
zcr2=5;

maxsilence=3;%3*10ms=30ms
minlen=15; %15*10ms=150ms
status=0;
count=0;
silence=0;

%���������
tmp1=enframe(x(1:length(x)-1),framelen,framelnc);
tmp2=enframe(x(2:length(x)),framelen,framelnc);
signs=(tmp1.*tmp2)<0;
diffs=(tmp1-tmp2)>0.02;
zcr=sum(signs.*diffs,2);

%�����ʱ����
amp=sum(abs(enframe(filter([1 -0.9375],1,x),framelen,framelnc)),2);

%������������
amp1=min(amp1,max(amp)/4);
amp2=min(amp2,max(amp)/8);

%��ʼ�˵���
x1=0;
x2=0;
for n=1:length(zcr)
    goto=0;
    switch status
        case {0,1}
            if amp(n)>amp1 || zcr(n)>zcr1                %ȷ�Ž���������
                x1=max(n-count-1,1)
                status=2;
                silence=0;
                count=count+1;
            elseif amp(n)>amp2 || zcr(n)>zcr2 %���ܴ���������
                status=1;
                count=count+1;
            else
                status=0;
                count=0;
            end
        case 2,                            %2��������
            if amp(n)>amp2 || zcr(n)>zcr2     %������������
                count=count+1;
            else
                silence=silence+1;
                if silence<maxsilence
                    count=count+1;
                elseif count<minlen
                    status=0;
                    silence=0;
                    count=0;
                else
                    status=3;
                end
            end
        case 3,
            break;
    end
end

count=count-silence/2
x2=x1+count-1

subplot(3,1,1)
plot(x)
axis([1 length(x) -1 1])
line([x1*framelnc x1*framelnc],[-1 1],'color','red');
line([x2*framelnc x2*framelnc],[-1 1],'color','red');
ylabel('ԭʼ�ź�');
text(x1*framelnc,0.5,'��ʼ�˵� \rightarrow',...
     'HorizontalAlignment','right');
text(x2*framelnc,0.5,'\leftarrow �����˵� ',...
     'HorizontalAlignment','left');
 
subplot(3,1,2)
plot(amp);
axis([1 length(amp) 0 max(amp)])
line([x1 x1],[min(amp),max(amp)],'color','red');
line([x2 x2],[min(amp),max(amp)],'color','red');
ylabel('��ʱ����');
text(x1,max(amp)/2,'��ʼ�˵� \rightarrow',...
     'HorizontalAlignment','right');
text(x2,max(amp)/2,'\leftarrow �����˵� ',...
     'HorizontalAlignment','left');
 
subplot(3,1,3)
plot(zcr)
axis([1 length(zcr) 0 max(zcr)])
line([x1 x1],[min(zcr),max(zcr)],'color','red');
line([x2 x2],[min(zcr),max(zcr)],'color','red');
ylabel('������');
text(x1,max(zcr)/2,'��ʼ�˵� \rightarrow',...
     'HorizontalAlignment','right');
text(x2,max(zcr)/2,'\leftarrow �����˵� ',...
     'HorizontalAlignment','left');