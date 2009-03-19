function result = ispc
%ISPC True for the PC (Windows) version of MATLAB.
%   ISPC returns 1 for PC (Windows) versions of MATLAB and 0 otherwise.

%   Copyright 1984-2002 The MathWorks, Inc. 
%   $Revision: 1.4 $  $Date: 2002/04/08 20:51:21 $

result = strncmp(computer,'PC',2);
