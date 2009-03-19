function S2_data

global HANDLES ETC

obj=gco;

x=[];
y=[];
if isprop(obj,'Vertices') | isprop(obj,'XData')
  x=get(obj,'xdata');
  y=get(obj,'ydata');
  x=reshape(x,length(x),1);
  y=reshape(y,length(y),1); 
  x=num2str(x);
  y=num2str(y);
end
if isempty(x) | isempty(y)
  return
end

type=get(gco,'type');
dlgTitle=['Data of ',type];
prompt={'XData','YData'};
def={x,y};
lineNo=10;
AddOpts.Resize='on';
AddOpts.WindowStyle='normal';
AddOpts.Interpreter='tex';
answer=inputdlg(prompt,dlgTitle,lineNo,def,AddOpts);

if isempty(answer)
  return
end

x=answer{1};
y=answer{2};
x=str2num(x);
y=str2num(y);
set(obj,'xdata',x);
set(obj,'ydata',y);



