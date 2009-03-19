function varargout = cbar(varargin)
%CBAR   Another version of colorbar
%  CBAR is to be used with pcolor or contour. It draws on box per
%   value. If a previous cbar is alerady visible, calling cbar will
%   update the current one.
%
%   Syntax:
%      H = CBAR(VALUES)
%      H = CBAR(AX,VALUES)
%      H = CBAR(VARARGIN)
%
%   Inputs:
%     VALUES   Values to display in colorbar
%     AX   Associated axes
%     VARARGIN:
%       ax, AX
%       values, VALUES
%       cb, some previous colorbar to update
%       mode, 'vertical' (default) or 'horiz'
%       align, {0}, 1, align at bottom/legt, top/right
%       len, colorbar length, 0.6* with or height of AX
%       width,  0.04*  with or height of AX
%       dist, distance from AX,  0.015*Ax width or 0.07*AX height
%       edgecolor, edgecolor of the boxes ('none')
%       parent, parent axes where cbar will be placed
%       lalign, labels align, {0},1,2, 2 means center/middle
%
%   Output:
%      H   Handles for cbar axes, fills, texts
%
%   Examples:
%      figure
%      pcolor(peaks)
%      cbar
%
%      figure
%      pcolor(peaks), caxis([-4 4])
%      cbar([-4:.5:4],'edgecolor','w')
%
%      figure
%      contour(peaks,[-5:5])
%      cbar('values',[-5:5],'mode', 'horiz')
%
%   See also CBARF
%
%   MMA 10-07-2008, mma@odyle.net
%   Dep. Earth Physics, UFBA, Salvador, Bahia, Brasil


Ax=[];
values=[];
cb=[];
mode = 'vertical';
mode_align = 0;
cbar_len   = 0.6;
cbar_width = 0.04;
cbar_dist='auto';
edgeColor='none';
parent=0;
lab_align=1;

vin=varargin;
if nargin==1
  values=vin{1};
elseif nargin==2 & ~isstr(vin{1})
  Ax=vin{1};
  values=vin{2};
end

for i=1:length(vin)
  if     isequal(vin{i},'ax'),    Ax         = vin{i+1};
  elseif isequal(vin{i},'cb'),    cb         = vin{i+1};
  elseif isequal(vin{i},'values'),values     = vin{i+1};
  elseif isequal(vin{i},'mode'),  mode       = vin{i+1};
  elseif isequal(vin{i},'align'), mode_align = vin{i+1};
  elseif isequal(vin{i},'len'),   cbar_len   = vin{i+1};
  elseif isequal(vin{i},'width'), cbar_width = vin{i+1};
  elseif isequal(vin{i},'dist'),  cbar_dist  = vin{i+1};
  elseif isequal(vin{i},'edgecolor'),  edgeColor  = vin{i+1};
  elseif isequal(vin{i},'parent'),parent     = vin{i+1};
  elseif isequal(vin{i},'lalign'),lab_align  = vin{i+1};
  end
end

if strcmpi(cbar_dist,'auto')
  if strcmpi(mode,'vertical')
    cbar_dist  = 0.015;
  else
    cbar_dist  = 0.07;
  end
end

tag='cbar';
fig=gcf;
cb=[];
handles=[];

% if parent, set mode:
if parent
  ppos=get(parent,'position');
  if ppos(4)>=ppos(3)
    mode='vertical';
  else
    mode='horiz';
  end
end

% find Ax and cb:
if isempty(Ax)
  Ax=gca;
end
if isempty(cb)
  ax=get(fig,'children');
  for i=1:length(ax)
    tg=get(ax(i),'tag');
    ud=get(ax(i),'userdata');
    if strcmpi(tg,tag)
      cbAx=ud.Ax;
      if cbAx==Ax, cb=ax(i); break, end
    end
  end
end

% clim and colormap:
clim=get(Ax,'clim');
cmap=get(fig,'colormap');

% find data lims:
ch=get(Ax,'children');
dataMin=nan;
dataMax=nan;
for i=1:length(ch)
  if isprop(ch(i),'CData')
    cdata=get(ch(i),'CData');
    dataMin=min(dataMin,min(cdata(:)));
    dataMax=max(dataMax,max(cdata(:)));
  end
end

axu=get(Ax,'units');
axp=get(Ax,'position');

% calc position of Ax and cb:
L=cbar_width*axp(3);
dL=cbar_dist*axp(3);
if strcmpi(mode,'vertical')
  axp=[axp(1) axp(2) axp(3)-L-dL axp(4)];
  if mode_align==0
    cbp=[axp(1)+axp(3)+dL axp(2) L axp(4)*cbar_len];
  else
    cbp=[axp(1)+axp(3)+dL axp(2)+(1-cbar_len)*axp(4) L axp(4)*cbar_len];
  end
else
  axp=[axp(1) axp(2)+L+dL axp(3) axp(4)-L-dL];
  if mode_align==0
    cbp=[axp(1) axp(2)-L-dL axp(3)*cbar_len L];
  else
    cbp=[axp(1)+(1-cbar_len)* axp(3) axp(2)-L-dL axp(3)*cbar_len L];
  end
end

% create or update colorbar:
newCbar=0;
ud=get(cb,'userdata');
if parent
  if ~isempty(cb), delete(cb); end
  cb=parent;
else
  if isempty(cb)
    cb=axes('units',axu,'position',cbp,'tag',tag);
    newCbar=1;
    ud.mode=mode;
  else
    axes(cb);
    cla;
    ud=get(cb,'userdata'); mode=ud.mode;
  end
end
ud.Ax=Ax;
handles(end+1) = cb;

if newCbar
 set(Ax,'position',axp);
end

% calc values:
if isempty(values)
  [tmp,values,tmp]=genticks(Ax,[0 0],clim);
  dv=values(2)-values(1);
  if values(1)>clim(1),   values=[values(1)-dv values  ]; end
  if values(end)<clim(2), values=[values values(end)+dv]; end
end
n=length(values);
dy=1/(n*20);

% draw boxes and add texts:
x=[0 1 1 0 0];
for i=1:n
  y=[(i-1)/n+dy (i-1)/n+dy i/n-dy i/n-dy]; y(end+1)=y(1);
  cor=caxcolor(values(i),clim,cmap);
  if strcmpi(mode,'vertical')
    handles(end+1) = fill(x,y,cor,'edgecolor',edgeColor); hold on
  else
    handles(end+1) = fill(y,x,cor,'edgecolor',edgeColor); hold on
  end
  val=num2str(values(i));
  if i==1 & values(i)>dataMin
    val=['<=' num2str(values(i))];
  elseif i==n &  values(i)<dataMax
    val=['>=' num2str(values(i))];
  end
  if strcmpi(mode,'vertical')
    if lab_align==1
      handles(end+1) = text(x(2),(y(1)+y(3))/2,[' ' val],'verticalal','cap');
    elseif lab_align==0
      handles(end+1) = text(x(1),(y(1)+y(3))/2,[' ' val],'verticalal','cap','horizontalal','right');
    elseif lab_align==2
      handles(end+1) = text((x(1)+x(2))/2,(y(1)+y(3))/2,[' ' val],'verticalal','cap','horizontalal','center');
    end

  else
    if lab_align==1
      handles(end+1) = text((y(1)+y(3))/2,x(1),[' ' val],'verticalal','top','horizontalal','center');
    elseif lab_align==0
      handles(end+1) = text((y(1)+y(3))/2,x(2),[' ' val],'verticalal','bottom','horizontalal','center');
    elseif lab_align==2
      handles(end+1) = text((y(1)+y(3))/2,(x(1)+x(2))/2,[' ' val],'verticalal','cap','horizontalal','center');
    end
  end
end

ylim([dy 1-dy])
axis off

% axes(Ax); % this makes figure visible to on !! so:
set(fig,'currenta',Ax)

set(cb,'tag',tag,'userdata',ud);

if nargout==1
  varargout{1}=handles;
end
