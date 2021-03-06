function varargout = display_gui(varargin)
% DISPLAY_GUI M-file for display_gui.fig
%      DISPLAY_GUI, by itself, creates a new DISPLAY_GUI or raises the existing
%      singleton*.
%
%      H = DISPLAY_GUI returns the handle to a new DISPLAY_GUI or the handle to
%      the existing singleton*.
%
%      DISPLAY_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DISPLAY_GUI.M with the given input arguments.
%
%      DISPLAY_GUI('Property','Value',...) creates a new DISPLAY_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before display_gui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to display_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help display_gui

% Last Modified by GUIDE v2.5 23-May-2008 12:32:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @display_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @display_gui_OutputFcn, ...
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


% --- Executes just before display_gui is made visible.
function display_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to display_gui (see VARARGIN)

% Choose default command line output for display_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes display_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);
h = gcf;
set(h,'Toolbar','figure');
cla;


% --- Outputs from this function are returned to the command line.
function varargout = display_gui_OutputFcn(hObject, eventdata, handles) 
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
global out_dir
global transf_dir

cla;
avg_vel_id=fopen([out_dir,'average_vel.dat'],'r');
avg_vel=fscanf(avg_vel_id,'%g %g %g %g %g %g',[6 inf]);

fclose(avg_vel_id);

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

imagesc('CData',arc1,'XData',[x1 x1+m*pix],'YData',[y1 y1+n*pix]); hold on;
colormap(gray);
H = gca; 
hh=quiver(avg_vel(2,:),avg_vel(1,:),avg_vel(3,:),avg_vel(4,:),'Color','b','LineWidth',1); title('Average surface velocities'); axis equal;hold off;xlabel('X');ylabel('Y');
posx=x1-(m*pix)/10;
posy=y1-(n*pix)/10;
posy2=posy+abs((n*pix)/10);
addrefarrow(hh,posx,posy,max(sqrt(avg_vel(3,:).*avg_vel(3,:)+avg_vel(4,:).*avg_vel(4,:))),0);
tt=num2str(max(sqrt(avg_vel(3,:).*avg_vel(3,:)+avg_vel(4,:).*avg_vel(4,:))));
text(posx,posy2,tt,'Color','b');

hold(H);
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global out_dir
H = gca; 
hold(H);
cla;
avg_vel_id=fopen([out_dir,'average_vel.dat'],'r');
avg_vel=fscanf(avg_vel_id,'%g %g %g %g %g %g',[6 inf]);
fclose(avg_vel_id);
taille=size(avg_vel);

avg_v=sqrt(avg_vel(3,:).*avg_vel(3,:)+avg_vel(4,:).*avg_vel(4,:));
for i=1: taille(2)
    if (avg_vel(3,i)==0 && avg_vel(4,i)==0)
        avg_v(i)=NaN;
    end
end

good = ~isnan(avg_v);
step1=max(max(max(avg_vel(2,:)))-min(avg_vel(2,:)),max(max(avg_vel(1,:)))-min(min(avg_vel(1,:))))/100;
[xi,yi]=meshgrid(min(min(avg_vel(2,:))):step1:max(max(avg_vel(2,:))),min(min(avg_vel(1,:))):step1:max(max(avg_vel(1,:))));
[XI,YI,ZI]= griddata(avg_vel(2,good),avg_vel(1,good),avg_v(good),xi,yi,'linear'); 
contourf(XI,YI,ZI);title('Average velocity field'); axis equal; colormap('default');xlabel('X');ylabel('Y');colorbar;


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global out_dir
global transf_dir
H = gca; 
hold(H);
cla;
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

imagesc('CData',arc1,'XData',[x1 x1+m*pix],'YData',[y1 y1+n*pix]); hold on;
colormap(gray);


avg_vel_id=fopen([out_dir,'average_vel.dat'],'r');
avg_vel=fscanf(avg_vel_id,'%g %g %g %g %g %g',[6 inf]);
fclose(avg_vel_id);
taille=size(avg_vel);

avg_v=sqrt(avg_vel(3,:).*avg_vel(3,:)+avg_vel(4,:).*avg_vel(4,:));
for i=1: taille(2)
    if (avg_vel(3,i)==0 && avg_vel(4,i)==0)
        avg_v(i)=NaN;
    end
end

good = ~isnan(avg_v);


step1=max(max(max(avg_vel(2,:)))-min(avg_vel(2,:)),max(max(avg_vel(1,:)))-min(min(avg_vel(1,:))))/100;
step2=max(max(max(avg_vel(2,:)))-min(min(avg_vel(2,:))))/10;
step3=max(max(max(avg_vel(1,:)))-min(min(avg_vel(1,:))))/10;
[xi,yi]=meshgrid(min(min(avg_vel(2,:))):step1:max(max(avg_vel(2,:))),min(min(avg_vel(1,:))):step1:max(max(avg_vel(1,:))));
[XI,YI,UI]= griddata(avg_vel(2,good),avg_vel(1,good),avg_vel(3,good),xi,yi,'linear'); 
[XI,YI,VI]= griddata(avg_vel(2,good),avg_vel(1,good),avg_vel(4,good),xi,yi,'linear');  
[sx,sy] = meshgrid(min(min(avg_vel(2,:))):step2:max(max(avg_vel(2,:))),min(min(avg_vel(1,:))):step3:max(max(avg_vel(1,:))));
streamline(stream2(XI,YI,UI,VI,sx,sy));  axis equal; xlabel('X');ylabel('Y'); title('Stream lines');

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global out_dir
H = gca; 
hold(H);
cla;
avg_vel_id=fopen([out_dir,'average_vel.dat'],'r');
avg_vel=fscanf(avg_vel_id,'%g %g %g %g %g %g',[6 inf]);
fclose(avg_vel_id);
taille=size(avg_vel);

avg_v=sqrt(avg_vel(3,:).*avg_vel(3,:)+avg_vel(4,:).*avg_vel(4,:));
for i=1: taille(2)
    if (avg_vel(3,i)==0 && avg_vel(4,i)==0)
        avg_v(i)=NaN;
    end
end

good = ~isnan(avg_v);

step1=max(max(max(avg_vel(2,:)))-min(avg_vel(2,:)),max(max(avg_vel(1,:)))-min(min(avg_vel(1,:))))/100;
[xi,yi]=meshgrid(min(min(avg_vel(2,:))):step1:max(max(avg_vel(2,:))),min(min(avg_vel(1,:))):step1:max(max(avg_vel(1,:))));
[XI,YI,UI]= griddata(avg_vel(2,good),avg_vel(1,good),avg_vel(3,good),xi,yi,'linear'); 
[XI,YI,VI]= griddata(avg_vel(2,good),avg_vel(1,good),avg_vel(4,good),xi,yi,'linear');  
taille=size(XI);
vorti=zeros(taille(1),taille(2));
for i=2:taille(1)-1
    for j=2:taille(2)-1
        vorti(i,j)=((VI(i,j+1)-VI(i,j-1))/(XI(i,j+1)-XI(i,j-1)))-((UI(i+1,j)-UI(i-1,j))/(YI(i+1,j)-YI(i-1,j)));
    end
end

contourf(XI,YI,vorti);title('Average vorticity field'); axis equal; colormap('default');xlabel('X');ylabel('Y');colorbar;      

vorti_name=[out_dir,'vorticity.out'];
vorti_file=fopen(vorti_name,'w');
for i=1:taille(1)
    for j=1:taille(2)
    fprintf(vorti_file,'%g %g %g\n',XI(i,j),YI(i,j),vorti(i,j));   
    end
end
fclose(vorti_file);

% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)

% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ext={'*.bmp';'*.jpg'};

[filename, pathname,fileindex] = uiputfile(ext,'Save as');
 
f=fullfile(pathname,filename);
axe=getframe(gcf);
imwrite(axe.cdata,f,ext{fileindex}(3:end));

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
figure(2);
image(help_disp.bmp);


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fclose('all');
close('all');
run main_post



% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global out_dir
global transf_dir
cla;
avg_vel_id=fopen([out_dir,'average_vel.dat'],'r');
avg_vel=fscanf(avg_vel_id,'%g %g %g %g %g %g',[6 inf]);

fclose(avg_vel_id);

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

imagesc('CData',arc1,'XData',[x1 x1+m*pix],'YData',[y1 y1+n*pix]); hold on;
colormap(gray);
%H = gca; 
quiver(avg_vel(2,:),avg_vel(1,:),avg_vel(3,:),avg_vel(4,:),'Color','b','LineWidth',1); title('Average surface velocities'); axis equal;hold on;xlabel('X');ylabel('Y');


for i=1:2;
    [xi,yi] = ginput(1);
    xp(i)=xi;
    yp(i)=yi; 
    p(i)=plot(xi,yi,'ro','MarkerSize',5); axis equal; hold on;
end;
delete(p(:));
p(1)=plot(xp(:),yp(:),'r-'); axis equal; hold on;
set(p(1),'DisplayName','Cross-section vel')

step_x=abs(xp(2)-xp(1))/20;
step_y=abs(yp(2)-yp(1))/20;

if (yp(1)<yp(2))&&(xp(1)<xp(2))
    for i=1:21; 
        crosss(1,i)=min(xp(:))+(i-1)*step_x;
        crosss(2,i)=min(yp(:))+(i-1)*step_y;
    end;
elseif (yp(1)>yp(2))&&(xp(1)<xp(2))
    for i=1:21; 
        crosss(1,i)=min(xp(:))+(i-1)*step_x;
        crosss(2,i)=max(yp(:))-(i-1)*step_y;
    end;
elseif (yp(1)>yp(2))&&(xp(1)>xp(2))   
    for i=1:21; 
        crosss(1,i)=min(xp(:))+(i-1)*step_x;
        crosss(2,i)=min(yp(:))+(i-1)*step_y;
    end;
elseif (yp(1)<yp(2))&&(xp(1)>xp(2))  
    for i=1:21; 
        crosss(1,i)=min(xp(:))+(i-1)*step_x;
        crosss(2,i)=max(yp(:))-(i-1)*step_y;
    end;    
end

p(2)=plot(crosss(1,:),crosss(2,:),'rx'); axis equal; hold on;
set(p(2),'DisplayName','Cross-section vel')
Fichier1=[out_dir,'average_vel.dat'];
Fich_id1=fopen(Fichier1,'r');
vel=fscanf(Fich_id1,'%g %g %g %g %g %g',[6,inf]);
fclose(Fich_id1);
taille_vel=size(vel);
u=zeros(1,21);
v=zeros(1,21);
for i=1:21
    d2=zeros(taille_vel(1),taille_vel(2));
    d2(:,:)=crosss(1,i);
    d3=zeros(taille_vel(1),taille_vel(2));
    d3(:,:)=crosss(2,i);
    d=sqrt((vel(1,:)-d3(1,:)).*(vel(1,:)-d3(1,:))+(vel(2,:)-d2(1,:)).*(vel(2,:)-d2(1,:)));
    [B,IX] = sort(d);
  %  if (B(1)<step_x) 
        if (vel(3,IX(1))~=0 && vel(3,IX(2))~=0 && vel(4,IX(1))~=0 && vel(4,IX(2))~=0)
            u(i)=(vel(3,IX(1))*2+vel(3,IX(2)))/3;   
            v(i)=(vel(4,IX(1))*2+vel(4,IX(2)))/3 ;  
        elseif ((vel(3,IX(1))==0 && vel(4,IX(1))==0) && (vel(3,IX(2))~=0 || vel(4,IX(2))~=0))
            u(i)=vel(3,IX(2));   
            v(i)=vel(4,IX(2)); 
        elseif ((vel(3,IX(2))==0 && vel(4,IX(2))==0) && (vel(3,IX(1))~=0 || vel(4,IX(1))~=0))  
            u(i)=vel(3,IX(1));   
            v(i)=vel(4,IX(1)); 
     %   else                
            u(i)=0; 
            v(i)=0;
     %   end
    else
        u(i)=0;
        v(i)=0;
    end
end

figure('Name','Cross-section velocities','NumberTitle','off')
plot(crosss(1,:),crosss(2,:),'rx'); axis equal; hold on;
hh=quiver(crosss(1,:),crosss(2,:),u,v,'color','r'); axis equal; hold on;
mean_vel=max(sqrt(u.*u+v.*v));
mean_str=num2str(mean_vel,2);

addrefarrow(hh,min(crosss(1,:))-(max(crosss(1,:))-min(crosss(1,:)))/2,min(crosss(2,:))-(max(crosss(2,:))-min(crosss(2,:)))/5,mean_vel,0);
text(min(crosss(1,:))-(max(crosss(1,:))-min(crosss(1,:)))/2,min(crosss(2,:))-(max(crosss(2,:))-min(crosss(2,:)))/6,mean_str,'color','r');

crosv_name=[out_dir,'cross_vel.out'];
crosv_file=fopen(crosv_name,'w');
for i=1:21
    fprintf(crosv_file,'%g %g %g %g \n',crosss(1,i),crosss(2,i),u(i),v(i));   
end
fclose(crosv_file);


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dos('notepad help_disp.txt');



% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global out_dir
H = gca; 
hold(H);
cla;
avg_vel_id=fopen([out_dir,'average_vel.dat'],'r');
avg_vel=fscanf(avg_vel_id,'%g %g %g %g %g %g',[6 inf]);
fclose(avg_vel_id);
taille=size(avg_vel);

avg_v=sqrt(avg_vel(3,:).*avg_vel(3,:)+avg_vel(4,:).*avg_vel(4,:));
for i=1: taille(2)
    if (avg_vel(3,i)==0 && avg_vel(4,i)==0)
        avg_v(i)=NaN;
    end
end

good = ~isnan(avg_v);
step1=max(max(max(avg_vel(2,:)))-min(avg_vel(2,:)),max(max(avg_vel(1,:)))-min(min(avg_vel(1,:))))/100;
[xi,yi]=meshgrid(min(min(avg_vel(2,:))):step1:max(max(avg_vel(2,:))),min(min(avg_vel(1,:))):step1:max(max(avg_vel(1,:))));
[XI,YI,ZI]= griddata(avg_vel(2,good),avg_vel(1,good),avg_v(good),xi,yi,'linear'); 
contourf(XI,YI,ZI);title('Average velocity field'); axis equal; colormap('default');xlabel('X');ylabel('Y');colorbar;hold on;

hh=quiver(avg_vel(2,:),avg_vel(1,:),avg_vel(3,:),avg_vel(4,:),'Color','k','LineWidth',1); title('Average surface velocities'); axis equal;hold off;xlabel('X');ylabel('Y');
posx=x1-(m*pix)/10;
posy=y1-(n*pix)/10;
posy2=posy+abs((n*pix)/10);
addrefarrow(hh,posx,posy,max(sqrt(avg_vel(3,:).*avg_vel(3,:)+avg_vel(4,:).*avg_vel(4,:))),0);
tt=num2str(max(sqrt(avg_vel(3,:).*avg_vel(3,:)+avg_vel(4,:).*avg_vel(4,:))));
text(posx,posy2,tt,'Color','b');

hold(H);

