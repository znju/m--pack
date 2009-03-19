function output = basename(theFile)
%BASENAME   Filename component of path
%   If the input is a folder, the last subfolder is returned
%
%   Syntax:
%      OUT = BASENAME(FILEPATH)
%
%   Input:
%      FILEPATH   Path to file or folder
%
%   Output:
%      Filename component of path if using the path to a file or the
%      last subfolder when using the path to a folder
%
%   Example:
%      basename('../myfolder')                    % returns myfolder
%      basename('/home/user/myfolder')            % returns myfolder
%      basename('/home/user/myfolder/myfile.txt') % returns myfile.txt
%
%   MMA 18-09-2005, martinho@fis.ua.pt
%
%   See also DIRNAME, REALPATH

%   Department of Physics
%   University of Aveiro, Portugal

d = realpath(theFile);
[path,name,ext]=fileparts(d);
output = [name,ext];
