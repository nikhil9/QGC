global out_dir
close('all')
disp('  ')
display('#########################################');
display('Computation of the elements of the plan-to-plan projection matrix');
GRP_path=[out_dir,'GRP.dat'];

GRP_file=fopen(GRP_path,'r');
bla=fscanf(GRP_file,'%s',1);
nb_GRP=fscanf(GRP_file,'%d',[1]);
bla=fscanf(GRP_file,'%s',4);
GRP=fscanf(GRP_file,'%g %g %d %d',[4,inf]) ;

coeff_path=[out_dir,'coeff.dat'];
coeff_file=fopen(coeff_path,'w');

T=[];
for i=1:nb_GRP;
    T(i,1)=GRP(3,i);
    T(i,2)=GRP(4,i);
    T(i,3)=1;
    T(i,4)=-GRP(3,i)*GRP(1,i);
    T(i,5)=-GRP(4,i)*GRP(1,i);
    T(i,6)=0;
    T(i,7)=0;
    T(i,8)=0;
end;
for i=nb_GRP+1:2*nb_GRP;
    T(i,1)=0;
    T(i,2)=0;
    T(i,3)=0;
    T(i,4)=-GRP(3,i-nb_GRP)*GRP(2,i-nb_GRP);
    T(i,5)=-GRP(4,i-nb_GRP)*GRP(2,i-nb_GRP);
    T(i,6)=GRP(3,i-nb_GRP);
    T(i,7)=GRP(4,i-nb_GRP);
    T(i,8)=1;
end;

Z=[]; 
 for i=1:nb_GRP;
     Z(i,1)=GRP(1,i);
 end;
 for i=nb_GRP+1:2*nb_GRP;
     Z(i,1)=GRP(2,i-nb_GRP);
 end;

Tt=[];
Tt=T';
TtT=[];
TtT=Tt*T;
TtTinv=[];
TtTinv=inv(TtT);
TtTinvTt=[];
TtTinvTt=TtTinv*Tt;
A=[];
A=TtTinvTt*Z;

for i=1:3;
    fprintf(coeff_file,'%g\n',A(i,1));
end;
fprintf(coeff_file,'%g\n',A(6,1));
fprintf(coeff_file,'%g\n',A(7,1));
fprintf(coeff_file,'%g\n',A(8,1));
fprintf(coeff_file,'%g\n',A(4,1));
fprintf(coeff_file,'%g\n',A(5,1));


status = fclose('all');
display('  ');
display('End of step 1 - GRP Localization');
display('Continue with step 2 - Transformation parameterization');


main_ortho;

