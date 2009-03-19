function R_mmore(what)

global H

% --------------------------------------------------------------------
% contour vals 1 and 2
% --------------------------------------------------------------------
contourvals1 = H.ROMS.his.morecvals1;
contourvals2 = H.ROMS.his.morecvals2;

def1='5';
def2=[];

if isequal(what,'ctvals1')
  vals=get(contourvals1,'string');
  v=str2num(vals);
  if isnumber(v,-1)
    if length(v) > 1
      % first remove old ] and [:
      vals=strrep(vals,']','');
      vals=strrep(vals,'[',''); 
      set(contourvals1,'string',['[',vals,']']);
    end
  else
    set(contourvals1,'string',def1);
  end
end


if isequal(what,'ctvals2')
  vals=get(contourvals2,'string');
  v=str2num(vals);
  if isnumber(v,-1)
    if length(v) > 1
      % first remove old ] and [:
      vals=strrep(vals,']','');
      vals=strrep(vals,'[','');
      set(contourvals2,'string',['[',vals,']']);
    end
  else
    set(contourvals2,'string',def2);
  end
end

% --------------------------------------------------------------------
% lineStyle vals 1 and 2
% --------------------------------------------------------------------
% NEXT is no longr used, so:
% line1  = H.ROMS.his.moreline1;
% line2  = H.ROMS.his.moreline2;
% line1s = get(line1,'string');
% line2s = get(line2,'string');
% def1   = '-';
% def2   = '--';
% opts={'-','--','-.',':'};
% 
% if isequal(what,'line1')
%   if ~ismember(line1s,opts)
%     set(line1,'string',def1);
%   end
% end
% 
% if isequal(what,'line2')
%   if ~ismember(line2s,opts)
%     set(line2,'string',def2);
%   end
% end

% --------------------------------------------------------------------
% lineWidth vals 1 and 2
% --------------------------------------------------------------------
% NEXT is no longr used, so:
% line1  = H.ROMS.his.morelinew1;
% line2  = H.ROMS.his.morelinew2;
% line1s = get(line1,'string');
% line2s = get(line2,'string');
% def1   = 2;
% def2   = 1;
% if isequal(what,'linew1')
%   if ~isnumber(str2num(line1s),1)
%     set(line1,'string',def1);
%   end
% end
% if isequal(what,'linew2')
%   if ~isnumber(str2num(line2s),1)
%     set(line2,'string',def2);
%   end
% end

% --------------------------------------------------------------------
% lineColor vals 1 and 2  ........  and for bathymetry
% --------------------------------------------------------------------
thehandle1 = H.ROMS.his.morelinec1;
thehandle2 = H.ROMS.his.morelinec2;
thehandle3 = H.ROMS.his.morebathyc;
thehandle4 = H.ROMS.his.moremaskc;


if isequal(what,'linec1')
  color=get(thehandle1,'backgroundcolor');
  color = uisetcolor(color);
  set(thehandle1,'backgroundcolor',color);
end
if isequal(what,'linec2')
  color=get(thehandle2,'backgroundcolor');
  color = uisetcolor(color);
  set(thehandle2,'backgroundcolor',color);
end
if isequal(what,'bathycolor')
  color=get(thehandle3,'backgroundcolor');
  color = uisetcolor(color);
  set(thehandle3,'backgroundcolor',color);
end
if isequal(what,'maskcolor')
  color=get(thehandle4,'backgroundcolor');
  color = uisetcolor(color);
  set(thehandle4,'backgroundcolor',color);
end


% --------------------------------------------------------------------
% check edited scale1 and 2
% --------------------------------------------------------------------
if isequal(what,'scale2') % may have length 1, 2 or 3(for arrows, u and v (and w if 3d))
  handle_scale2 = H.ROMS.his.morescale2;
  scale2 = str2num(get(handle_scale2,'string'));
  if ~(isnumber(scale2,1) | isnumber(scale2,2) | isnumber(scale2,3))
    set(handle_scale2,'string',1);
  end
end

if isequal(what,'scale1') % may only have length 1
  handle_scale1 = H.ROMS.his.morescale1;
  scale1 = str2num(get(handle_scale1,'string'));
  if ~isnumber(scale1,1)
    set(handle_scale1,'string',1);
  end
end

% --------------------------------------------------------------------
% clabel 1 and 2 for overlay variable
% --------------------------------------------------------------------

if  isequal(what,'clabel1') |  isequal(what,'clabel2')
  % need to find last figure:
  figs    = get(0,'children');
  outputs = findobj(figs,'tag','rcdv_output');
  if isempty(outputs)
    last = [];
  else
    last = outputs(1);
  end
end

if isequal(what,'clabel1') &  ~isempty(last)
  figure(last);
  evalc('Cs21 = H.ROMS.his.cs21;','Cs21=[];');   % contour cs vals (from [cs,ch]=contour...)
  if isstr(Cs21)
    eval(Cs21,'');
  else
    if ~isempty(Cs21), clabel(Cs21,'manual'),  end
  end
end

if isequal(what,'clabel2') &  ~isempty(last)
  figure(last);
  evalc('Cs22 = H.ROMS.his.cs22;','Cs22=[];');
  if isstr(Cs22)
    eval(Cs22,'');
  else
    if ~isempty(Cs22), clabel(Cs22,'manual'),  end
  end
end
