function cljsound(action)
%CLJSOUND Demonstrate MATLAB's cljsound capability.   
%   options require the Signal Processing Toolbox.) 
 
global SD_VOLUME SD_NAMES SD_DISP SD_PLOTCMD 
global funcs func_titles

if nargin < 1,
   action = 'initialize';
end;

if strcmp(action,'initialize')
   oldFigNumber=watchon;
   
   %================================================================
   % Set all the global variables
   comp=computer;
  
      SD_NAMES = [ 'yagen   '
         'yi      '
         'kqdnf   '
         'dqs     '
         'dizi    '];
   
   SD_PLOTCMD = str2mat('plot(t,y);xlabel(''Time in seconds'');',...
      ['p=spectrum(y,1024);specplot(p,Fs);h=get(gca,''children'');',...
         'delete(h(1:2));xlabel(''Frequency in Hertz'');'],...
      ['specgram(y,64);set(gca,''XTickLabel'',[]);', ...
         'set(gca,''YTickLabel'',[]);xlabel(''Time'');',...
         'ylabel(''Frequency'');']);
   
   SD_DISP = 1;
   
   S =  brighten([[zeros(8,2) (3:10)'/10]; prism(56)],1/3);
   if (get(0,'ScreenDepth') == 1)
      S = gray(64);
   end
   
   % specify functions
   funcs = str2mat( ...
      'Fs=8000;t=0:1/Fs:2;y = (sin(300*2*pi*t)+sin(330*2*pi*t))/2;',...
      'Fs=8000;t=0:1/Fs:2;y = sin(2*pi*440*erf(t));');
   func_titles = str2mat('(sin(a*t)+sin(b*t))/2',...
      'sin(c*erf(t))');
   
   %================================================================
   figNumber = figure('colormap',S,'visible','on','NumberTitle','off', ...
      'Name','Sound','pointer','watch');
   
   wids = 0.26;
   axes('position', [0.1 .22 .9*(.9-wids) .68], ...
      'vis','off');   
   
   %================================================================
   % Information for all buttons
   labelColor=192/255*[1 1 1];
   top=0.92;
   bottom=0.06;
   left=0.73;
   yInitLabelPos=0.90;
   labelWid=0.23;
   labelHt=0.043;
   btnWid=0.23;
   btnHt=0.0535;
   % Spacing between the label and the button for the same command
   btnOffset=0.003;
   % Spacing between the button and the next command's label
   spacing=0.055;
   
   %=================================================================
   % The CONSOLE frame
   frmBorder=0.02;
   yPos=0.05-frmBorder;
   frmPos=[left-frmBorder yPos btnWid+2*frmBorder 0.88+2*frmBorder];
   h=uicontrol( ...
      'Style','frame', ...
      'Units','normalized', ...
      'Position',frmPos, ...
      'BackgroundColor',[0.5 0.5 0.5]);
   
   %=======================================================================
   % The SOUND command popup menu
   
   % Menu label info
   btnNumber=1;
   yLabelPos=top-(btnNumber-1)*(btnHt+labelHt+spacing);
   labelPos=[left yLabelPos-labelHt labelWid labelHt];
   uicontrol( ...
      'Style','text', ...
      'Units','normalized', ...
      'Position',labelPos, ...
      'BackgroundColor',labelColor, ...
      'HorizontalAlignment','left', ...
      'String',' Sound');
   
   % Pop-up menu info
   btnPos=[left yLabelPos-labelHt-btnHt-btnOffset btnWid btnHt];
  
      popupStr = str2mat(' yagen',' yi', ...
        'kqdnf   ', ' dqs',' diziduzou',' Beats',' FM');
   
   uicontrol('Style','popup',...
      'Units','normalized', ...
      'Position', btnPos, ...
      'String',popupStr, ...
      'Callback','cljsound(''sound'')');
   
   %=======================================================================
   % The DISPLAY command popup menu
   
   % Menu label info
   btnNumber=2;
   yLabelPos=top-(btnNumber-1)*(btnHt+labelHt+spacing);
   labelPos=[left yLabelPos-labelHt labelWid labelHt];
   uicontrol( ...
      'Style','text', ...
      'Units','normalized', ...
      'Position',labelPos, ...
      'BackgroundColor',labelColor, ...
      'HorizontalAlignment','left', ...
      'String',' Display');
   
   % Pop-up menu info
   btnPos=[left yLabelPos-labelHt-btnHt-btnOffset btnWid btnHt];
   
   % Signal Processing Toolbox is on the path
   if exist('specgram')
      uicontrol('Style','popup',...
         'Units','normalized', ...
         'Position', btnPos, ...
         'String',str2mat('Time Sequence','Spectrum','Spectrogram'),...
         'Callback','cljsound(''display'')');
      % Signal Processing Toolbox is not on the path
   else
      uicontrol('Style','text',...
         'Units','normalized', ...
         'Position', btnPos, ...
         'String',str2mat('Time Sequence'));
   end;
   
   
   %=======================================================================
   % The PLAY button
   btnNumber = 3;
   yLabelPos=top-(btnNumber+1)*(btnHt+labelHt+spacing);
   btnPos=[left yLabelPos-labelHt-btnHt-btnOffset btnWid 2*btnHt];
   btnHndl=uicontrol( ...
      'Style','pushbutton', ...
      'Units','normalized', ...
      'Position', btnPos, ...
      'String','Play Sound', ...
      'Callback','cljsound(''play'')');
   % use try-catch to hide the PLAY button if cljsound is unavailable
   soundFlag='on';
   eval('sound(0)','soundFlag=''off'';');
   set(btnHndl,'Visible',soundFlag);
   

   %=======================================================================
   % The CLOSE button
   uicontrol( ...
      'Style','pushbutton', ...
      'Units','normalized', ...
      'Position',[left bottom btnWid 2*btnHt], ...
      'String','Close', ...
      'Callback','cljsound(''close'')');
   
   %=======================================================================
   % The VOLUME slider
   
   SD_VOLUME = uicontrol( ...
      'Units','normal',...
      'Position',[0.125 .09 .8*(.9-wids) .04], ...
      'Style','slider', ...
      'Visible',soundFlag, ...
      'Min',0.01, 'max',1, ...
      'Value',1);
   
   % label volume control
   pos = [0.55 0.04 0.15 0.04];
   uicontrol('style','text', ...
      'Units','normal', ...
      'Position',pos,...
      'String','Volume', ...
      'BackgroundColor',get(gcf,'color'),...
      'Visible',soundFlag, ...
      'ForegroundColor', get(gca,'xcolor'),...
      'Horizontal','left');
   
   %=======================================================================
   % Initialize the demo to yagen with Time Sequence
   y=wavread('G:\毕业论文相关\record\dang4-1.wav');Fs=8000;
   y=y/max(abs(y));t=(0:length(y)-1)/Fs;
   set(gcf,'UserData',[t(:) y(:)]);
   n = SD_DISP;
   eval([SD_PLOTCMD(n,:)]);
   title([int2str(length(y)) ' Samples']);
   drawnow;
   
   set(gcf,'pointer','arrow');
   
   %=======================================================================
   watchoff(oldFigNumber);
   
   % END of INITIALIZE section
   
   %=======================================================================
   % Sound callback.
   
elseif strcmp(action,'sound')
   hndl=gco;
   popStr=get(hndl,'String');
   value=get(hndl,'Value');
   selectStr=deblank(popStr(value,:));
   
   nfiles = size(SD_NAMES,1);
   set(gcf,'pointer','watch');drawnow;
   
   % Load file, if available. Otherwise, use FUNCS to do a fnct evaluation 
   if value <= nfiles
      file = SD_NAMES(value,:);
      file(file == ' ') = []; % get rid of extra blanks in filename
      y=wavread(file);Fs=8000;
      y=y/max(abs(y));t=(0:length(y)-1)/Fs;
   else
      eval(deblank(funcs(value-nfiles,:)));
   end
   
   set(gcf,'UserData',[t(:) y(:)]);
   n = SD_DISP;
   eval([SD_PLOTCMD(n,:)]);
   
   if value <= nfiles
      title([int2str(length(y)) ' Samples']);
   else
      title(deblank(func_titles(value-nfiles,:)));
   end
   drawnow;
   
   set(gcf,'pointer','arrow');
   
   %========================================================================
   % Display callback.
   
elseif strcmp(action,'display')
   hndl=gco;
   popStr=get(hndl,'String');
   value=get(hndl,'Value');
   selectStr=deblank(popStr(value,:));
   
   Fs = 8000;          % Sampling rate is the same for all files!
   SD_DISP = value;
   y = get(gcf,'UserData');
   if ~isempty(y),t = y(:,1); y = y(:,2);
      set(gcf,'pointer','watch');drawnow;
      titl = get(get(gca,'title'),'String');
      eval([SD_PLOTCMD(value,:)]);
      set(gcf,'pointer','arrow');
      title(titl),drawnow,end;
   
   %========================================================================
   % Play callback.
   
elseif strcmp(action,'play')

  set(gcf,'pointer','watch');
  try
    Fs = 8000;          % Sampling rate is the same for all files!
    
    dat = get(gcf,'UserData');
    y = dat(:,2);
    sound(y*get(SD_VOLUME,'value'),Fs);
  catch
  end
  set(gcf,'pointer','arrow');
  
   %========================================================================

elseif strcmp(action,'close'),
   close(gcf);
   clear global SD_VOLUME SD_NAMES SD_DISP SD_PLOTCMD;
   clear global funcs func_titles;
   
end;    % if strcmp(action, ...
