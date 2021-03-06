disp('  ');
disp('#########################################');
disp(' Select the recording type');
disp('  ');
seq_path=[out_dir,'seq_pair.dat'];
seq_pair=fopen(seq_path,'w');
choice=input('1 - Sequence of images / 2 - Image pairs:    ','s');
if (choice == '1');
    fprintf(seq_pair,'%s','Sequence');
    disp('  ');
    disp(' Begining of the PIV procedure...');
    run PIV_seq;
elseif (choice =='2');
    fprintf(seq_pair,'%s','Pairs');
    disp('  ');
    disp(' Begining of the PIV procedure...');
    run PIV_pairs;
end;
disp('  ');
status = fclose('all');
clear('PIV_param');
display('End of step 3 - PIV analysis of all the images');
disp('Go back to previou menu for the post processing');