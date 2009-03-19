function range=N_getRange(i)
%N_getRange
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% returns range string of dimension i

global H

if i==1, I='i'; elseif i==2, I='j'; elseif i==3, I='k'; elseif i==4, I='l'; end
i=num2str(i);

eval(['i1 = get(H.dim',i,',''string'');']);
eval(['i2 = get(H.dim',i,'e,''string'');']);
eval(['stepi = get(H.step',I,',''string'');']);

range = [i1,':',stepi,':',i2];
