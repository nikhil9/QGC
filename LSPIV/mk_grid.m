clear size;
disp('  ');
disp('#########################################');
disp(' Computational grid');
disp('  ');
global out_dir;
grid_path=[out_dir,'grid.dat'];
grid_file=fopen(grid_path,'w');

a1=[];
b1=[];
a2=[];
b2=[];

global xp
global yp
 for i=1:Nb1;
     x1=xp(1)+((i-1)*(xp(2)-xp(1))/(Nb1-1));
     y1=yp(1)+((i-1)*(yp(2)-yp(1))/(Nb1-1));
     x2=xp(4)+((i-1)*(xp(3)-xp(4))/(Nb1-1));
     y2=yp(4)+((i-1)*(yp(3)-yp(4))/(Nb1-1));
     
     if (y1==y2);
        a1(i)=0;
        b1(i)=y1;
     elseif (x1==x2);
         x2=x1+0.1;
         a1(i)=(y1-y2)/(x1-x2);
         b1(i)=(y1)-(a1(i)*(x1));
     else;
         a1(i)=(y1-y2)/(x1-x2);
         b1(i)=(y1)-(a1(i)*(x1));
     end;
 end;
    
for i=1:Nb2;
    x1=xp(2)+((i-1)*(xp(3)-xp(2))/(Nb2-1));
    y1=yp(2)+((i-1)*(yp(3)-yp(2))/(Nb2-1));
    x2=xp(1)+((i-1)*(xp(4)-xp(1))/(Nb2-1));
    y2=yp(1)+((i-1)*(yp(4)-yp(1))/(Nb2-1));
    if (y1==y2);
        a2(i)=0;
        b2(i)=y1;
    elseif (x1==x2);
        x2=x1+0.1;
        a2(i)=(y1-y2)/(x1-x2);
        b2(i)=(y1)-(a2(i)*(x1));
    else;
        a2(i)=(y1-y2)/(x1-x2);
        b2(i)=(y1)-(a2(i)*(x1));
    end;
end;

x=[];
y=[];
for i=1:Nb1;
    for j=1:Nb2;
        x(i,j)=(b2(j)-b1(i))/(a1(i)-a2(j));
        y(i,j)=a1(i)*x(i,j)+b1(i);
        fprintf(grid_file,'%d %d\n',round(x(i,j)),round(y(i,j)));
    end;
end;
status=fclose(grid_file);

N1=load(grid_path);
plot(N1(:,1),N1(:,2),'+'); axis equal; hold on;
