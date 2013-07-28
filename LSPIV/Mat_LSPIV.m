disp('#########################################')
disp('####                                 ####')
disp('####       Matlab LSPIV Software     ####')
disp('####                                 ####')
disp('#### IIHR-Hydroscience & Engineering ####')
disp('####        A. Hauet -- 2007         ####')
disp('####                                 ####')
disp('#########################################')

clear;
disp('  ');
disp('  ');
disp('#########################################');
disp(' Create a new project or resume a project');
disp('  ');

dname = uigetdir('C:\','Create a directory or open project directory');
list=dir(dname);
list(:).name;
 
size_list=size(list);
size=size_list(1)-2;

LSPIV_dir=[dname,'\'];
global out_dir
global transf_dir
global dis_dir
global vel_dir

out_dir=[LSPIV_dir,'outputs\'];
transf_dir=[LSPIV_dir,'img_transf\'];
dis_dir=[LSPIV_dir,'displacements\'];
vel_dir=[LSPIV_dir,'quality_vel\'];


if (size==0);
    disp('  ');
    disp(' Creation of New Project:');
    disp(dname);
    mkdir(out_dir);
    mkdir(transf_dir);
    mkdir(dis_dir);
    mkdir(vel_dir);
    path_file=[out_dir,'file_path.dat'];
    path_id=fopen(path_file,'w');
    fprintf(path_id,'%s',dname);
    fclose(path_id);
else
    disp('  ');
    display('Resume project:');
    disp(dname);
end
   
%status = fclose('all');

main_LSPIV