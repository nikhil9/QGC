close(1);
clear size;
%Images parameters
ref_path=[out_dir,'img_ref.dat'];
Img_file=fopen(ref_path,'r');
bla=fscanf(Img_file,'%s',1);
min_coord=fscanf(Img_file,'%g %g',[2]);
bla=fscanf(Img_file,'%s',1);
max_coord=fscanf(Img_file,'%g %g',[2]);
bla=fscanf(Img_file,'%s',1);
resol=fscanf(Img_file,'%g',[1]);
fclose(Img_file);

 %PIV processing parameters
param_path=[out_dir,'PIV_param.dat'];
PIV_param=fopen(param_path,'r');
bla=fscanf(PIV_param,'%s',2);
Bij=fscanf(PIV_param,'%d',[1]);
bla=fscanf(PIV_param,'%s',9);
Sim=fscanf(PIV_param,'%d',[1]);
Sip=fscanf(PIV_param,'%d',[1]);
Sjm=fscanf(PIV_param,'%d',[1]);
Sjp=fscanf(PIV_param,'%d',[1]);
bla=fscanf(PIV_param,'%s',2);
interv=fscanf(PIV_param,'%g',[1]);
bla=fscanf(PIV_param,'%s',2);
corr_min=fscanf(PIV_param,'%g',[1]);
fclose(PIV_param);

Bi=Bij;
Bj=Bij;

grid_path=[out_dir,'grid.dat'];
grid_file=fopen(grid_path,'r');
grid_data=fscanf(grid_file,'%d %d',[2,inf]);
nb_grid=size(grid_data,2);
fclose(grid_file);

ia=zeros(Bi,Bj);
ib=zeros(Bi,Bj);
c=zeros(Sim+Sip,Sjm+Sjp);

list_path=[out_dir,'images_list.dat'];
[list] = textread(list_path,'%s');
disp('  ')
 for kl=1:size(list)/2;
    name_lgt1=length(list{(kl*2)-1});
    list1=list{(kl*2)-1}(1:(name_lgt1-4));
    prefix=transf_dir;
    sufix='_transf.pgm';
    Name_img_a=strcat(prefix,list1, sufix);
    name_lgt2=length(list{(kl*2)});
    list2=list{kl*2}(1:(name_lgt2-4));
    Name_img_b=strcat(prefix,list2, sufix);
    disp(['Images beeing analyzed: ' list1, sufix, ' and ',list2, sufix]);
    
    Img_a=imread(Name_img_a,'pgm');
    Img_b=imread(Name_img_b,'pgm');
    
    prefix2=[dis_dir,'dis_'];
    sufix2='.dat';  
    middle='_';
    NameOut=strcat(prefix2,list1,middle,list2,sufix2);
 
    piv_file=fopen(NameOut,'w');
  
    ni=size(Img_a,1);
    nj=size(Img_a,2);
 
    for i=1:nb_grid;
        sum_ia=0.;
        x=grid_data(1,i);
        y=grid_data(2,i);
        if ((x-Sjm-Bj/2)>0 && (y-Sim-Bi/2)>0 && (x+Sjp+Bj/2)<nj && (y+Sip+Bi/2)<ni)
        for k=1:Bi;
            for l=1:Bj;
                ia(k,l)=Img_a(y+(k-Bi/2),x+(l-Bj/2));
                sum_ia=sum_ia+ia(k,l);
            end;    
        end;

        sum_ia=sum_ia/(Bi*Bj);
        sum_te=0;
        for te=1:Bi;
            for td=1:Bj;
                sum_te=sum_te+ia(te,td); 
            end;
        end;
        if (sum_te ~= 0);
            cmax=-99;
            for m=1:Sim+Sip;
                for n=1:Sjm+Sjp;
                    sum_ib=0.;
                    for k=1:Bi;
                        for l=1:Bj;
                            ib(k,l)=Img_b(y+(m-Sim)+(k-Bi/2),x+(n-Sjm)+(l-Bj/2));
                            sum_ib=sum_ib+ib(k,l);                  
                        end;
                    end;
                    if (sum_ib == 0);
                        c(m,n)=0.001;
                    else;
                        sum_ib=sum_ib/(Bi*Bj);

                        sum_t1=0.;
                        sum_t2=0.;
                        sum_t3=0.;
                        for k=1:Bi;
                            for l=1:Bj;
                                t1=(ia(k,l)-sum_ia)*(ib(k,l)-sum_ib);
                                sum_t1=sum_t1+t1;
                                t2=(ia(k,l)-sum_ia)*(ia(k,l)-sum_ia);
                                sum_t2=sum_t2+t2;
                                t3=(ib(k,l)-sum_ib)*(ib(k,l)-sum_ib);
                                sum_t3=sum_t3+t3;
                            end;
                        end;
              
                        c(m,n)=abs(sum_t1/(sqrt(sum_t2*sum_t3)));

                        if (c(m,n) > cmax);
                            cmax=c(m,n);
                            imax=m-(Sim);
                            jmax=n-(Sjm);
                        end; 
                    end;
                end;
            end;
    % % %         gaussian sub-pixel fit
            if ((cmax >= corr_min) && (cmax <= 0.999));
                if ((imax+Sim > 1) && (jmax+Sjm > 1) && (imax+Sim < Sim+Sip-1) && (jmax+Sjm < Sjm+Sjp-1)); 
                    dm=0.5*(log(c(imax+Sim-1,jmax+Sjm))-log(c(imax+Sim+1,jmax+Sjm)))/(log(c(imax+Sim-1,jmax+Sjm))+log(c(imax+Sim+1,jmax+Sjm))-2*log(c(imax+Sim,jmax+Sjm)));
                    dn=0.5*(log(c(imax+Sim,jmax+Sjm-1))-log(c(imax+Sim,jmax+Sjm+1)))/(log(c(imax+Sim,jmax+Sjm-1))+log(c(imax+Sim,jmax+Sjm+1))-2*log(c(imax+Sim,jmax+Sjm)));
                else;
                    dm=0;
                    dn=0;
                end;
                
                if ((dm > -1) && (dm < 1) && (dn > -1) && (dn < 1));
             
                    fprintf(piv_file,'%g %g %g %g %g\n',y*resol+min_coord(2),x*resol+min_coord(1),((jmax+dn)*resol)/interv,((imax+dm)*resol)/interv,cmax);                   
                else;           
                    fprintf(piv_file,'%g %g %g %g %g\n',y*resol+min_coord(2),x*resol+min_coord(1),(jmax*resol)/interv,(imax*resol)/interv,cmax);
                end;
            else;
                fprintf(piv_file,'%g %g %g %g %g\n',y*resol+min_coord(2),x*resol+min_coord(1),0,0,0);
            end;

        else;

            fprintf(piv_file,'%d %d %g %g %g\n',y*resol+min_coord(2),x*resol+min_coord(1),0,0,0);
        end;
        end;
    end;
    fclose(piv_file);
end;
status = fclose('all');

main_PIV