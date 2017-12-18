function [x1,x2] = vadtrain(x)

%���ȹ�һ����[-1,1]
x = double(x);
x = x / max(abs(x));

%��������
FrameLen = 256;
FrameInc = 80;

amp1 = 8;
amp2 = 20;
zcr1 =8;
zcr2 = 5;

maxsilence = 8;
minlen  = 15;   
status  = 0;
count   = 0;
silence = 0;

%���������
tmp1  = enframe(x(1:end-1), FrameLen, FrameInc);
tmp2  = enframe(x(2:end)  , FrameLen, FrameInc);
signs = (tmp1.*tmp2)<0;
diffs = (tmp1 -tmp2)>0.05;
zcr   = sum(signs.*diffs, 2);

%�����ʱ����
amp = sum(abs(enframe(filter([1 -0.9375], 1, x), FrameLen, FrameInc)), 2);

%������������
max(amp);
amp1 = min(amp1, max(amp)/3)
amp2 = min(amp2, max(amp)/8)

%��ʼ�˵���
x1 = 0; 
x2 = 0;
for n=1:length(zcr)
   goto = 0;
   switch status
   case {0,1}                   % 0 = ����, 1 = ���ܿ�ʼ
      if amp(n) > amp1          % ȷ�Ž���������
         x1= max(n-count-1,1);
         status  = 2;
         silence = 0;
         count   = count + 1;
      elseif amp(n) > amp2 | ... % ���ܴ���������
             zcr(n) > zcr2
         status = 1;
         count  = count + 1;
      else                       % ����״̬
         status  = 0;
         count   = 0;
      end
   case 2,                       % 2 = ������
      if amp(n) > amp2 | ...     % ������������
         zcr(n) > zcr2
         count = count + 1;
      else                       % ����������
         silence = silence+1;
         if silence < maxsilence % ����������������δ����
            count  = count + 1;
         elseif count < minlen   % ��������̫�̣���Ϊ������
            status  = 0;
            silence = 0;
            count   = 0;
         else                    % ��������
            status  = 3;
        end
      end
   case 3,
      break;
   end
end   

count = count-silence/2;
x2= x1 + count -1;


