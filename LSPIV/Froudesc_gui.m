function varargout = Froudesc_gui(varargin)
% FROUDESC_GUI M-file for Froudesc_gui.fig
%      FROUDESC_GUI, by itself, creates a new FROUDESC_GUI or raises the existing
%      singleton*.
%
%      H = FROUDESC_GUI returns the handle to a new FROUDESC_GUI or the handle to
%      the existing singleton*.
%
%      FROUDESC_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FROUDESC_GUI.M with the given input arguments.
%
%      FROUDESC_GUI('Property','Value',...) creates a new FROUDESC_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Froudesc_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Froudesc_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Froudesc_gui

% Last Modified by GUIDE v2.5 22-Oct-2007 11:39:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Froudesc_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @Froudesc_gui_OutputFcn, ...
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


% --- Executes just before Froudesc_gui is made visible.
function Froudesc_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Froudesc_gui (see VARARGIN)

% Choose default command line output for Froudesc_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Froudesc_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
h = gcf;
set(h,'Toolbar','figure');
cla;

% --- Outputs from this function are returned to the command line.
function varargout = Froudesc_gui_OutputFcn(hObject, eventdata, handles) 
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
global out_dir;

Fr_sc=handles.edit4;

global transf_dir
cla;
avg_vel_id=fopen([out_dir,'average_vel.dat'],'r');
avg_vel=fscanf(avg_vel_id,'%g %g %g %g %g %g',[6 inf]);
fclose(avg_vel_id);
taille_vel=size(avg_vel);

avg_vel_Fr(1,:)=avg_vel(1,:).*Fr_sc;
avg_vel_Fr(2,:)=avg_vel(2,:).*Fr_sc;
avg_vel_Fr(3,:)=avg_vel(3,:).*sqrt(Fr_sc);
avg_vel_Fr(4,:)=avg_vel(4,:).*sqrt(Fr_sc);

frsc_name=[out_dir,'Froude_scaling.out'];
frsc_file=fopen(frsc_name,'w');
for i=1:taille_vel(2)
    fprintf(frsc_file,'%g %g %g %g\n',avg_vel(1,i),avg_vel(2,i),avg_vel_Fr(3,i),avg_vel_Fr(4,i));   
end
fclose(frsc_file);

ref_path=[out_dir,'img_ref.dat'];
img_ref=fopen(ref_path,'r');
bla=fscanf(img_ref,'%s',1);
min_coord=fscanf(img_ref,'%g %g',[2]);
bla=fscanf(img_ref,'%s',1);
max_coord=fscanf(img_ref,'%g %g',[2]);
bla=fscanf(img_ref,'%s',1);
resol=fscanf(img_ref,'%g',[1]);
fclose(img_ref);

x1=min_coord(1); % coordonnées d'un des coin de l'image
y1=min_coord(2);
pix=resol;%taille du pixel
list_path=[out_dir,'images_list.dat'];
[list] = textread(list_path,'%s');
name_lgt1=length(list{1});
list1=list{1}(1:(name_lgt1-4));
prefix=transf_dir;
sufix='_transf.pgm';
Name_img_a=strcat(prefix,list1, sufix);
arc1 = imread(Name_img_a);
[n m]=size(arc1);

imagesc('CData',arc1,'XData',[x1*Fr_sc (x1+m*pix)*Fr_sc],'YData',[y1*Fr_sc (y1+n*pix)*Fr_sc]); hold on;
colormap(gray);
H = gca; 
hh=quiver(avg_vel_Fr(2,:),avg_vel_Fr(1,:),avg_vel_Fr(3,:),avg_vel_Fr(4,:),'Color','b','LineWidth',1); title('Average surface velocities'); axis equal;hold off;xlabel('X');ylabel('Y');

posx=x1*Fr_sc-(m*pix*Fr_sc)/10;
posy=y1*Fr_sc-(n*pix*Fr_sc)/10;
posy2=posy+abs((n*pix*Fr_sc)/10);
disp(y1)

addrefarrow(hh,posx,posy,max(sqrt(avg_vel_Fr(3,:).*avg_vel_Fr(3,:)+avg_vel_Fr(4,:).*avg_vel_Fr(4,:))),0);
tt=num2str(max(sqrt(avg_vel_Fr(3,:).*avg_vel_Fr(3,:)+avg_vel_Fr(4,:).*avg_vel_Fr(4,:))));
text(posx,posy2,tt,'Color','b');


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




% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dos('notepad help_frsc.txt &');

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fclose('all');
close('all');
run main_post

