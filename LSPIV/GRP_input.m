close(1)
clear point
% Name of images
disp('  ');
disp('#########################################');
disp(' Select the image for the GRPs identification');
pause(1)
[filename, pathname] = uigetfile('*.*','All Files (*.*)','Select the image for the GRPs identification');

disp(filename)
Name_img=fullfile(pathname,filename);
temp_file=fopen([out_dir,'temp_img.dat'],'w');
fprintf(temp_file,'%s',Name_img);
fclose(temp_file);

Name_size=length(filename);
ext=filename(Name_size-3:Name_size);

if (ext=='.jpg');
    Img_fmt='jpg';
elseif (ext=='.bmp');
    Img_fmt='bmp';
elseif(ext=='.tif');
    Img_fmt='tif';
elseif(ext=='.png');
     Img_fmt='png' ;
elseif(ext=='.gif');
     Img_fmt='gif' ;
else
    Img_fmt = input('Images format:  ', 's');
end;
    
format_path=[out_dir,'Img_format.dat'];
Img_format_file=fopen(format_path,'w');
fprintf(Img_format_file,'%s',Img_fmt);

Img=imread(Name_img,Img_fmt);

GRP_path=[out_dir,'GRP.dat'];
GRP_file=fopen(GRP_path,'w');

figure(1);
imagesc(Img); axis equal; hold on; colormap('gray');
 
% Initially, the list of GRPs is empty.
xy = [];
xpyp=[];
n = 0;
% Loop, picking up the points.

but = 1;
while but == 1;
    % display image on a new window

    n = n+1;
    disp('  ');
    point_str=int2str(n);
    txt_out(n)=point_str;
    point_txt=['** Ground Reference Point ',point_str];
    disp(point_txt);
    figure(2);
    imagesc(Img); axis equal; hold on;colormap('gray');
     disp('  ');
    disp('Zoom on the area of the figure 2 you want to work with');
    bla=input('When the view is adjusted, press Enter', 's');
    disp('Click on the GRPs to assess image coordinates ');
    disp('Click right if you enter the last GRP');
    [xi,yi,but] = my_ginput(1);
    figure(1)
    plot(xi,yi,'ro','MarkerSize',5); axis equal; hold on;
    disp('Figure 1 shows an overview of the localized GRPs');
    display('Input GRP Cartesian coordinates');
    xy(:,n) = [xi;yi];
    xp=input('Xp:  ')  ;
    yp=input('Yp:  ');
    xpyp(:,n) = [xp;yp];
    close(2);
end;
compt=n;
close(1);

figure(2);
subplot(1,2,1);
imagesc(Img); axis equal; hold on;
plot(xy(1,:),xy(2,:),'ro','MarkerSize',5); axis equal;
text(xy(1,:),xy(2,:),txt_out(:),'HorizontalAlignment','left','Color','b','FontSize',18);

subplot(1,2,2);
plot(xpyp(1,:),xpyp(2,:),'ro','MarkerSize',5); axis equal; 
text(xpyp(1,:),xpyp(2,:),txt_out(:),'HorizontalAlignment','left','Color','b','FontSize',18);

fprintf(GRP_file,'GRP\n');
fprintf(GRP_file,'%d\n',compt);
fprintf(GRP_file,'X  Y  i  j \n');
for n=1:compt;
    fprintf(GRP_file,'%g %g %d %d\n',xpyp(1,n),xpyp(2,n),round(xy(1,n)),round(xy(2,n)));
end;

run GRP_check_gui
