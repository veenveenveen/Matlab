function varargout = gui(varargin)
global signal RECT s_plot  
global recording_duration % the value shown in the text box
global mfcc_file
% GUI M-file for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 17-Feb-2008 17:32:35


% signal speach signal 
% Rect is the coordenates used for getting the waveform

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% End initialization code - DO NOT EDIT



% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)
global recording_duration
global mfcc_file
recording_duration=1;

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% this code sets the max time for recording











% --- Executes on button press in bt_record.
function bt_record_Callback(hObject, eventdata, handles)
global mfcc_file
global signal

R_samp_len = str2num(get(handles.tx_sec,'string'));
if isempty(R_samp_len)
    warndlg('Select proper Recording Time','Error');
else
 set(handles.tx_msg,'ForegroundColor',[1 0 0],'string','Recording..');
 
	
	data=wavrecord(8000*R_samp_len,8000);% recording the sound
set(handles.tx_msg,'ForegroundColor',[0 0 0],'String','Recording finished');   
signal = 0.99*data/max(abs(data));
 plot_sig;

 load('config.mat');
 load(mfcc_file)
 if (no_of_fe>2)
  result=MFCC_feature_compare(signal,mfcc_file);
  [per index]=max(result);
  msgbox( strcat( 'QUICK FIND : The Person Can be ..', name(index,:),' !!! But confirm it in the Sharks' ) );
 end
% now code to plot
end

































% hObject    handle to bt_record (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in bt_play_select.
function bt_play_select_Callback(hObject, eventdata, handles)

global signal
% hObject    handle to bt_del_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
      

   % Allow the user to draw a rectangle on the area
   % they would like to zoom in on
   RECT = getrect;
   
   xmin = RECT(1);
   xmax = RECT(1) + RECT(3);
   ymin = RECT(2);
   ymax = RECT(2) + RECT(4);
   
   % Set maximum zoom limits to the data edges
   xaxis_limits = get(handles.s_plot,'XLim');
   yaxis_limits = get(handles.s_plot,'YLim');
    yaxis_limits(2);
    xaxis_limits(2);
   
   if xmin < xaxis_limits(1)
      xmin = xaxis_limits(1);
   end
   
   if xmax > xaxis_limits(2)
      xmax = xaxis_limits(2);
      
   end

   if ymin < yaxis_limits(1)
      ymin = yaxis_limits(1);
   end
   
   if ymax > yaxis_limits(2)
      ymax = yaxis_limits(2);
       yaxis_limits(2);
   end
   
   % if the choosen zoom range is acceptable...
   if ~((ymin > ymax) | (xmin > xmax))
     
     
      % zoom in on the frequency data by adjusting the xaxis
      % limits to be the same as those of the time data
      % define the zoomed in data (for playback purposes)
      imin = round(xmin*8000)+1;
      imax = round(xmax*8000)+1;
  end
    if length(signal(imin:imax) )~= 0
      wavplay(signal(imin:imax),8000);
    end
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
% deleting a part of the file--- Executes on button press in bt_del_select.
function bt_del_select_Callback(hObject, eventdata, handles)

global signal
% hObject    handle to bt_del_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
      

   % Allow the user to draw a rectangle on the area
   % they would like to zoom in on
   RECT = getrect;
   
   xmin = RECT(1);
   xmax = RECT(1) + RECT(3);
   ymin = RECT(2);
   ymax = RECT(2) + RECT(4);
   
   % Set maximum zoom limits to the data edges
   xaxis_limits = get(handles.s_plot,'XLim');
   yaxis_limits = get(handles.s_plot,'YLim');
    yaxis_limits(2);
    xaxis_limits(2);
   
   if xmin < xaxis_limits(1)
      xmin = xaxis_limits(1);
   end
   
   if xmax > xaxis_limits(2)
      xmax = xaxis_limits(2);
      
   end

   if ymin < yaxis_limits(1)
      ymin = yaxis_limits(1);
   end
   
   if ymax > yaxis_limits(2)
      ymax = yaxis_limits(2);
       yaxis_limits(2);
   end
   
   % if the choosen zoom range is acceptable...
   if ~((ymin > ymax) | (xmin > xmax))|(size(signal)<10)
     
     
      % zoom in on the frequency data by adjusting the xaxis
      % limits to be the same as those of the time data
      % define the zoomed in data (for playback purposes)
      imin = round(xmin*8000)+1;
      imax = round(xmax*8000)+1;
      button = questdlg('DO YOU WANT TO DELETE','Delete');
      switch button
          case {'Yes'}
           
            signal(imin:imax)=[];
            samp_len = length(signal)/8000;
            delta_t = 1/8000;
            t = 0:delta_t:(samp_len-delta_t);

            % display the signal
            plot(t,signal), xlabel('Time [sec]'), ylabel('Amplitude')
            axis([0 t(length(signal)-1) -1 1 ]);

            
      end    
 end
      
      
      
      
      
      
      
      
      
      
      
      
      


% --- Executes on button press in bt_save.
function bt_save_Callback(hObject, eventdata, handles)
global signal
% hObject    handle to bt_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename, pathname] = uiputfile('*.wav', 'Save Data to Wave File');
	if filename ~= 0
		wavwrite(signal,8000,[pathname filename])
	end
   






% --- Executes during object creation, after setting all properties.
function tb_save_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tb_save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end






% --- Executes during object creation, after setting all properties.
function tb_load_file_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tb_load_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function tb_load_file_Callback(hObject, eventdata, handles)
% hObject    handle to tb_load_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tb_load_file as text
%        str2double(get(hObject,'String')) returns contents of tb_load_file as a double


% --- Executes on button press in bt_launch_load.
function bt_launch_load_Callback(hObject, eventdata, handles)
global signal
% hObject    handle to bt_launch_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.wav','select a wave file to load');
  if filename== 0
        errordlg('ERROR! No file selected!');
        return;
    end 

set(handles.tx_load_file,'String',[pathname filename]);    
% check file is selected
    
 signal = wavread([pathname filename]);
 signal = 0.99*signal/max(abs(signal));
  
	% displays the time graph of the voice signal
  % s_plot = timedata(gui,signal,R_fs,0.06,0.50,0.88,0.30);
plot_sig;



   
   
   
   
   
   
   
   
   
   
   
   
   


% --------------------------------------------------------------------
function mn_load_Callback(hObject, eventdata, handles)
% hObject    handle to mn_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.



% --- playing entire file
function bt_play_Callback(hObject, eventdata, handles)

global signal
% hObject    handle to bt_play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if length(signal) ~= 0
      wavplay(signal,8000)
	end

    
    
    
    
function plot_sig()
global signal
            samp_len = length(signal)/8000;
            delta_t = 1/8000;
            t = 0:delta_t:(samp_len-delta_t);

            % display the signal
            plot(t,signal), xlabel('Time [sec]'), ylabel('Amplitude')
            axis([0 t(length(signal)-1) -1 1 ]);

            


% --- Executes on button press in bt_increase.
function bt_increase_Callback(hObject, eventdata, handles)
global recording_duration;
recording_duration=recording_duration+1;
% hObject    handle to bt_increase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.tx_sec,'String',num2str(recording_duration));


% --- Executes on button press in bt_decrease.
function bt_decrease_Callback(hObject, eventdata, handles)
global recording_duration;
if recording_duration>1
recording_duration=recording_duration-1;
end
% hObject    handle to bt_decrease (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.tx_sec,'String',num2str(recording_duration));





% --- Executes on button press in bt_double_decrese.
function bt_double_decrese_Callback(hObject, eventdata, handles)
% hObject    handle to bt_double_decrese (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global recording_duration;
if recording_duration>10
recording_duration=recording_duration-10;
end
set(handles.tx_sec,'String',num2str(recording_duration));




% --- Executes on button press in bt_double_increase.
function bt_double_increase_Callback(hObject, eventdata, handles)
% hObject    handle to bt_double_increase (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global recording_duration;

recording_duration=recording_duration+10;

set(handles.tx_sec,'String',num2str(recording_duration));


% --- Executes on button press in bt_close.
function bt_close_Callback(hObject, eventdata, handles)
% hObject    handle to bt_close (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function tx_sec_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tx_sec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function tx_sec_Callback(hObject, eventdata, handles)
% hObject    handle to tx_sec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tx_sec as text
%        str2double(get(hObject,'String')) returns contents of tx_sec as a double


