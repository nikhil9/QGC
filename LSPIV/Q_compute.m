clear size
disp('  ');
close(1)
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

disp('#########################################');
disp(' Select the bathymetry file');

[FileName,PathName] = uigetfile({'*.dat','Data Files (*.dat)';
   '*.*',  'All Files (*.*)'},'Select the bathymetry file');
Name_bath=[PathName,FileName];
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

disp('  ');
disp('#########################################');
coeff_v=str2double(input(' Ratio between depth-averaged velocity and surface velocity:  ', 's'));

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
disp(' ');
disp(['Discharge: ', num2str(Qtot)]);
disp('The unit of the discharge is teh same than the survey points unit (for example, cms if the survey is in meter)')
Q_path=[out_dir,'discharge.dat'];
Q_ref=fopen(Q_path,'w');
fprintf(Q_ref,'%f',Qtot);
disp('  ');
choice=input('Plot discharge data ? (y/n):   ','s');
if (choice=='y');
   
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


    figure(2);
    subplot(1,2,1);
    imagesc('CData',arc1,'XData',[x1 x1+m*pix],'YData',[y1 y1+n*pix]); axis equal; hold on;xlabel('X');ylabel('Y');
    colormap(gray);
    quiver(avg_vel(2,:),avg_vel(1,:),avg_vel(3,:),avg_vel(4,:));axis equal; hold on;xlabel('X');ylabel('Y');
    plot(bath(1,:),bath(2,:),'r-');axis equal; hold on;xlabel('X');ylabel('Y');hold off
    subplot(1,2,2);
    water=zeros(1,taille_bath(2));
    max_depth=max(bath(3,:));
    plot3(bath(1,:),bath(2,:),water(:),'b-'); axis equal; hold on;xlabel('X');ylabel('Y');zlabel('Z');
    plot3(bath(1,:),bath(2,:),-bath(3,:),'k-'); axis equal; hold on;xlabel('X');ylabel('Y');zlabel('Z');
    w=zeros(1,taille_bath(2));
    quiver3(bath(1,:),bath(2,:),water(:),u(:),v(:),w(:),'r'); axis equal; hold on; xlabel('X');ylabel('Y');zlabel('Z');

end

run main_post