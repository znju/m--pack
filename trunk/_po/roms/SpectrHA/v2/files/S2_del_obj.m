function S2_del_obj
% NOT IN USE NOT IN USE

% del last plotted obj:

global ETC

if ishandle(ETC.obj.line)
  delete(ETC.obj.line);
end

if ~isempty(ETC.obj.leg)
  ETC.obj.leg(end,:)='';
end

if ishandle(ETC.obj.marker1)
  delete(ETC.obj.marker1);
end

if ishandle(ETC.obj.marker2)
  delete(ETC.obj.marker2);
end

if ishandle(ETC.obj.marker3)
  delete(ETC.obj.marker3);
end
