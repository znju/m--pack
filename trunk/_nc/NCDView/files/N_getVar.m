function v = N_getVar(fname,varname,range_I,range_J,range_K,range_L)
%N_getVar
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% returns variable

global H

% check if files and vars loaded:
if isequal(varname,'varname')
  v=[];
  return
end


if nargin == 2
  % get range:

  range_I=N_getRange(1);
  range_J=N_getRange(2);
  range_K=N_getRange(3);
  range_L=N_getRange(4);

elseif nargin == 3
  % to use in X and Y (N_setxy) 
  range=strrep(range_I,'(','');
  range=strrep(range,')','');
  range=explode(range,',');

  evalc('range_I = range{1}','range_I=''1:1:1'';');
  evalc('range_J = range{2}','range_J=''1:1:1'';');
  evalc('range_K = range{3}','range_K=''1:1:1'';');
  evalc('range_L = range{4}','range_L=''1:1:1'';');
end

% load if number of dims = 1 or 2
range=[range_I,',',range_J,',',range_K,',',range_L];
[n,tmp] = range_dims(range);

if n > 2
  v=[];
  return
end

%-------------------- dealing with big vars:
% let me not load vars bigger then... 300x300, or at least ask the user:
evalc('sizeMax=H.maxvarsize;','sizeMax=300*300;');
[tmp,s]=range_dims(range);
if prod(s) > sizeMax
  question = 'var size is quite big! wanna procced?';
  size_str = sprintf('[  %g  x  %g  x  %g  x  %g  ] = %g',s,prod(s));
  current  = ['current size max = ',num2str(sizeMax)];
  change   = 'change this in menu MISC --> MAX VAR SIZE';
  question={question,size_str,current,change};
  title='';
  answer=questdlg(question,title,'yes','no','no');
  if isequal(answer,'no')
    v=[];
    return
  end
end

% -------------------------------------------

nc=netcdf(fname);
  str=['v=nc{''',varname,'''}(',range_I,',',range_J,',',range_K,',',range_L,');'];
  %disp(['# request: ',str]);
  error_str=['disp([''# error in the request: ',str,''']);'];
  evalc(str,error_str);
nc=close(nc);
