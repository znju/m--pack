function str = N_sliceLabel(fname,varname,range)
%N_sliceLabel
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% Added 20-9 2004
% retrieves slice information, specially time information;
% bust still unfinished... there is a bug in date calculation ?!

slice=[];
dims  = n_vardims(fname,varname);
sz    = n_varsize(fname,varname);

C = 'IJKL';

for i=1:length(dims.name)


  [tmp,ds]=range_dims(range{i});
  if ds ==1 & sz(i) ~=1
    % get units:
    value = str2num(range{i});

    if n_varexist(fname,dims.name{i})
      sunits = [];
      if n_varattexist(fname,dims.name{i},'units');
        sunits = n_varatt(fname,dims.name{i},'units');
      end
    end

    % deal with dates:

    if n_varexist(fname,dims.name{i}) & n_varndims(fname,dims.name{i}) == 1 & ~isempty(findstr(lower(sunits),'since'))
      valdim = use(fname,dims.name{i});
      Tvalue  = valdim(value);

      is = findstr(lower(sunits),'since');
      strtype = sunits(1:is(1));
      eval('strdate = sunits(is(end)+5:end);','strdate=[];');
      if ~isempty(strdate)
        strdate = strrep(strdate,'-',' ');
        strdate = strrep(strdate,':',' ');
        strdate = strrep(strdate,'/',' ');
        strdate = strrep(strdate,'\',' ');
        strdate = str2num(strdate);  strdate0 =  strdate;

        if strmatch('year',lower(strtype)),                                     eval('strdate(1) = strdate(1) + Tvalue;',''); end
        if strmatch('month',lower(strtype)),                                    eval('strdate(2) = strdate(2) + Tvalue;',''); end
        if strmatch('day',lower(strtype)),                                      eval('strdate(3) = strdate(3) + Tvalue;',''); end
        if strmatch('hour',lower(strtype)),                                     eval('strdate(4) = strdate(4) + Tvalue;',''); end
        if strmatch('min',lower(strtype)) | strmatch('minute',lower(strtype)),  eval('strdate(5) = strdate(5) + Tvalue;',''); end
        if strmatch('sec',lower(strtype)) | strmatch('second',lower(strtype)),  eval('strdate(6) = strdate(6) + Tvalue;',''); end

        thedate = datestr(datenum(strdate),0);

        %????????????? NCEP files    ???????????
        if strdate0==[1 1 1  0 0 0] & strmatch('hour',lower(strtype))
           dr=datenum(Tvalue/24);
           year   = datestr(dr,'yyyy');     % day
           month  = datestr(dr,'mm');       % month
           day    = datestr(dr,'dd');       % day
           hms    = datestr(dr,'HH:MM:SS'); % hours, minutes, seconds
           hms=strrep(hms,':',' ');
           hms=str2num(hms);
           h=hms(1);
           m=hms(2);
           s=hms(3);
           year   = str2num(year)+1;
           month  = str2num(month);
           day    = str2num(day);
           nrange = datenum(year,month,day,h,m,s);
           thedate = datestr(nrange,0);
         end
         %% ???????????????????????????????????????????????????

        slice = [slice,', ',dims.name{i},' = ',thedate];
      else
        slice = [slice,', ',dims.name{i},' = ',num2str(value),' ',sunits];
      end

    else
      slice = [slice,', ',C(i),' = ',num2str(value)];
    end

  end
end
str = slice(2:end);
