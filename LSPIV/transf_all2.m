close(1);
clear size;

disp('  ');
disp('#########################################');
disp(' Geometric transformation of all the images');
disp('  ');
disp(' Select the images to process');

list_path=[out_dir,'images_list.dat'];
img_list_file=fopen(list_path,'w');
%setappdata(0,'UseNativeSystemDialogs',false);
%[FileName,PathName] = uigetfile({'*.jpg;*.bmp;*.tif;*.png;*.gif','Image Files (*.jpg,*.bmp,*.tif,*.png,*.gif)';'*.*','All Files (*.*)'},' Select the images to process','MultiSelect','on');
[FileName,PathName] = uigetfiles('*.*; *.*', 'Choose your files');
name_list=sort(FileName);
fprintf(img_list_file,'%s \n',name_list{1,:});
status=fclose(img_list_file);
img_list_file=fopen(list_path,'r');

fmt_path=[out_dir,'Img_format.dat'];
Img_fmt_file=fopen(fmt_path,'r');
Img_fmt=fscanf(Img_fmt_file,'%s',1);
b=zeros(9);
gg=[];
 
ref_path=[out_dir,'img_ref.dat'];
img_ref=fopen(ref_path,'r');
bla=fscanf(img_ref,'%s',1);
min_coord=fscanf(img_ref,'%g %g',2);
bla=fscanf(img_ref,'%s',1);
max_coord=fscanf(img_ref,'%g %g',2);
bla=fscanf(img_ref,'%s',1);
resol=fscanf(img_ref,'%g',1);
 
coeff_path=[out_dir,'coeff.dat'];
coeff=fopen(coeff_path,'r');
a=fscanf(coeff,'%g',8);

close('all')

list='';
list_name=[];
disp('  ');

while ~feof(img_list_file) ;
    list=fgetl(img_list_file);
    NameIn=strcat(PathName,list);
    text_disp=['Transformation of image:   ',list,'  in progress...'];
    disp(text_disp);
    name_lgt=length(list);
    list2=list(1:(name_lgt-5));
    Img=imread(NameIn);
    ni=size(Img,1);
    nj=size(Img,2);
    iinf=0;
    isup=ni;
    jinf=0; 
    jsup=nj;
    imwrite(Img,'image-gray.pgm','pgm');
    img=imread('image-gray.pgm','pgm');
    prefix=transf_dir;
    sufix='_transf.pgm';
    NameOut=strcat(prefix, list2, sufix);
     
    Img_transf=fopen(NameOut,'w');
     
    b(1)=double(a(5)-a(8)*a(6));
    b(2)=double(a(3)*a(8)-a(2));
    b(3)=double(a(2)*a(6)-a(3)*a(5));
    b(4)=double(a(7)*a(6)-a(4));
    b(5)=double(a(1)-a(3)*a(7));
    b(6)=double(a(3)*a(4)-a(1)*a(6));
    b(7)=double(a(8)*a(4)-a(7)*a(5));
    b(8)=double(a(2)*a(7)-a(1)*a(8));
    b(9)=double(a(1)*a(5)-a(2)*a(4));
 
    i=0;
    for ii=min_coord(1):resol:max_coord(1);
        i=i+1;
        j=0;
        for jj=min_coord(2):resol:max_coord(2);
            j=j+1;
        end;
    end;
    gg=zeros(i,j);
 
    i=0 ;        
    for ii=min_coord(1):resol:max_coord(1);
        i=i+1;
        j=0;
        for jj=min_coord(2):resol:max_coord(2);
            j=j+1;
            x=(b(1)*ii+b(2)*jj+b(3))/(b(7)*ii+b(8)*jj+b(9));
            y=(b(4)*ii+b(5)*jj+b(6))/(b(7)*ii+b(8)*jj+b(9));

            if (((x >= jinf+2) && (x <= jsup-2)) && ((y >= iinf+2) && (y <= isup-2)))
                nxp=fix(x);
                nyp=fix(y);
            
                sum_fx=0.;
                for k=1:4;
                    for l=1:4;
                        sx=(nxp+k-2)-x;
                        sy=(nyp+l-2)-y; 
                        if ((abs(sx) >= 0) && (abs(sx) < 1));
                            Cx=1-2*(abs(sx)*abs(sx))+(abs(sx)*abs(sx)*abs(sx));
                        elseif ((abs(sx) >= 1) && (abs(sx) < 2));
                            Cx=4-8*abs(sx)+5*(abs(sx)*abs(sx))-(abs(sx)*abs(sx)*abs(sx));
                        elseif (abs(sx) > 2);
                            Cx=0.;
                        end;

                        if ((abs(sy) >= 0) && (abs(sy) < 1));
                            Cy=1-2*(abs(sy)*abs(sy))+(abs(sy)*abs(sy)*abs(sy));
                        elseif ((abs(sy) >= 1) && (abs(sy) < 2));
                            Cy=4-8*abs(sy)+5*(abs(sy)*abs(sy))-(abs(sy)*abs(sy)*abs(sy));
                        elseif (abs(sy)> 2);
                            Cy=0.;
                        end;
                   
                        fx=(double(img(nyp+l-2,nxp+k-2)))*Cx*Cy;
                    
                        sum_fx=sum_fx+fx;
                    end;
                end;

                gg(i,j)=round(sum_fx);

                if (gg(i,j) > 255) ;
                    gg(i,j)=255;
                end;
                if (gg(i,j) < 0);
                    gg(i,j)=0   ;
                end;
            
            end;
        end;
    end;
    maxx=i-1;
    maxy=j-1;
  
    fprintf(Img_transf,'P2\n');
    fprintf(Img_transf,'%d %d\n',maxx,maxy);
    fprintf(Img_transf,'255\n');
    fprintf(Img_transf,'%d\n',gg(1:maxx,1:maxy));

status = fclose(Img_transf);
end;

%run enhanc_all
disp('  ');
display('End of step 3 - Transform all images');
disp('Go back to previous menu and start the PIV analysis');

clear PIV_param;

run main_ortho;