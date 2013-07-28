close('all');
clear size

disp('  ');
disp('#########################################');
disp(' Parametrization of the PIV parameters');
disp('  ');

list_path=[out_dir,'images_list.dat'];
[list] = textread(list_path,'%s');

name_lgt1=length(list{1});
list1=list{1}(1:(name_lgt1-4));
prefix1=transf_dir;
sufix1='_transf.pgm';
NameIn1='';
NameIn1=strcat(prefix1, list1, sufix1);

name_lgt2=length(list{2});
list2=list{2}(1:(name_lgt1-4));
NameIn2='';
NameIn2=strcat(prefix1, list2, sufix1);

global Img1
global Img2
Img1=imread(NameIn1,'pgm');
Img2=imread(NameIn2,'pgm');

run PIV_param_gui
