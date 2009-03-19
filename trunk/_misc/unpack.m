function varargout = unpack(varargin)
%UNPACK   Unpack list to variables
%   Allows attribution of a lista of data to variables in a single
%   line.
%
%   Syntax:
%      VARARGOUT = UNPACK(VARARGIN)
%
%   Input:
%      VARARGIN   List of variables or data vector or cell array
%
%   Output:
%      VARARGOUT   Required number of variables to unpack
%
%   Example:
%      [a,b,c,d]=unpack(1,2,3,'hello');
%      [a,b,c]=unpack([1,2,3]);
%      [a,b,c,d]=unpack({1,2,3,'hello'});
%
%   MMA 31-5-2005, martinho@fis.ua.pt

% Department of Physics
% University of Aveiro, Portugal

if length(varargin)==1
  vin=varargin{:};
  if iscell(vin)
    for i=1:length(vin), varargout{i}=vin{i}; end
  else
    for i=1:length(vin), varargout{i}=vin(i); end
  end
else
  for i=1:length(varargin), varargout{i}=varargin{i}; end
end

nout=length(varargout);
if nargout<nout
  error(':: too many values to unpack');
elseif nargout>nout
  if nout==1, word='value', else word='values'; end
  error([':: need more than ',num2str(nout),' ',word,' to unpack']);
end
