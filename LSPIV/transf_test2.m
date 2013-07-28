global out_dir;
b=zeros(9);
temp_file=fopen([out_dir,'temp_img.dat'],'r');
Name_img = fgetl(temp_file);
Img=imread(Name_img);

info=imfinfo(Name_img);
ni=info.Height;
nj=info.Width;

iinf=0;
isup=ni;
jinf=0;
jsup=nj;
img_path=[out_dir,'Img_gray.pgm'];
imwrite(Img,img_path,'pgm');
img=imread(img_path,'pgm');

Img_transf=fopen('Img_transf.pgm','w');

min_coord=[];
min_coord(1)=x_min;
min_coord(2)=y_min;
max_ccord=[];
max_coord(1)=x_max;
max_coord(2)=y_max;

ref_path=[out_dir,'img_ref.dat'];
img_ref=fopen(ref_path,'w');
fprintf(img_ref,'%s\n','xmin,ymin');
fprintf(img_ref,'%g %g\n',min_coord);
fprintf(img_ref,'%s\n','xmax,ymax');
fprintf(img_ref,'%g %g\n',max_coord);
fprintf(img_ref,'%s\n','resolution');
fprintf(img_ref,'%g\n',resol);

coeff_path=[out_dir,'coeff.dat'];
coeff=fopen(coeff_path,'r');
a=fscanf(coeff,'%g',8);
    
b(1)=double(a(5)-a(8)*a(6));
b(2)=double(a(3)*a(8)-a(2));
b(3)=double(a(2)*a(6)-a(3)*a(5));
b(4)=double(a(7)*a(6)-a(4));
b(5)=double(a(1)-a(3)*a(7));
b(6)=double(a(3)*a(4)-a(1)*a(6));
b(7)=double(a(8)*a(4)-a(7)*a(5));
b(8)=double(a(2)*a(7)-a(1)*a(8));
b(9)=double(a(1)*a(5)-a(2)*a(4));

%tic
gg1=(max_coord(1)-min_coord(1))/resol+1;
gg2=(max_coord(2)-min_coord(2))/resol+1;
gg=zeros(gg1,gg2);

i=0 ;        
for ii=min_coord(1):resol:max_coord(1);
    i=i+1;
    j=0;
    for jj=min_coord(2):resol:max_coord(2);
        j=j+1;
        x=(b(1)*ii+b(2)*jj+b(3))/(b(7)*ii+b(8)*jj+b(9));
        y=(b(4)*ii+b(5)*jj+b(6))/(b(7)*ii+b(8)*jj+b(9));
        if (((x >= jinf+2) && (x <= jsup-2)) && ((y >= iinf+2) && (y <= isup-2)));
            nxp=fix(x);
            nyp=fix(y);
            
            sum_fx=0.;
            for k=1:4;
                for l=1:4;
                    sx=(nxp+k-2)-x;
                    sy=(nyp+l-2)-y;
%  
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
%toc
fprintf(Img_transf,'P2\n');
fprintf(Img_transf,'%d %d\n',maxx,maxy);
fprintf(Img_transf,'255\n');
fprintf(Img_transf,'%d\n',gg(1:maxx,1:maxy));
%toc

status = fclose('all');