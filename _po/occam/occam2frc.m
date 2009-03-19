function occam2frc(files,grd,frc,time,varargin)
%function occam2frc(files,grd,frc,time,varargin)
%under cosntruction.... only for wind stress currently !!
%
% 18-6-2008

title   = 'Roms frc file';
clobber = 'clobber'; % not used by current create_forcing
cycle   = 365;
newfrc  = 1;
quiet   = 0;

vin=varargin;
for i=1:length(vin)
  if     isequal(vin{i},'title'),    tit     = vin{i+1};
  elseif isequal(vin{i},'clobber'),  clobber = vin{i+1};
  elseif isequal(vin{i},'cycle'),    cycle   = vin{i+1};
  elseif isequal(vin{i},'newfrc'),   newfrc  = vin{i+1};
  elseif isequal(vin{i},'quiet'),    quiet   = vin{i+1};
  end
end


% create frc file:
if newfrc
  if ~quiet
    fprintf(1,'  > creating frc file %s\n',frc)
  end
  smst=time; smsc=cycle;
  shft=time; shfc=cycle;
  swft=time; swfc=cycle;
  srft=time; srfc=cycle;
  sstt=time; sstc=cycle;
  ssst=time; sssc=cycle;
  create_forcing(frc,grd,title,...
                 smst,shft,swft,srft,sstt,ssst,...
                 smsc,shfc,swfc,srfc,sstc,sssc);
end

% extract data from occam:
for i=1:length(files)
  fname=files{i};
  if ~quiet
    fprintf(1,'  - extracting data from occam, file %d of %d - %s\n',i,length(files),basename(fname))
  end
  [sustr,svstr] = occam2frc_vars(fname,grd,varargin{:});

  % fill frc file:
  if ~quiet
    fprintf(1,'  > filling frc file\n');
  end
  nc=netcdf(frc,'w');
  nc{'sustr'}(i,:,:,:)    = sustr;
  nc{'svstr'}(i,:,:,:)    = svstr;
  close(nc)
end
