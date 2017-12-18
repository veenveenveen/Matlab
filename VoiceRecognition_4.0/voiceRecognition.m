function varargout = voiceRecognition(varargin)
% VOICERECOGNITION MATLAB code for voiceRecognition.fig
%      VOICERECOGNITION, by itself, creates a new VOICERECOGNITION or raises the existing
%      singleton*.
%
%      H = VOICERECOGNITION returns the handle to a new VOICERECOGNITION or the handle to
%      the existing singleton*.
%
%      VOICERECOGNITION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VOICERECOGNITION.M with the given input arguments.
%
%      VOICERECOGNITION('Property','Value',...) creates a new VOICERECOGNITION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before voiceRecognition_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to voiceRecognition_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help voiceRecognition

% Last Modified by GUIDE v2.5 08-Dec-2017 15:46:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @voiceRecognition_OpeningFcn, ...
                   'gui_OutputFcn',  @voiceRecognition_OutputFcn, ...
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


% --- Executes just before voiceRecognition is made visible.
function voiceRecognition_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to voiceRecognition (see VARARGIN)

% Choose default command line output for voiceRecognition
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes voiceRecognition wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = voiceRecognition_OutputFcn(hObject, eventdata, handles) 
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
global str;
global s1;
global fs1;
[filename,pathname] =uigetfile('*.wav','选择语音文件');
if isequal(filename,0) || isequal(pathname,0)
    return;
end
str=[pathname filename];
[s1, fs1] = audioread(str);%读取
axes(handles.axes1);
plot(s1)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%频谱分析
global fs1;
global s1;
Nfft=length(s1);%采样的长度
T=1/fs1;%采样周期
fs=1/T;%根据DFT的理论最大的 采样频率 为1/T
f=fs*linspace(0,1,Nfft/2+1);%频率抽样
ff1=2*abs(fft(s1,Nfft))/Nfft;%傅里叶变换获得频谱
%画X1的频谱
axes(handles.axes2);
plot(f,ff1(1:(Nfft/2+1)));
title('X1幅频特性');
xlabel('frequency');
ylabel('幅度值');



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s1;
[x1,x2,FrameInc,amp,zcr] = vad(s1);
axes(handles.axes3);
plot(s1) 
axis([1 length(s1) -0.1 0.1]) 
ylabel('端点检测'); 
line([x1*FrameInc x1*FrameInc],[-0.1 0.1] , 'Color', 'red'); 
line([x2*FrameInc x2*FrameInc],[-0.1 0.1] ,'Color', 'red'); 

%{

figure
plot(amp); 
axis([1 length(amp) 0 max(amp)]) 
ylabel('短时能量'); 
line([x1 x1], [min(amp),max(amp)], 'Color', 'red'); 
line([x2 x2], [min(amp),max(amp)], 'Color', 'red'); 
 
figure
plot(zcr); 
axis([1 length(zcr) 0 max(zcr)]) 
ylabel('过零率'); 
line([x1 x1], [min(zcr),max(zcr)], 'Color', 'red'); 
line([x2 x2], [min(zcr),max(zcr)], 'Color', 'red');
 
%}

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s1;
global fs1;
global a;
k=11;
v = mfcc(s1, fs1);%提取特征参数
a= vqlbg(v, k); %量化
a=a(:);
save VoiceRecognition_4.0/a.mat a
axes(handles.axes4);
plot(a,'r')

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global a;
pause(1);
global settings
load neting.mat;
if exist('settings')==0;
    str1=['没有载入分类器模型'];
    msgbox(str1);
end
pause(1);
b=mapminmax('apply',a,settings);%归一
YY=sim(net,b);

[maxi,ypred]=max(YY);
leibie=ypred  %显示类别标签

strss = {'我','要','一箱','多糖','少糖','正常','核桃','花生','牛奶'}
str1=['识别结果: ',strss{leibie}]
msgbox(str1)

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcf)
