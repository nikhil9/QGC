cla
moy_path=[out_dir,'average_vel.dat'];
moy_file=fopen(moy_path,'w');

ref_path=[out_dir,'img_ref.dat'];
img_ref=fopen(ref_path,'r');
bla=fscanf(img_ref,'%s',1);
min_coord=fscanf(img_ref,'%g %g',[2]);
bla=fscanf(img_ref,'%s',1);
max_coord=fscanf(img_ref,'%g %g',[2]);
bla=fscanf(img_ref,'%s',1);
resol=fscanf(img_ref,'%g',[1]);

list_path=[out_dir,'images_list.dat'];
[list] = textread(list_path,'%s');
x=[];
y=[];
u=[];
v=[];
r=[];

for kl=1:size(list)-1;
    name_lgt1=length(list{kl});
    list1=list{kl}(1:(name_lgt1-4));
    name_lgt2=length(list{kl+1});
    list2=list{kl+1}(1:(name_lgt2-4));  
    prefix=[vel_dir,'vel_'];
    sufix='.dat';  
    middle='_';

    NameIn=strcat(prefix,list1,middle,list2,sufix);
      
    PIV_file=fopen(NameIn,'r');
    vel=fscanf(PIV_file,'%g %g %g %g %g',[5,inf]);
    compt=size(vel);
    compt(2);
    status=fclose(PIV_file);
    PIV_file=fopen(NameIn,'r');
    for i=1:compt(2);
        vel_dat=fscanf(PIV_file,'%g %g %g %g %g\n',[5]);
        x(i,kl)=vel_dat(1);
        y(i,kl)=vel_dat(2);
        u(i,kl)=vel_dat(3);
        v(i,kl)=vel_dat(4);
        r(i,kl)=vel_dat(5);
    end;

    status = fclose(PIV_file);         
end;
 
for i=1:compt(2);
    sum_u(i)=0;
    sum_v(i)=0;
    nb(i)=0;
    for j=1:size(list)-1;
        if ((u(i,j)==0) & (v(i,j)==0));
            nb(i)=nb(i);
        else;
            nb(i)=nb(i)+1;
        end;
        sum_u(i)=sum_u(i)+u(i,j);
        sum_v(i)=sum_v(i)+v(i,j) ;           
    end;

    if (nb(i)~=0);
        mean_u(i)=sum_u(i)/nb(i);
        mean_v(i)=sum_v(i)/nb(i);
    else;
        mean_u(i)=0;
        mean_v(i)=0;
    end;
 
    sum_dif_u(i)=0;
    sum_dif_v(i)=0;
    for j=1,1:size(list)-1;
        if ((u(i,j)~=0) & (v(i,j)~=0));
            dif_u(i)=(u(i,j)-mean_u(i))*(u(i,j)-mean_u(i));
            dif_v(i)=(v(i,j)-mean_v(i))*(v(i,j)-mean_v(i));
            sum_dif_u(i)=sum_dif_u(i)+dif_u(i);
            sum_dif_v(i)=sum_dif_v(i)+dif_v(i) ;    
        end;
    end;
    if (nb(i) > 1);
        ec_u(i)=sqrt(sum_dif_u(i)/(nb(i)-1));
        ec_v(i)=sqrt(sum_dif_v(i)/(nb(i)-1)) ;        
    else;
        ec_u(i)=0;
        ec_v(i)=0;
    end;
    if (ec_u(i) < 0.001); 
        ec_u(i)=0;
    end;
    if (ec_v(i) < 0.001); 
        ec_v(i)=0;
    end;
      fprintf(moy_file,'%g %g %g %g %g %g\n',x(i,1),y(i,1),mean_u(i),mean_v(i),ec_u(i),ec_v(i));
end;


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

   %%%%%%%%%%%%%%%%%%%%%%%%
   %%% fichiers resultats %% 
   %%%%%%%%%%%%%%%%%%%%%%%%
   grid_path=[out_dir,'grid.dat'];
   N1=load(grid_path);
   [a b]=size(N1);

   % figure(3);
    imagesc('CData',arc1,'XData',[x1 x1+m*pix],'YData',[y1 y1+n*pix]); hold on;
    colormap(gray);

   h=quiver(y(:,1),x(:,1),mean_u(:),mean_v(:),'Color','b'); axis equal; hold on; 
posx=x1-(m*pix)/10;
posy=y1-(n*pix)/10;
posy2=posy+abs((n*pix)/10);
   addrefarrow(h,posx,posy,max(sqrt(mean_u.*mean_u+mean_v.*mean_v)),0);
   tt=num2str(max(sqrt(mean_u.*mean_u+mean_v.*mean_v)));
   text(posx,posy2,tt,'Color','b');

%status = fclose('all');  