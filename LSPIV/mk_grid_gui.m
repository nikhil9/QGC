function varargout = mk_grid_gui(varargin)

global out_dir;
% MK_GRID_GUI M-file for mk_grid_gui.fig
%      MK_GRID_GUI, by itself, creates a new MK_GRID_GUI or raises the existing
%      singleton*.
%
%      H = MK_GRID_GUI returns the handle to a new MK_GRID_GUI or the handle to
%      the existing singleton*.
%
%      MK_GRID_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MK_GRID_GUI.M with the given input arguments.
%
%      MK_GRID_GUI('Property','Value',...) creates a new MK_GRID_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mk_grid_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mk_grid_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mk_grid_gui

% Last Modified by GUIDE v2.5 16-May-2007 11:36:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mk_grid_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @mk_grid_gui_OutputFcn, ...
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


% --- Executes just before mk_grid_gui is made visible.
function mk_grid_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mk_grid_gui (see VARARGIN)

% Choose default command line output for mk_grid_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mk_grid_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
h = gcf;
set(h,'Toolbar','figure');

global out_dir;

list_path=[out_dir,'images_list.dat'];
[list] = textread(list_path,'%s');
name_lgt1=length(list{1});
list1=list{1}(1:(name_lgt1-4));
global transf_dir;
prefix=transf_dir;
sufix='_transf.pgm';
Name_img_a=strcat(prefix,list1, sufix);
global Img_data
Img_data=imread(Name_img_a,'pgm');
imagesc('CData',Img_data);axis ij; axis equal; colormap(gray);hold on;

% --- Outputs from this function are returned to the command line.
function varargout = mk_grid_gui_OutputFcn(hObject, eventdata, handles) 
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
global Img_data
imagesc('CData',Img_data);axis ij; axis equal; colormap(gray);hold on;
Nb1=handles.edit2;
Nb2=handles.edit3;
run mk_grid

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
edit2=str2double(get(hObject,'String'));
% Save the new value
handles.edit2 = edit2;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
edit3=str2double(get(hObject,'String'));
% Save the new value
handles.edit3 = edit3;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dos('notepad help_grid.txt');



% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
status = fclose('all');
close('all');
disp('  ')
display('End of step 2 - Computational grid ');
disp('Continue with step 3 - PIV analysis of all the images');
clear PIV_param;
run main_PIV;



% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global xp
global yp
xp = [];
yp=[];
n = 0;
for i=1:4;
    [xi,yi] = ginput(1);
    xp(i)=xi;
    yp(i)=yi ;   
    plot(xi,yi,'ro','MarkerSize',5); axis equal; hold on;
    text(xi,yi,int2str(i),'HorizontalAlignment','left','Color','b','FontSize',10);hold on;
end;
compt=n;
a1=[];
b1=[];
a2=[];
b2=[];

