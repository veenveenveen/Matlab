function varargout = VRGUI(varargin)
% VRGUI MATLAB code for VRGUI.fig
%      VRGUI, by itself, creates a new VRGUI or raises the existing
%      singleton*.
%
%      H = VRGUI returns the handle to a new VRGUI or the handle to
%      the existing singleton*.
%
%      VRGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VRGUI.M with the given input arguments.
%
%      VRGUI('Property','Value',...) creates a new VRGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VRGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VRGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VRGUI

% Last Modified by GUIDE v2.5 24-Nov-2017 11:00:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VRGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @VRGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before VRGUI is made visible.
function VRGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to VRGUI (see VARARGIN)

% Choose default command line output for VRGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VRGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VRGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global voice

%lpc计算
pc = lpc1(voice);
axes(handles.axes4);
plot(pc);

%lpcc计算

lcc = lpc2lpcc(pc);
axes(handles.axes5);
plot(lcc);

%mfcc计算
mcc = mfcc(voice,16000);
axes(handles.axes6);
plot(mcc);



% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in openfile.
function openfile_Callback(hObject, eventdata, handles)
% hObject    handle to openfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,pathname] =uigetfile('*.wav','Select the wav-file');
if isequal(filename,0)||isequal(pathname,0)
    return;
end

%set(handles.text3,'String',strcat('文件名:',{32},filename));
set(handles.listbox1,'String',strcat('文件名:',{32},filename));

%str{length(handles.listbox1)+1}=strcat('文件路径:',{32},pathname);
%set(handles.listbox1,'String', str);

%set(handles.listbox1,'String',strcat('文件路径:',{32},pathname));


%原始信号 voice
fpath=[pathname filename];
global voice
voice=audioread(fpath);
axes(handles.axes1);
plot(voice);

%对信号进行预加重 voice_x
voice_x=filter([1,-0.9375],1,voice);
axes(handles.axes7);
plot(voice_x);

% 幅度归一化到[－1，1]
x=double(voice);
x=x/max(abs(x));
% 常数设置
FrameLen=240;       % 帧长取30ms,8kHz的采样率
FrameInc=80;        % 帧移取10ms,1/3

amp1=3;            
amp2=2;              
zcr1=10;            
zcr2=5;                
maxsilence=3;        % 3*10ms=30ms
minlen=15;          % 15*10ms=150ms   
status=0;
count=0;
silence=0; 

% 短时过零率(矢量法)
tmp1=enframe(x(1:length(x)-1),FrameLen,FrameInc);
tmp2=enframe(x(2:length(x)),FrameLen,FrameInc);
signs=(tmp1.*tmp2)< 0;
diffs=(tmp1-tmp2)> 0.02;
zcr=sum(signs.*diffs,2);
axes(handles.axes2);
plot(zcr);
ylabel('zcr');

%计算短时能量
amp=sum(abs(enframe(filter([1-0.9375],1,x),FrameLen,FrameInc)),2);
%inz=find(amp>1);
%amm=amp(inz);
%ll=min(amm);
axes(handles.axes3);
plot(amp);
ylabel('amp');

%调整能量门限 
amp1 = min(amp1, max(amp)/4);
amp2 = min(amp2, max(amp)/8);
%amp1=ll+(max(amp)-ll)/8;
%amp2=ll+(max(amp)-ll)/16;
%开始端点检测
x1=0;
x2=0;
for n=1:length(zcr)
    goto = 0;
    switch status 
        case{0,1}                    % 0=静音，1=可能开始
            if amp(n) > amp1         % 确信进入语音段
                x1=max(n-count-1,1);
                status=2;
                silence=0;
                count=count+1;
            elseif amp(n) >amp2 | zcr(n) > zcr2     % 可能处于语音段
                status=1;
                count=count+1;
            else                                    % 静音状态 
                status=0;
                count=0;
            end
        case 2,                                     % 2=语音段
            if amp(n) > amp2 | zcr(n) > zcr2        % 保持在语音段
                count=count+1;
            else
                silence=silence+1;
                if silence < maxsilence    % 静音还不够长，尚未结束
                   count=count+1;
                elseif count < minlen      % 语音长度太短，认为是噪声
                   status=0;
                   silence=0;
                   count=0;
                else                       % 语音结束
                   status=3;
                end
            end
        case 3,                       % 3=语音结束    
            break;
    end
end
count=count-silence;
x2=x1+count-1;                  

axes(handles.axes8);
plot(x)
axis([1 length(x) -1 1]);
%ylabel('Speech');
line([x1*FrameInc x1*FrameInc],[-1,1],'color','red');
line([x2*FrameInc x2*FrameInc],[-1,1],'color','red');



% --- Executes on button press in closefile.
function closefile_Callback(hObject, eventdata, handles)
% hObject    handle to closefile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
