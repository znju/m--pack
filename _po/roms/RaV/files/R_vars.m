function [varname,scale,offset] = R_vars(file,variable)
%function [varname,scale,offset] = R_vars(file,variable)
%R_vars
%   This function was created cos some french guys
%   decided to use some pesonalized variables in
%   ROMS NetCDF files...
%   So, let me generalize....
%   MMA 29-11-2004, late at night with a woman waiting in the bed

global H

varname = '';
scale = [];
offset = [];

if nargin < 2
   return
end

% ---------------------------------------------------------
% time
% ----------------------------------------------------------
if isequal(variable,'time')
   % search for ocean_time or scrum_time
   time1  = 'ocean_time';
   scale1  = 1; % sec
   offset1 = 0; % no offset
   
   time2  = 'scrum_time';
   scale2  = 1;
   offset2 = 0; % no offset  
   
   if n_varexist(file,time1)
      varname = time1;
      scale   = scale1;
      offset  = offset1;
   elseif n_varexist(file,time2)
      varname = time2;
      scale   = scale2;
      offset  = offset2;
   end
end

   
