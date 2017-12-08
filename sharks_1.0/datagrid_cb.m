function datagrid_cb(action)
%DATAGRID_CB Callback routines for DATAGRID.

%   $Revision: 1.4 $  $Date: 2002/06/08 10:13:10 $
% Copyright 1984-2002 The MathWorks, Inc.

switch(action)
  
 case 'slider1'
  set(gcf,'pointer','watch')
  cind = round((get(findobj(gcf,'Tag','slider2'),'Value')));
  if isempty(cind)
    cind = 1;
  end
  rind = abs(round((get(findobj(gcf,'Tag','slider1'),'Value'))));
  ndata = get(gco,'Userdata');
  [r,c] = size(ndata{1});
  newdata = ndata{1}(rind:rind+ndata{3}-1,cind:cind+ndata{4}-1);
  newdata = newdata(:);
  ug = sort(findobj(gcf,'Tag','gridcell'));
  set(ug,{'String'},newdata)
  ur = sort(findobj(gcf,'Tag','rowcell'));
  set(ur,{'String'},ndata{2}(rind:rind+ndata{3}-1))
  set(gcf,'pointer','arrow')
  
 case 'slider2'
  set(gcf,'pointer','watch')
  cind = round((get(findobj(gcf,'Tag','slider2'),'Value')));
  rind = abs(round((get(findobj(gcf,'Tag','slider1'),'Value'))));
  if isempty(rind)
    rind = 1;
  end
  ndata = get(gco,'Userdata');
  [r,c] = size(ndata{1});
  newdata = ndata{1}(rind:rind+ndata{3}-1,cind:cind+ndata{4}-1);
  newdata = newdata(:);
  ug = sort(findobj(gcf,'Tag','gridcell'));
  set(ug,{'String'},newdata);
  uc = sort(findobj(gcf,'Tag','colcell'));
  set(uc,{'String'},ndata{2}(cind:cind+ndata{4}-1));
  set(gcf,'pointer','arrow');
  
end
