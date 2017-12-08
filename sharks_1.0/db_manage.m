function varargout = db_manage(varargin)
% DB_MANAGE M-file for db_manage.fig
%      DB_MANAGE, by itself, creates a new DB_MANAGE or raises the existing
%      singleton*.
%
%      H = DB_MANAGE returns the handle to a new DB_MANAGE or the handle to
%      the existing singleton*.
%
%      DB_MANAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DB_MANAGE.M with the given input arguments.
%
%      DB_MANAGE('Property','Value',...) creates a new DB_MANAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before db_manage_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to db_manage_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help db_manage

% Last Modified by GUIDE v2.5 11-May-2008 21:57:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @db_manage_OpeningFcn, ...
                   'gui_OutputFcn',  @db_manage_OutputFcn, ...
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


% --- Executes just before db_manage is made visible.
function db_manage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to db_manage (see VARARGIN)

% Choose default command line output for db_manage
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes db_manage wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = db_manage_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in list_name.
function list_name_Callback(hObject, eventdata, handles)
% hObject    handle to list_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns list_name contents as cell array
%        contents{get(hObject,'Value')} returns selected item from list_name


% --- Executes during object creation, after setting all properties.
function list_name_CreateFcn(hObject, eventdata, handles)
% hObject    handle to list_name (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --- Executes on button press in bt_load.
function bt_load_Callback(hObject, eventdata, handles)

global mfcc_file
% hObject    handle to bt_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.mat','Select Feature file');
mfcc_file=[pathname filename];
 if mfcc_file== 0
        errordlg('ERROR! No file selected!');
        return;
  end 
load(mfcc_file);
set(handles.list_name,'String',name);


% --- Executes on button press in bt_delete.
function bt_delete_Callback(hObject, eventdata, handles)

global mfcc_file
load(mfcc_file);
% hObject    handle to bt_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
list_entries = get(handles.list_name,'String');
index_selected = get(handles.list_name,'Value');
delete_name = list_entries(index_selected(1),:);
index=index_selected(1);

selection = questdlg(strcat('Delete the Voice with name as :',delete_name),...
      'Close Request Function',...
      'Yes','No','Yes'); 
   switch selection, 
      case 'Yes',
         
          name(index,:)=[];
          fea(index,:)=[];
          no_of_fe=no_of_fe-1;
          save(mfcc_file,'no_of_fe','name','fea');
          if(no_of_fe==0)
              set(handles.list_name,'String',' ');
          else
              set(handles.list_name,'String',name);
          end
          
      case 'No'
      return 
   end


% --------------------------------------------------------------------
function m_loadDB_Callback(hObject, eventdata, handles)
% hObject    handle to m_loadDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 bt_load_Callback(hObject, eventdata, handles);



% --- Executes on button press in bt_copy.
function bt_copy_Callback(hObject, eventdata, handles)
% hObject    handle to bt_copy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 m_copy_Callback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function m_copy_Callback(hObject, eventdata, handles)

global mfcc_file
duplicate =0;
load(mfcc_file);
temp_name=name;
temp_no_of_fe=no_of_fe;
temp_fea=fea;

[filename, pathname] = uigetfile('*.mat','Get data from');
copy_file=[pathname filename];
 if copy_file== 0
        errordlg('ERROR! No file selected!');
        return;
  end 
load(copy_file);

if no_of_fe==0
    return;
end

for i=1:no_of_fe
   
    if any(strcmp(temp_name,name)>0)  % find if the new name already exists in data base
        duplicate=duplicate+1;
    else
        len=length(name(i,:));
        temp_name(temp_no_of_fe+i,1:len)=char(name(i,1:len));
        temp_fea{temp_no_of_fe+i,1}=fea{i,1};
        temp_fea{temp_no_of_fe+i,2}=fea{i,2};
        temp_fea{temp_no_of_fe+i,3}=fea{i,3};
    end
end
temp_no_of_fe=temp_no_of_fe+no_of_fe;
name=temp_name;
fea=temp_fea;
no_of_fe=temp_no_of_fe;
save(mfcc_file,'no_of_fe','name','fea');
set(handles.list_name,'String',name);


% --------------------------------------------------------------------
function m_Exit_Callback(hObject, eventdata, handles)
% hObject    handle to m_Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete(gcf);
