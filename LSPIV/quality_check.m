global out_dir
seq_path=[out_dir,'seq_pair.dat'];
seq_pair=fopen(seq_path,'r');
seq_choice='';
seq_choice=fscanf(seq_pair,'%s',1);

 status=fclose('all');
k = strcmp(seq_choice, 'Sequence');
if (k==1);
    run quality_check_seq;
else;
    run quality_check_pair;
end;


