function [DDX,Dmean,Dmstd,tifs]=shelf_break_diff(x0,y0,h0,x1,y1,h1,varargin)
%SHELF_BREAK_DIFF   Mean distance between two shelf breaks
%
%   Syntax:
%      [D,DM,DMS,IMS] = SHELF_BREAK_DIFF(X0,Y0,H0,X1,Y1,H1,VARARGIN)
%
%   Inputs:
%      X0,Y0,H0   First positions and depths
%      X1,Y1,H1   Second positions and depths (H1 will be interpolated
%                 to X0,Y0)
%      VARARGIN
%         ij, distance along j, 2, or along i, 1 (default=2)
%         depths, shelf break depths range, default=[200 1000]
%         dmax, maximum distance considered, values higher are not
%               used, default=20000 (20 km)
%         plot, if 1, each slice is plotted, default=0
%         save, provide the savename to save each plot or 0. The
%               outputs will be saved as savename_00j
%         ylim, ylim to use if plot
%
%   Outputs:
%      D   Raw distances for each j (or i)
%      DM   Mean distances
%      DMS  Mean plus std
%      IMS  Sequence with savenames, if save
%
%   MMA 30-6-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

yl      = 'auto';
tosave  = 0;
plt     = 0;
ij      = 2;
depths  = [200 1000];
diffmax = 20000;

vin=varargin;
for i=1:length(vin)
  if     isequal(vin{i},'plot'),    plt     = vin{i+1};
  elseif isequal(vin{i},'save'),    tosave  = vin{i+1};
  elseif isequal(vin{i},'ylim'),    yl      = vin{i+1};
  elseif isequal(vin{i},'ij'),      ij      = vin{i+1};
  elseif isequal(vin{i},'depths'),  depth   = vin{i+1};
  elseif isequal(vin{i},'dmax'),    diffmax = vin{i+1};
  end
end

if tosave, plt=1; end


% interp h1 to x0,y0:
h10=interp2(x1,y1,h1,x0,y0);

[eta,xi]=size(x0);

if ij==1,
  x0=x0';
  y0=y0';
  h0=h0';
  h10=h10';
end

tifs={};
c=progress('init');
for i=1:eta
  c=progress(c,i/eta);
  x_=x0(i,:);
  y_=y0(i,:);

  % convert X to distance:
  dx=spheric_dist(y_(2:end),y_(1:end-1),x_(2:end),x_(1:end-1));
  dx=[0; cumsum(dx(:))];

  i1=find(h0(i,:)>=depths(1));   i1=i1(1);
  i2=find(h0(i,:)<=depths(end)); i2=i2(end);

  ddx=[];
  for ii=i1:i2
    xx=interp_mp(h10(i,:),dx,h0(i,ii)); xx=min(xx);% closer to slope!
    if ~isempty(xx)
      ddx(end+1)=dx(ii)-xx;
    end
  end
  ddx=mean(abs(ddx));
  if ddx<diffmax
    DDX(i)=ddx;
  else
    DDX(i)=-1;
  end

  if plt
    figure(99)
    hold off
    plot(dx,-h10(i,:))
    hold on
    plot(dx,-h0(i,:),'r')
    for ii=i1:i2
      plot(dx(ii),-h0(i,ii),'r*')
      xx=interp_mp(h10(i,:),dx,h0(i,ii)); xx=min(xx);
      plot(xx,-h0(i,ii),'r*')
    end
    xlabel(sprintf('%6.2f km',ddx/1000))
    title([num2str(i) ' of ' num2str(eta)])
    ylim(yl)
    if tosave
      tifs{end+1}=get_tiff(i,tosave);
    else
      pause(.01)
    end
  end

end
D=DDX;
D(D==-1)=[];
Dmean=mean(D);
Dmstd=mean(D)+std(D);

if plt
  figure
  plot(DDX)
  hold on
  plot(xlim,[Dmean Dmean],'r')
  plot(xlim,[Dmstd Dmstd],'k')
  title(sprintf('mean, mean+std = %6.2f %6.2f km',Dmean/1000,Dmstd/1000))
  if tosave
    get_tiff(0,tosave)
  end
end
