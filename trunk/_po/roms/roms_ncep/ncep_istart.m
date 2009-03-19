function [is,ie,dt]=ncep_istart(file,tstart,tend);
%NCEP_ISTART   Get start and end time indices in NCEP files
%
%   Syntax:
%      [IS,IE,DT] = NCEP_ISTART(FILE,TSTART,TEND)
%
%   Inputs:
%      FILE     NCEP NetCDF file
%      TSTART   Start date string [ <'Y-M-D'> ]
%      TEND     End date string [ <'Y-M-D'> ]
%
%   Outputs:
%      IS   Start indice in file corresponding to tstart
%      IE   End indice corresponding to tend
%      DT   Time step (hours)
%
%   Comments:
%      If bad end time is displayed, the file has not data until such
%      date.
%      To use data till end year, use something like
%      tend = '31.8-Dec-year'
%
%   Example:
%      [is,ie,dt]=ncep_istart(file,'1-Jan-2003','1-May-2003');
%
%   MMA 26-5-2004, martinho@fis.ua.pt
%
%   See also NCEP_GETVAR, NCEP_GEN

%   Department of Physics
%   University of Aveiro, Portugal

%   ??-02-2005 - Bug fix

disp(['# file = ',file]);

% ----------------------------------- get delta_t:
dt=n_varatt(file,'time','delta_t');
dt=strrep(dt,'-','');
dt=strrep(dt,':','');
dt=strrep(dt,'0','');
dt=str2num(dt);
disp(['  -> dt = ',num2str(dt)]);

% ------------------------------------ get data range:
dataRange = n_varatt(file,'time','actual_range');
dr1=dataRange(1)/24;
dr2=dataRange(2)/24;

nrange1 = dr1 + datenum(1,1,1,0,0,0) - 2;
nrange2 = dr2 + datenum(1,1,1,0,0,0) - 2;

drange1 = datestr( nrange1, 0);
drange2 = datestr( nrange2, 0);

disp(['  -> data range = ',drange1]);
disp(['                  ',drange2]);


% ---------------------------------
is=datenum(tstart)-nrange1;
is=is*24/dt+1; is = floor(is);

ie=datenum(tend)-nrange1;
ie=ie*24/dt+1; ie = floor(ie); % thus can use 31.8-Dec-2005 for all data

% ---------------------------------
% get time:
nc=netcdf(file);
  t1=nc{'time'}(is);
  t2=nc{'time'}(ie);
nc=close(nc);

% confirm values:
drange1 = datestr( t1/24 + datenum(1,1,1,0,0,0) - 2, 0);
drange2 = datestr( t2/24 + datenum(1,1,1,0,0,0) - 2, 0);

disp(['  -> time indice of = ',drange1,'  --> ',num2str(is)]);
disp(['  -> time indice of = ',drange2,'  --> ',num2str(ie)]);
