function [xb,yb,zb] = pom_border(fname,slice,ind,time,ruvw)
%POM_BORDER   Get POM slice border
%
%   Syntax:
%      [XB,YB,ZB] = POM_BORDER(FNAME,SLICE,IND,TIME,RUVW)
%
%   Inputs:
%      FNAME   POM NetCDF file
%      SLICE   Type of slice, i,j,k,z,ll,3d (default is z), if is
%              3d, then the full region boundary is returned, ie,
%              includes ssh and depth
%      IND     Slice indice (default is 1), or {lon,lat} for slice ll
%      TIME    Time indice (default is 1)
%      RUVW    Type of variable, r,u,v or w (default is r)
%
%   Outputs:
%      XB,YB,ZB   Border lon ad lat and depth with ssh
%
%   Examples:
%      [xb,yb,zb] = pom_border('pom.nc');
%      plot3(xb,yb,zb)
%
%   MMA 04-07-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

if nargin <5
  ruvw='r';
end
if nargin <4
  time=1;
end
if nargin <3
  ind=1;
end
if nargin <2
  slice='z';
end

[xg,yg,hg]=pom_grid(fname,ruvw);

if strcmpi(slice,'z') |  strcmpi(slice,'k')
  xb=var_border(xg);
  yb=var_border(yg);
  if nargout>2 % calc zb
    if strcmpi(slice,'z')
      zb=repmat(ind,size(xb));
    else
      % calc s-level k:
      [zr,zw]=pom_s_levels(fname,time);
      if strcmpi(ruvw,'w'), z=squeeze(zw(:,:,ind));
      else                  z=squeeze(zr(:,:,ind)); end

      if strcmpi(ruvw,'u')
        z=(z(:,2:end)+z(:,1:end-1))/2;
        z(:,2:end+1)=z;
      elseif strcmpi(ruvw,'v')
        z=(z(2:end,:)+z(1:end-1,:))/2;
        z(2:end+1,:)=z;
      end
      zb=var_border(z);
    end
  end

elseif  strcmpi(slice,'j') |  strcmpi(slice,'i')
  if  strcmpi(slice,'j')
    ssh=use(fname,'elb','y',ind,'time',time);
    h=hg(ind,:);
    x=xg(ind,:);
    y=yg(ind,:);

    if strcmpi(ruvw,'u')
      ssh=(ssh(2:end)+ssh(1:end-1))/2;
      ssh(2:end+1)=ssh;
    elseif strcmpi(ruvw,'v')
      if ind>1
        ssh0=use(fname,'elb','y',ind-1,'time',time);
        ssh  = (ssh0+ssh)/2;
      end
    end

  elseif strcmpi(slice,'i')
    ssh=use(fname,'elb','x',ind,'time',time)';
    h=hg(:,ind)';
    x=xg(:,ind)';
    y=yg(:,ind)';

    if strcmpi(ruvw,'v')
      ssh=(ssh(2:end)+ssh(1:end-1))/2;
      ssh(2:end+1)=ssh;
    elseif strcmpi(ruvw,'u')
      if ind>1
        ssh0=use(fname,'elb','x',ind-1,'time',time)';
        ssh  = (ssh0+ssh)/2;
      end
    end

  end

  % calc dist:
  dst=spheric_dist(y(2:end),y(1:end-1),x(2:end),x(1:end-1));
  dst=[0; cumsum(dst(:))]; dst=dst(:)';
  dst=[dst fliplr(dst) dst(1)];

  xb=[x fliplr(x) x(1)];
  yb=[y fliplr(y) y(1)];
  zb=[-h fliplr(ssh) -h(1)];

elseif  strcmpi(slice,'ll')
  ssh=use(fname,'elb','time',time)';
  X=ind{1};
  Y=ind{2};
  if length(X)==3, x=linspace(X(1),X(2),X(3)); else x=X(:)'; end
  if length(Y)==3, y=linspace(Y(1),Y(2),Y(3)); else y=Y(:)'; end

  % calc dist:
  dst=spheric_dist(y(2:end),y(1:end-1),x(2:end),x(1:end-1));
  dst=[0; cumsum(dst(:))]; dst=dst(:)';
  dst=[dst fliplr(dst)];

  h   = griddata(xg,yg,hg, x,y); h=h(:)';
  ssh = griddata(xg,yg,ssh',x,y); ssh=ssh(:)';

  xb=[x fliplr(x)];
  yb=[y fliplr(y)];
  zb=[-h fliplr(ssh)];

  is=isnan(zb);
  xb(is)=[];
  yb(is)=[];
  zb(is)=[];
  dst(is)=[];

  xb(end+1)=xb(1);
  yb(end+1)=yb(1);
  zb(end+1)=zb(1);
  dst(end+1)=dst(1);

elseif strcmpi(slice,'3d')
  % for rho
  [xg,yg,hg]=pom_grid(fname,'r'); hg=-hg;
  ssh=use(fname,'elb','time',time);

  xb0=[xg(1,:)   xg(:,end)' fliplr( xg(end,:)) fliplr( xg(:,1)')];
  yb0=[yg(1,:)   yg(:,end)' fliplr( yg(end,:)) fliplr( yg(:,1)')];
  zb0=[ssh(1,:) ssh(:,end)' fliplr(ssh(end,:)) fliplr(ssh(:,1)')];

  xb1=xb0;
  yb1=yb0;
  zb1=[hg(1,:) hg(:,end)' fliplr(hg(end,:)) fliplr(hg(:,1)')];

  xbc=[xg(1,1)  xg(1,1) nan xg(1,end)  xg(1,end) nan xg(end,end)  xg(end,end) nan xg(end,1)  xg(end,1)];
  ybc=[yg(1,1)  yg(1,1) nan yg(1,end)  yg(1,end) nan yg(end,end)  yg(end,end) nan yg(end,1)  yg(end,1)];
  zbc=[ssh(1,1) hg(1,1) nan ssh(1,end) hg(1,end) nan ssh(end,end) hg(end,end) nan ssh(end,1) hg(end,1)];

  xb=[xb0 nan xb1 nan xbc];
  yb=[yb0 nan yb1 nan ybc];
  zb=[zb0 nan zb1 nan zbc];
end

if nargout==2 & ~(strcmpi(slice,'z') |  strcmpi(slice,'k'))
  xb=dst;
  yb=zb;
end
