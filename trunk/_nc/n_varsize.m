function  out = n_varsize(file,varname)
%N_VARSIZE   Get size of a NetCDF variable or range
%
%   Syntax:
%      OUT = N_VARSIZE(FILE,VARNAME)
%      OUT = N_VARSIZE(RANGE)
%
%   Inputs:
%      FILE      NetCDF file
%      VARNAME   Variable
%      RANGE     String of ranges, ex: '1:2:10,10:10:100'
%
%   Output:
%      OUT   The size, or [] if variable do not exist or if there is
%            an error in file
%
%   Requirement:
%      NetCDF interface for Matlab when not using RANGE
%
%   Examples:
%      out = n_varsize('file.nc','lon')
%      out = n_varsize('1:2:10,1:10');
%      range = '(n,m,t)'; % parenthesis are allowed
%      out = n_varsize(range);
%
%   MMA 7-6-2004, martinho@fis.ua.pt
%
%   See also N_VARATT, N_VARDIM

%   Department of Physics
%   University of Aveiro, Portugal

%   07-02-2005 - Improved

out = [];

if nargin == 1 % using range
  % first char may be ( and last, ), so remove them before:
  file(file == ')') = '';
  file(file == '(') = '';
  range=explode(file,',');
  for i=1:length(range)
    ii=num2str(i);
    eval(['s(',ii,')=length(',range{i},');']);
    if str2num(range{i}) <= 0,  s(i) = 0; end
  end
  out=s;
  return
end

if n_varexist(file,varname)
  ncquiet;
  nc=netcdf(file);
  out = size(nc{varname});
  close(nc);
else
  disp(['# variable ',varname,' not found']);
end
