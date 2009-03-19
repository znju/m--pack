function [sustr,svstr] = occam2frc_vars(fname,grd,varargin)
%function [sustr,svstr] = occam2frc_vars(fname,grd,varargin)
%under cosntruction.... only for wind stress currently !!
%
% 18-6-2008
%

quiet=0;
extrapLand=1;

vin=varargin;
for i=1:length(vin)
  if isequal(vin{i},'quiet'),          quiet      = vin{i+1};
  elseif isequal(vin{i},'extrapland'), extrapLand = vin{i+1};
  end
end

% get grid vars:
[xg,yg,hg,mg]=roms_grid(grd);
xu=use(grd,'lon_u');
xv=use(grd,'lon_v');
yu=use(grd,'lat_u');
yv=use(grd,'lat_v');
ang=use(grd,'angle')*180/pi;
[eta,xi]=size(hg);

[xoc,yoc,hocr,mr,Mr]   = occam_grid(fname,'r');
[xocu,yocu,hocu,mu,Mu] = occam_grid(fname);

% extract occam data:
if ~quiet
  fprintf(1,'  > loading occam data\n');
end
Ustress=use(fname,'U_WIND_STRESS__MEAN_');
Vstress=use(fname,'V_WIND_STRESS__MEAN_');

% interp to grd:
% get U and V at rho points in order to rotate to grid angles:
if ~quiet
  fprintf(1,'  > interp to grd\n');
end
Ustress=interp2(xocu,yocu,Ustress,xg,yg);
Vstress=interp2(xocu,yocu,Vstress,xg,yg);

% rotate U V and set at Arakawa-C u and v locations:
if ~quiet
  fprintf(1,'  > rotating U and V by grid angles\n');
end
[sustr,svstr]=rot2d(Ustress,Vstress,-ang);
sustr=(sustr(:,1:end-1)+sustr(:,2:end))/2;
svstr=(svstr(1:end-1,:)+svstr(2:end,:))/2;

% extrap on land:
if extrapLand
  if ~quiet
    fprintf(1,'  > extrap on land\n');
  end
  sustr=extrap2(xu,yu,sustr,0);
  svstr=extrap2(xv,yv,svstr,0);
end
