clear
global hpop hlist
clf reset
H=axes('unit','normalized','position',[0,0,1,1],'visible','off');
set(gcf,'currentaxes',H);
str='\fontname{隶书}';
h_fig=get(H,'parent');
set(h_fig,'unit','normalized','position',[0.1,0.2,0.7,0.6]);
 hlist=uicontrol(h_fig,'style','list','unit','normalized',...
     'position',[0.7,0.6,0.2,0.2],...
    'string','录音|滤波|分帧|端点检测|录音回放','MAX',2);
hpush=uicontrol(h_fig,'style','push','unit','normalized',...
    'position',[0.76,0.32,0.1,0.06],'string',{'运行'},'callback',...
 'yuyin');