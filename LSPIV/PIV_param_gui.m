function varargout = PIV_param_gui(varargin)

global out_dir;
% PIV_PARAM_GUI M-file for PIV_param_gui.fig
%      PIV_PARAM_GUI, by itself, creates a new PIV_PARAM_GUI or raises the existing
%      singleton*.
%
%      H = PIV_PARAM_GUI returns the handle to a new PIV_PARAM_GUI or the handle to
%      the existing singleton*.
%
%      PIV_PARAM_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PIV_PARAM_GUI.M with the given input arguments.
%
%      PIV_PARAM_GUI('Property','Value',...) creates a new PIV_PARAM_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PIV_param_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PIV_param_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PIV_param_gui

% Last Modified by GUIDE v2.5 22-May-2007 14:55:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PIV_param_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @PIV_param_gui_OutputFcn, ...
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


% --- Executes just before PIV_param_gui is made visible.
function PIV_param_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PIV_param_gui (see VARARGIN)

% Choose default command line output for PIV_param_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PIV_param_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
h = gcf;
set(h,'Toolbar','figure');

handles.edit7=0.6;

% --- Outputs from this function are returned to the command line.
function varargout = PIV_param_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
edit1=str2double(get(hObject,'String'));
% Save the new value
handles.edit1 = edit1;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global out_dir;

Bi=handles.edit1;
Sim=handles.edit2;
Sip=handles.edit3;
Sjm=handles.edit4;
Sjp=handles.edit5;
inter=handles.edit6;
corr_min=handles.edit7;
param_path=[out_dir,'PIV_param.dat'];
PIV_param_file=fopen(param_path,'w');
fprintf(PIV_param_file,'IA size \n');
fprintf(PIV_param_file,'%d\n',Bi);
fprintf(PIV_param_file,'SA size: Sim - Sip - Sjm - Sjp\n');
fprintf(PIV_param_file,'%d\n',Sim);
fprintf(PIV_param_file,'%d\n',Sip);
fprintf(PIV_param_file,'%d\n',Sjm);
fprintf(PIV_param_file,'%d\n',Sjp);
fprintf(PIV_param_file,'Time interval \n');
fprintf(PIV_param_file,'%g\n',inter);
fprintf(PIV_param_file,'Minimum correlation \n');
fprintf(PIV_param_file,'%g\n',corr_min);
cla;
global Img1;

taille=size(Img1);
imagesc('CData',Img1);axis ij; axis equal; colormap(gray);xlabel('j');ylabel('i');hold on;
plot(taille(2)/2,taille(1)/2,'rx');hold on;
IA_shape=zeros(2,5);
IA_shape(1,1)=taille(2)/2+Bi/2;
IA_shape(2,1)=taille(1)/2+Bi/2;
IA_shape(1,2)=taille(2)/2+Bi/2;
IA_shape(2,2)=taille(1)/2-Bi/2;
IA_shape(1,3)=taille(2)/2-Bi/2;
IA_shape(2,3)=taille(1)/2-Bi/2;
IA_shape(1,4)=taille(2)/2-Bi/2;
IA_shape(2,4)=taille(1)/2+Bi/2;
IA_shape(1,5)=IA_shape(1,1);
IA_shape(2,5)=IA_shape(2,1);
plot(IA_shape(1,:),IA_shape(2,:),'r-');hold on;

SA_shape=zeros(2,5);
SA_shape(1,1)=taille(2)/2+Sjp;
SA_shape(2,1)=taille(1)/2+Sip;
SA_shape(1,2)=taille(2)/2+Sjp;
SA_shape(2,2)=taille(1)/2-Sim;
SA_shape(1,3)=taille(2)/2-Sjm;
SA_shape(2,3)=taille(1)/2-Sim;
SA_shape(1,4)=taille(2)/2-Sjm;
SA_shape(2,4)=taille(1)/2+Sip;
SA_shape(1,5)=SA_shape(1,1);
SA_shape(2,5)=SA_shape(2,1);
plot(SA_shape(1,:),SA_shape(2,:),'b-');axis ij; axis equal;hold on;

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


function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
edit4=str2double(get(hObject,'String'));
% Save the new value
handles.edit4 = edit4;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
edit5=str2double(get(hObject,'String'));
% Save the new value
handles.edit5 = edit5;
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1





% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dos('notepad help_PIV.txt');



% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close('all')
display('End of step 1 - PIV parameterization');
disp('Continue with step 2 - Computational grid');
run main_PIV;




function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
edit6=str2double(get(hObject,'String'));
% Save the new value
handles.edit6 = edit6;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Img1;
global Img2;
figure(1)
subplot(1,2,1);
imagesc('CData',Img1);axis ij; axis equal; xlabel('j');ylabel('i');colormap(gray); 
subplot(1,2,2);
imagesc('CData',Img2);axis ij; axis equal;  xlabel('j');ylabel('i');colormap(gray);





function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double
edit7=str2double(get(hObject,'String'));
% Save the new value
handles.edit7 = edit7;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


