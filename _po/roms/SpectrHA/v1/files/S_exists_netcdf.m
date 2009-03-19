function res=S_exists_netcdf
%function res=S_exists_netcdf
%Checks for existence of NetCDF Matlab interface
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

if ~isequal(exist('netcdf'),2)
  errordlg('?? NetCDF not found, install it first !!','missing...','modal');
  res=0;
else
  res=1;
end
  

