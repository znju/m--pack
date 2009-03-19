function [time,ek]=pom_read_out(f,needle)
%POM_READ_OUT   Extract EK from POM output
%
%   Syntax:
%     [TIME,EK] = POM_READ_OUT(FILE,NEEDLE)
%
%   Inputs:
%      FILE   POM output (text) file
%      NEEDLE   Text part of lines with eke, by default is
%               ' mode,iint,time,elb,ele,ek ='
%
%   Outputs:
%      TIME, EK, columns 3 and 6 of POM output
%
%   Martinho MA (mma@odyle.net) and Janini P (janini@usp.br)
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil
%   01-07-2008

if nargin < 2
  needle=' mode,iint,time,elb,ele,ek =';
end

% nlines for progress:
[status,nlines]=unix(['wc -l ' f]);
nlines=str2num(str_split(nlines,' ',1));

n=0; n0=0;
c=progress('init');

fid=fopen(f);
data=[];
n=0;
nl=0;
data=repmat(nan,[nlines,6]);
while 1
  nl=nl+1;
  c=progress(c,(nl+n0)/nlines);

  tline = fgetl(fid);
  if ~ischar(tline), break, end

  if strmatch(needle,tline)
    n=n+1;
    data(n,:)=str2num(tline(length(needle)+1:end));
  end
end
data(n+1:end,:)=[];
fclose(fid);

time = data(:,3);
ek  = data(:,6);
