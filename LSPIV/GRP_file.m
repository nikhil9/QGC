clear point
% Name of images
disp('  ');
disp('#########################################');
disp(' Select the image for the GRPs identification');

[FileName,PathName] = uigetfile({'*.jpg;*.bmp;*.tif;*.png;*.gif','Image Files (*.jpg,*.bmp,*.tif,*.png,*.gif)';
   '*.*',  'All Files (*.*)'},'Select the image for the GRPs identification');
Name_img=[PathName,FileName];
temp_file=fopen([out_dir,'temp_img.dat'],'w');
fprintf(temp_file,'%s',Name_img);
fclose(temp_file);

Name_size=length(FileName);
ext=FileName(Name_size-3:Name_size);

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

disp('  ');
disp('#########################################');
disp(' Select the GRPs file');

[FileName,PathName] = uigetfile({'*.dat','Data Files (*.dat)';
   '*.*',  'All Files (*.*)'},'Select the GRPs file');
GRP_id=fopen([PathName,FileName],'r');
bla=fscanf(GRP_id,'%s',1);
nb_GRP=fscanf(GRP_id,'%d',[1]);
bla=fscanf(GRP_id,'%s',4);
GRP=fscanf(GRP_id,'%g %g %d %d',[4,inf]) ;
fclose(GRP_id);

% display image on a new window
close(1);
figure(1);
imagesc(Img); axis equal; hold on;
plot(GRP(3,:),GRP(4,:),'ro','MarkerSize',5); axis equal; hold on;


fprintf(GRP_file,'GRP\n');
fprintf(GRP_file,'%d\n',compt);
fprintf(GRP_file,'X  Y  i  j \n');
for n=1:compt;
    fprintf(GRP_file,'%g %g %d %d\n',GRP(1,n),GRP(2,n),round(GRP(3,n)),round(GRP(4,n)));
end;
close(1);
status = fclose('all');

ortho_matrix;