function varargout = untitled1(varargin)
% UNTITLED1 M-file for untitled1.fig
%      UNTITLED1, by itself, creates a new UNTITLED1 or raises the existing
%      singleton*.
%
%      H = UNTITLED1 returns the handle to a new UNTITLED1 or the handle to
%      the existing singleton*.
%
%      UNTITLED1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED1.M with the given input arguments.
%
%      UNTITLED1('Property','Value',...) creates a new UNTITLED1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled1

% Last Modified by GUIDE v2.5 27-Oct-2017 21:46:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled1_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled1_OutputFcn, ...
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


% --- Executes just before untitled1 is made visible.
function untitled1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled1 (see VARARGIN)

% Choose default command line output for untitled1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in luyin.
function luyin_Callback(hObject, eventdata, handles)
global b;
Fs=11025;
t=10;
b=audiorecorder(t*Fs,Fs);
handles.b=b;
guidata(hObject,handles);
% hObject    handle to luyin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in bofang.
function bofang_Callback(hObject, eventdata, handles)
global b;
Fs=11025;
audioplayer(b,Fs);
guidata(hObject,handles);
% hObject    handle to bofang (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in baocun.
function baocun_Callback(hObject, eventdata, handles)
global b;
[filename pathname]=uiputfile({'*.wav','wav-files(*.wav)';'*.*','All-files(*.*)'},'另存为');
str=strcat(pathname,filename);
save(str,'b');
wavwrite(b,11025,str);
guidata(hObject,handles);

% hObject    handle to baocun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in vad.
function vad_Callback(hObject, eventdata, handles)
global m1;
global x1;
global x2;
[fname,L]=uigetfile({'*.wav','All MATLAB Files(*.wav)';'*.*','All-files(*.*)'},'');
file=[L,fname];
[S,Fs]=wavread(file);
audioplayer(S,11025);
figure
[x1,x2]=vad(S);
guidata(hObject,handles);
% hObject    handle to vad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in fupinbianhuan.
function fupinbianhuan_Callback(hObject, eventdata, handles)
[fname,L]=uigetfile({'*.wav','All MATLAB Files(*.wav)';'*.*','All-files(*.*)'},'');
file=[L,fname];
Fs=11025;
[b,Fs]=wavread(file);
audioplayer(b,Fs);
n=length(b);
B=fft(b,n);
f=Fs*(0:n/2-1)/n;

figure
subplot(3,1,1);
plot(b);
ylabel('原声音信号幅值'),xlabel('时间/10^-4s');
subplot(3,1,2);
plot(f,abs(B(1:n/2)));
ylabel('幅度/mv'),xlabel('频率/Hz');
title('幅频响应');
subplot(3,1,3);
plot(f,angle(B(1:n/2)));
xlabel('频率/Hz'),ylabel('弧度/rad');
title('相频响应');
guidata(hObject,handles);
% hObject    handle to fupinbianhuan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function fupinbianhuan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fupinbianhuan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in erbeisu.
function erbeisu_Callback(hObject, eventdata, handles)
[fname,L]=uigetfile({'*.wav','All MATLAB Files(*.wav)';'*.*','All-files(*.*)'},'');
file=[L,fname];
Fs=11025;
[b,Fs]=wavread(file);
w=2*Fs;
sound(b,w);
% hObject    handle to erbeisu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in mansu.
function mansu_Callback(hObject, eventdata, handles)
[fname,L]=uigetfile({'*.wav','All MATLAB Files(*.wav)';'*.*','All-files(*.*)'},'');
file=[L,fname];
Fs=11025;
[b,Fs]=wavread(file);
w=0.75*Fs;
sound(b,w);
% hObject    handle to mansu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in daofang.
function daofang_Callback(hObject, eventdata, handles)
[fname,L]=uigetfile({'*.wav','All MATLAB Files(*.wav)';'*.*','All-files(*.*)'},'');
file=[L,fname];
Fs=11025;
[b,Fs]=wavread(file);
b=b(:,1);
B=flipdim(b,1);
audioplayer(B,Fs);

% hObject    handle to daofang (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in hunxiang.
function hunxiang_Callback(hObject, eventdata, handles)
[fname,L]=uigetfile({'*.wav','All MATLAB Files(*.wav)';'*.*','All-files(*.*)'},'');
file=[L,fname];
Fs=11025;
[b,Fs]=wavread(file);
z=[zeros(1000,1);b];
b1=[b;zeros(1000,1)];
B=b1+z;
audioplayer(3*B,Fs);
% hObject    handle to hunxiang (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in biansheng.
function biansheng_Callback(hObject, eventdata, handles)
[fname,L]=uigetfile({'*.wav','All MATLAB Files(*.wav)';'*.*','All-files(*.*)'},'');
file=[L,fname];
Fs=11025;
[b,Fs]=wavread(file);
B=fft(b);
xa=B';
n=7000;
A=[zeros(1,n),xa(1:110250),zeros(1,n)];
ya=A';
y=3*real(ifft(ya));
audioplayer(y,Fs);
% hObject    handle to biansheng (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in hunsheng.
function hunsheng_Callback(hObject, eventdata, handles)
[fname,L]=uigetfile({'*.wav','All MATLAB Files(*.wav)';'*.*','All-files(*.*)'},'');
file=[L,fname];
Fs=11025;
[b1,Fs]=wavread(file);
[fname,L]=uigetfile({'*.wav','All MATLAB Files(*.wav)';'*.*','All-files(*.*)'},'');
file=[L,fname];
Fs=11025;
[b2,Fs]=wavread(file);
y=b1+b2;
audioplayer(y,Fs);
% hObject    handle to hunsheng (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in huisheng.
function huisheng_Callback(hObject, eventdata, handles)
[fname,L]=uigetfile({'*.wav','All MATLAB Files(*.wav)';'*.*','All-files(*.*)'},'');
file=[L,fname];
Fs=11025;
[b,Fs]=wavread(file);
z=[zeros(10000,1);b];
b1=[b;zeros(10000,1)];
B=b1+z;
audioplayer(B,Fs);


% hObject    handle to huisheng (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in shibie.
function shibie_Callback(hObject, eventdata, handles)
global m1;
global m2;
global x1;
global x2;
fs=11025;
disp('正在计算参考模板的参数...')
for i=1:3
     fname=sprintf('..\\录音\\%da.wav',i-1);
    x=fname;
   [x,fs]=wavread(x);
    [x1 x2] =vad(x);
    m = mfcc(x);
    m = m(x1:x2);
    ref(i).mfcc = m;
end
 
disp('正在计算测试模板的参数...')
for i=1:3
    fname=sprintf('..\\录音\\%db.wav',i-1);
     x=fname;
   [x,fs]=wavread(x);   
    [x1 x2] =vad(x);
    m = mfcc(x);
    m =m(x1:x2);
    test(i).mfcc =m;
end
 
disp('正在进行模板匹配...')
dist=zeros(10,10);
for i=1:3
    for j=1:3
        dist(i,j)=dtw(test(i).mfcc,ref(j).mfcc);
    end
end
 
disp('正在计算匹配结果...')
for i=1:3
    [d,j]=min(dist(i,:));
    fprintf('测试模板%d的识别结果为：%d\n',i,j);
end
% hObject    handle to shibie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
global b;
Fs=11025;
t=0.5;
b=audiorecorder(t*Fs,Fs);
handles.b=b;
guidata(hObject,handles);
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
