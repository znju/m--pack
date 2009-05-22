function d = n_vararraydim(file,varname)
%N_VARARRAYDIM   Get array dimension of a NetCDF variable, range or size
%
%   Syntax:
%      D = N_VARARRAYDIM(FILE,VARNAME)
%      D = N_VARARRAYDIM(VARSIZE)
%      D = N_VARARRAYDIM(RANGE)
%
%   Inputs:
%      FILE      NetCDF file
%      VARNAME   Variable
%      VARSIZE   Size of any variable (output of matlab size)
%      RANGE     String of ranges, ex: '1:2:10,10:10:100', '(a,b:c)'
%
%   Output:
%      D   the dimension; -1 if variable is empty; 1 if vector; ...
%          [] if variable do not exist or if there is an error in
%          file
%
%   Requirement:
%      NetCDF interface for Matlab, when not using VARSIZE or RANGE
%
%   Comment:
%      A variable with size = 0 10 10 returns dimension = -1
%
%   Examples:
%      out = n_vararraydim('filename.nc','lon')
%      out = n_vararraydim(size(ones(10,10)));
%      out = n_vararraydim('1:2:10,1:10');
%
%   MMA 7-6-2004, martinho@fis.ua.pt
%
%   See also N_VARSIZE

%   Department of Physics
%   University of Aveiro, Portugal

%   07-02-2005 - Improved

fprintf(1,'\n:: %s is DEPRECATED, use %s instead\n',mfilename,'n_varndims or range_dims');

d  = [];

if nargin == 1 & isstr(file) % then using range
  s = n_varsize(file);
elseif nargin == 2
  s = n_varsize(file,varname);
else
  s = file; % using varsize
end

if isempty(s)
  return
end

if all(s==1)
  d=0;
end

if any(s==0)
  d=-1;
else
  d=length(find(s>1));
end
