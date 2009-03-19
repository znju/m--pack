function v = nd2v(m)
%ND2V   N-D array to vector
%   Reshapes N-D array to 1-D.
%
%   Syntax:
%     V = ND2V(ND)
%
%   Input:
%      ND   N-D array
%
%   Output:
%      V   1-D array with all the elements of ND
%
%   MMA 27-9-2005, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal

v = reshape(m,1,prod(size(m)));
