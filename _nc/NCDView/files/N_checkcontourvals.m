function N_checkcontourvals
%N_checkcontourvals
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% validates edited contour values

global H

vals=get(H.contourvals,'string');
v=str2num(vals);

if isnumber(v,-1)
  if length(v) > 1
    % first remove old ] and [:
    vals=strrep(vals,']','');
    vals=strrep(vals,'[',''); 
    set(H.contourvals,'string',['[',vals,']']);
  end
else
  set(H.contourvals,'string','5');
end
