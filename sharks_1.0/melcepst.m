function c=melcepst(s,fs)
%MELCEPST Calculate the mel cepstrum of a signal C=(S,FS,W,NC,P,N,INC,FL,FH)

if nargin<2 fs=8000; end
w='M';
 nc=12;
 p=floor(3*log(fs)); 
 n=pow2(floor(log2(0.03*fs)));

   fh=0.5;   
   fl=0;
   inc=floor(n/2);
    
  
if length(w)==0
   w='M';
end

   z=enframe(s,hamming(n),inc);

f=rfft(z.');
[m,a,b]=melbankm(p,n,fs,fl,fh,w);

pw=f(a:b,:).*conj(f(a:b,:));
pth=max(pw(:))*1E-6;
   
ath=sqrt(pth);
   y=log(max(m*abs(f(a:b,:)),ath));

c=rdct(y).';
nf=size(c,1);
nc=nc+1;
if p>nc
   c(:,nc+1:end)=[];
elseif p<nc
   c=[c zeros(nf,nc-p)];
end


