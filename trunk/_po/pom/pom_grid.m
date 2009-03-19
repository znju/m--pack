function [x,y,h,m]=pom_grid(g,ruvp,varargin)
%POM_GRID   Get POM grid data x, y, h and mask
%
%   Syntax:
%      [X,Y,H,M] = POM_GRID(FNAME,RUV,VARARGIN)
%
%   Inputs:
%      FNAME   POM NetCDF file
%      RUV     Locations, may be 'r', 'u' or 'v', for rho, u and v 
%              points (default is 'r')
%      VARARGIN:
%        nomask, if 1, mask at i=1 if RUV=u or at j=1 if RUV=v
%                is not used, is, the first column/row is remove
%                in the outputs, default=0
%        x, x slice, default='1:end'
%        y, y slice, default='1:end'
%
%   Outputs:
%      X,Y   Lon and lat
%      H     Depth
%      M     Mask
%
%   Examples:
%      [x,y,h,m] = pom_grid('pom.nc','v');
%
%   MMA 02-07-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

if nargin <2
  ruvp='r';
end

nomask=0;
xi  = '1:end'; xi0=xi;
eta = '1:end'; eta0=eta;

vin=varargin;
for i=1:length(vin)
  if     isequal(vin{i},'nomask'),  nomask = vin{i+1};
  elseif isequal(vin{i},'x'),       xi     = vin{i+1};
  elseif isequal(vin{i},'y'),       eta    = vin{i+1};
  end
end

if ~ismember(ruvp,{'r','u','v','c'})
  ruvp='r';
end

if strcmpi(ruvp,'u')
  x_name = 'east_u';
  y_name = 'north_u';
  m_name = 'dum';
elseif strcmpi(ruvp,'v')
  x_name = 'east_v';
  y_name = 'north_v';
  m_name = 'dvm';
elseif strcmpi(ruvp,'r')
  x_name = 'east_e';
  y_name = 'north_e';
  m_name = 'fsm';
elseif strcmpi(ruvp,'c') % corners
  x_name = 'east_c';
  y_name = 'north_c';
  m_name = 'fsm';
end

if ~n_varexist(g,x_name) | ~n_varexist(g,y_name)
  x_name = 'east_e';
  y_name = 'north_e';
  m_name = 'fsm';

  x=use(g,x_name);
  y=use(g,y_name);
  m=use(g,m_name);

  if strcmpi(ruvp,'u')
    x=pom_rho2u_2d(x,1);
    y=pom_rho2u_2d(y,1);
    m=pom_rho2u_2d(m);
  elseif strcmpi(ruvp,'v')
    x=pom_rho2v_2d(x,1);
    y=pom_rho2v_2d(y,1);
    m=pom_rho2v_2d(m);
  end
else
  x=use(g,x_name);
  y=use(g,y_name);
  m=use(g,m_name);
end

h=use(g,'h');
if strcmpi(ruvp,'u')
   h=pom_rho2u_2d(h);
elseif strcmpi(ruvp,'v')
   h=pom_rho2v_2d(h);
end

if nomask
  if strcmpi(ruvp,'u')
    x=x(:,2:end);
    y=y(:,2:end);
    h=h(:,2:end);
    m=m(:,2:end);
  elseif strcmpi(ruvp,'v')
    x=x(2:end,:);
    y=y(2:end,:);
    h=h(2:end,:);
    m=m(2:end,:);
  end
end

if ~(isequal(xi,xi0) & isequal(eta,eta0))
  x=eval(['x(' num2str(eta) ',' num2str(xi) ')']);
  y=eval(['y(' num2str(eta) ',' num2str(xi) ')']);
  h=eval(['h(' num2str(eta) ',' num2str(xi) ')']);
  m=eval(['m(' num2str(eta) ',' num2str(xi) ')']);
end
