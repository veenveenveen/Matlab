function [thr,sorh,keepapp,crit] = den(dorc,worwp,x)

[c,l]=Wavedec(x,3,'db2');
cdl=detcoef(c,l,1);
ff=median(abs(cdl))/0.6745;
if isequal(worwp,'wv')
   if errargn(mfilename,nargin,[3],nargout,[0:3]), error('*'), end
elseif isequal(worwp,'wp')
   if errargn(mfilename,nargin,[3],nargout,[0:4]), error('*'), end
else
   errargt(mfilename,'invalid argument value','msg'); error('*')
end
if ~(isequal(dorc,'den') | isequal(dorc,'cmp'))
   errargt(mfilename,'invalid argument value','msg'); error('*')
end

% Set problem dimension.
if min(size(x))~=1, dim = 2; else , dim = 1; end
% Set keepapp default value.
keepapp = 1;
% Set sorh default value.
if isequal(dorc,'den') & isequal(worwp,'wv') , sorh = 's'; else ,sorh = 'h'; end
% Set threshold default value.
n = prod(size(x));
% nominal threshold.
switch dorc
  case 'den'
    switch worwp
      case 'wv' , thr = sqrt(2*log(n))*ff;               % wavelets.
      case 'wp' , thr = sqrt(2*log(n*log(n)/log(2))); % wavelet packets.
    end

  case 'cmp' ,  thr = 1;
end

% rescaled threshold.
if dim == 1
    [c,l] = wavedec(x,1,'db1');
    c = c(l(1)+1:end);
else
    [c,l] = wavedec2(x,1,'db1');
    c = c(prod(l(1,:))+1:end);
end

normaliz = median(abs(c));

% if normaliz=0 in compression, kill the lowest coefs.
if dorc == 'cmp' & normaliz == 0 
    normaliz = 0.05*max(abs(c)); 
end

if dorc == 'den'
    if worwp == 'wv'
        thr = thr*normaliz/0.6745;
    else
        crit = 'sure';
    end
else
    thr = thr*normaliz;
    if worwp == 'wp', crit = 'threshold'; end
end

