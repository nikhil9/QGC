global out_dir
global dis_dir
global vel_dir
global transf_dir
clear size;

disp('  ');
disp('#########################################');
disp(' Quality check and averaging');


list_path=[out_dir,'images_list.dat'];
[list] = textread(list_path,'%s');

 for kl=1:size(list)/2;
    name_lgt1=length(list{kl*2-1});
    list1=list{kl*2-1}(1:(name_lgt1-4));
    name_lgt2=length(list{kl*2});
    list2=list{kl*2}(1:(name_lgt2-4));
    
    prefix=[dis_dir,'dis_'];
    prefix2=[vel_dir,'vel_'];
    sufix='.dat';  
    middle='_';
    NameIn=strcat(prefix,list1,middle,list2,sufix);
    NameOut=strcat(prefix2,list1,middle,list2,sufix);
    
    PIV_file=fopen(NameIn,'r');
    PIV_checked=fopen(NameOut,'w');
    
    dis=[];
    dis=fscanf(PIV_file,'%g %g %g %g %g',[5,inf]);
    compt=size(dis);
    vel=[];
    for i=1:compt(2);
        vel(i)=sqrt(dis(3,i)*dis(3,i)+dis(4,i)*dis(4,i));
        if (vel(i) > max_vel) || (vel(i) < min_vel);
            fprintf(PIV_checked,'%g %g %g %g %g\n',dis(1,i),dis(2,i),0,0,0);
        else;
            fprintf(PIV_checked,'%g %g %g %g %g\n',dis(1,i),dis(2,i),dis(3,i),dis(4,i),dis(5,i));
        end;
    end;
    status = fclose('all');
    
 end;
run moy_ec_pair;

%main_post;
