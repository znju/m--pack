function out=n_indnear(fname,var,data,isLon)
%N_INDNEAR   Index of nearest point from NetCDF variable
%
%   Syntax:
%      I = N_INDNEAR(FNAME,VNAME,DATA,ISLON)
%
%   Inputs:
%      FNAME   NetCDF file
%      VNAME   Variable (1,2,3-D)
%      DATA    1-D array of data to find nearest
%      ISLON   If 1, VNAME is considered a longitude and for values
%              higher than 180, 360 is subtracted
%
%   Outputs:
%      I   Array of index
%
%
%   MMA 13-06-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil

if nargin < 4, isLon=0; end

v=use(fname,var);
if isLon
  i=v>180;
  v(i)=v(i)-360;
end

nDims=ndims(v);
if prod(size(v))==length(v), nDims=1; end

out=[];
for i=1:length(data)
 d=(v-data(i)).^2;
 j=find(d==min(d(:))); j=j(1);
 if nDims==1
    out(i)=j;
  elseif nDims==2
    [j1,j2]=ind2sub(size(v),j);
    out(i,:)=[j1 j2];
  elseif nDims==3
    [j1,j2,j3]=ind2sub(size(v),j);
    out(i,:)=[j1 j2 j3];
  end
end
