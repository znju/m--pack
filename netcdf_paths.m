function p=netcdf_path(base,addp)
%NETCDF_PATH   Paths of the netcdf interface
%   Returns all the paths of the NetCDF interface, according to the
%   user OS and matlab version.
%
%   Syntax:
%      PATHS = NETCDF_PATHS(BASE,ADD)
%
%   Input:
%      BASE   Path basename
%      ADD    Add to path flag, dafault=1
%
%   Output:
%      PATHS   Cell array with the paths of the NetCDF interface
%
%   MMA 18-6-2007, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

p={};

if nargin ==0
  [base,f] = fileparts(which(mfilename));
end
if nargin<2
  addp=1;
end

sep=filesep;

base_mex  = 'mexnc_mex';
base_mexc = 'mexnc_common';
base_nc   = ['netcdf_toolbox',sep,'netcdf'];
base_snc  = '.';

release = rver;
os      = computer;
is64    = str2num(os(end-1:end))==64;
isUnix  = ~(strcmp(os,'PCWIN') | strcmp(os,'PCWIN64'));

% mex files paths:
if isUnix
  if release>=2006.2 & is64
    pmex = 'glx64_R2006b';
  elseif release>=14 & is64
    pmex = 'glx64_R14';
  elseif release>=13
    pmex = 'glx32_R13';
  elseif release>=6
    pmex ='glx32_v6';
  elseif release>=5
    pmex = 'glx32_v5';
  else
    disp([':: ',mfilename,' : no mex file for your matlab/os']);
    return
  end
else
  pmex='pcwin';
end
pmex={base_mexc,[base_mex,sep,pmex]};


% netcdf toolbox path:
pnc = {
  [base_nc],
  [base_nc,sep,'ncsource'],
  [base_nc,sep,'nctype'],
  [base_nc,sep,'ncutility']
};

% snc tools path
psnc = [base_snc,sep,'snctools'];

p={pmex{:},pnc{:},psnc};

for i=1:length(p)
  p{i}=[base,sep,p{i}];
end

% --------------------------------------------------------------------
% add to path:

if addp
  for i=1:length(p)
    addpath(p{i})
   end

  % check if need to copy dlls, in case of pcwin:
  if (isempty(which('mexcdf')) | isempty(which('mexcdf53'))) & ~isUnix & release <14
    if release >=12
      dllFolder = [matlabroot,filesep,'bin',filesep,'win32'];
    else
      dllFolder = [matlabroot,filesep,'bin'];
    end
    dllFiles = {'netcdf.dll','mexcdf53.dll'};
    for i=1:length(dllFiles)
      theSource = [dirs_netcdf{end},filesep,dllFiles{i}];
      if ~exist([dllFolder,filesep,dllFiles{i}])
        try
          copyfile(theSource,dllFolder);
        catch
          disp([':: ',mfilename,' : unable to copy ',theSource,' to ',dllFolder]);
        end
      end
    end
  end

end


function r = rver
%RVER   Matlab release number
%   Returns the matlab release number (# from the version string R#).
%   For Releases with version R#, # is returned, for the case Ryyyx,
%   returned yyyy.n, where n is the character indice (for a is 1).
%
%   Examples:
%      % R14:
%      rever %--> 14
%      % R2006b
%      rver %--> 2006.2
%
%   MMA 27-9-2005, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

%   18-05-2007 - Deal with cases like R2006x

v=version;
ir=find(v=='R');
ie=find(v==')');
r=str2num(v(ir+1:ie-1));

if isempty(r)
  r=v(ir+1:ie-1);
  r=str2num(r(1:end-1))+ (double(r(end))-double('a')+1)/10;
end
