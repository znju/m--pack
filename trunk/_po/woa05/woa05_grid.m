function [x,y,h,m,m3d]=woa05_grid(fls,ftemp)
% fls: lansead file
% ftemp: anual data file, like annual temperature

depth=[0 10 20 30 50 75 100 125 150 200 250 300 400 500 600 700 800 900 1000 ...
       1100 1200 1300 1400 1500 1750 2000 2500 3000 3500 4000 4500 5000 5500 ...
       6000, 6500, 7000, 7500, 8000, 8500, 9000];


x=use(ftemp,'X');
y=use(ftemp,'Y'); % or fls Y
[x,y]=meshgrid(x,y);

xx=use(fls,'lon');
i=find(xx<180); i=i(end);
landsea=use(fls,'landsea');
h=depth(landsea);

h=[h(:,i+1:end) h(:,1:i)];
m=double(h~=0);

temp=use(ftemp,'temperature','T',1); % annual file !!
m3d=double(~isnan(temp));

