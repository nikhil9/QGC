function varargout = Q_gui(varargin)
% Q_GUI M-file for Q_gui.fig
%      Q_GUI, by itself, creates a new Q_GUI or raises the existing
%      singleton*.
%
%      H = Q_GUI returns the handle to a new Q_GUI or the handle to
%      the existing singleton*.
%
%      Q_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in Q_GUI.M with the given input arguments.
%
%      Q_GUI('Property','Value',...) creates a new Q_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Q_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Q_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Q_gui

% Last Modified by GUIDE v2.5 22-Oct-2007 13:49:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Q_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @Q_gui_OutputFcn, ...
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


% --- Executes just before Q_gui is made visible.
function Q_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Q_gui (see VARARGIN)

% Choose default command line output for Q_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Q_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
h = gcf;
set(h,'Toolbar','figure');
cla;

% --- Outputs from this function are returned to the command line.
function varargout = Q_gui_OutputFcn(hObject, eventdata, handles) 
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
global Name_bath
[FileName,PathName] = uigetfile({'*.dat','Data Files (*.dat)';'*.txt','Text Files (*.txt)';'*.out','Out Files (*.out)';
   '*.*',  'All Files (*.*)'},'Select the bathymetry file');
Name_bath=[PathName,FileName];


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
edit1=str2double(get(hObject,'String'));
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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global out_dir
global Name_bath
global transf_dir

coeff_v=handles.edit1;
ref_path=[out_dir,'img_ref.dat'];
img_ref=fopen(ref_path,'r');
bla=fscanf(img_ref,'%s',1);
min_coord=fscanf(img_ref,'%g %g',[2]);
bla=fscanf(img_ref,'%s',1);
max_coord=fscanf(img_ref,'%g %g',[2]);
bla=fscanf(img_ref,'%s',1);
resol=fscanf(img_ref,'%g',[1]);

moy_path=[out_dir,'average_vel.dat'];
moy_file=fopen(moy_path,'r');
avg_vel=fscanf(moy_file,'%g %g %g %g %g %g',[6 inf]);


bath_id=fopen(Name_bath,'r');
bath=fscanf(bath_id,'%g %g %g',[3 inf]);
fclose(bath_id);
taille_bath=size(bath);
bath2=zeros(2,taille_bath(2)+2);

bath2(1,1)=bath(1,1);
bath2(1,2:taille_bath(2)+1)=bath(1,:);
bath2(1,taille_bath(2)+2)=bath(1,taille_bath(2));
bath2(2,1)=bath(2,1);
bath2(2,2:taille_bath(2)+1)=bath(2,:);
bath2(2,taille_bath(2)+2)=bath(2,taille_bath(2));

dist=zeros(1,taille_bath(2));
dist(1,:)=sqrt((bath2(1,3:taille_bath(2)+2)-bath2(1,1:taille_bath(2))).*(bath2(1,3:taille_bath(2)+2)-bath2(1,1:taille_bath(2)))+(bath2(2,3:taille_bath(2)+2)-bath2(2,1:taille_bath(2))).*(bath2(2,3:taille_bath(2)+2)-bath2(2,1:taille_bath(2))));

vel_id=fopen([out_dir,'average_vel.dat'],'r');
vel=fscanf(vel_id,'%g %g %g %g %g %g',[6 inf]);
fclose(vel_id);
taille_vel=size(vel);



umoy=zeros(1,taille_bath(2));
u=zeros(1,taille_bath(2));
v=zeros(1,taille_bath(2));
for i=1:taille_bath(2)
    d2=zeros(taille_vel(1),taille_vel(2));
    d2(:,:)=bath(1,i);
    d3=zeros(taille_vel(1),taille_vel(2));
    d3(:,:)=bath(2,i);
    d=sqrt((vel(1,:)-d3(1,:)).*(vel(1,:)-d3(1,:))+(vel(2,:)-d2(1,:)).*(vel(2,:)-d2(1,:)));
    [B,IX] = sort(d);
    u(i)=(vel(3,IX(1))*4+vel(3,IX(2))*3+vel(3,IX(2))*2+vel(3,IX(4)))/10;
    v(i)=(vel(4,IX(1))*4+vel(4,IX(2))*3+vel(4,IX(2))*2+vel(4,IX(4)))/10;    
    umoy(i)=sqrt(u(i)*u(i)+v(i)*v(i))*coeff_v;
end
q(1,:)=dist(1,:).*bath(3,:).*umoy(1,:);
Qtot=sum(q(1,:));

Q_path=[out_dir,'discharge.dat'];
Q_ref=fopen(Q_path,'w');
fprintf(Q_ref,'%f',Qtot);
set(handles.edit2,'string',num2str(Qtot));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Info sur l'image rectifiée %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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

% subplot(2,1,1);
% imagesc('CData',arc1,'XData',[x1 x1+m*pix],'YData',[y1 y1+n*pix]); axis equal; hold on;xlabel('X');ylabel('Y');
% colormap(gray);
% quiver(avg_vel(2,:),avg_vel(1,:),avg_vel(3,:),avg_vel(4,:));axis equal; hold on;xlabel('X');ylabel('Y');
% plot(bath(1,:),bath(2,:),'r-');axis equal; hold on;xlabel('X');ylabel('Y');hold off
% subplot(2,1,2);
water=zeros(1,taille_bath(2));
max_depth=max(bath(3,:));
plot3(bath(1,:),bath(2,:),water(:),'b-'); axis equal; hold on;xlabel('X');ylabel('Y');zlabel('Z');
plot3(bath(1,:),bath(2,:),-bath(3,:),'k-'); axis equal; hold on;xlabel('X');ylabel('Y');zlabel('Z');
w=zeros(1,taille_bath(2));
quiver3(bath(1,:),bath(2,:),water(:),u(:),v(:),w(:),'r'); axis equal; hold on; xlabel('X');ylabel('Y');zlabel('Z');
% 




% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dos('notepad help_Q.txt');

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fclose('all');
close('all');
run main_post


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


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


