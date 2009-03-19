function mat_tex(m,varargin)
%MAT_TEX   Create latex table with matlab matrice
%   Creates a ps file through latex from a matlab 2D array.
%   Nans are not shown.
%
%   Syntax:
%      MAT_TEX(M,VARARGIN)
%
%   Inputs:
%      M   2D array
%      VARARGIN:
%         'col1', [ str ], fist column, cell array
%         'line1', [ str ], fist line, cell array
%         'str', [ str ], table caption
%         'ps', [ str ], name of output ps file
%         'pdf', [ str ], name of output pdf file
%         'hlc', highlight colors, {rgb1,rgb2, ...}
%         'hlv', highlight values, {'>123', '==0',...}
%         'format', fprintf numbers format {'2.2f'}
%
%   Comment:
%      If M (and caption) are cell arrays, several tables can be
%      created in one document.
%
%   Requirements:
%      The executables latex, dvips or dvipdf and gv
%
%   Examples:
%      m     = [1 2; 3 4];
%      line1 = {'first col','second col'};
%      col1  = {'first line','second line'};
%      str   = 'this is the table caption';
%      ps    = 'my_psfile.ps';
%      mat_tex(m,'line1',line1,'col1',col1,'str',str,'ps',ps)
%
%      % or something more simple:
%      m = rand(10);
%      mat_tex(a,'str','simple example')
%
%   MMA 2004, martinho@fis.ua.pt

%   Department of Physics
%   University of Aveiro, Portugal
%
%   8-2007 - Added options pdf, highlight and format

lines   = [];
cols    = [];
psname  = [];
pdfname  = [];
caption = [];
hlc = {};
hlv = {};
format='2.2f';

str = datestr(now,0);
str(str==' ') = '_';
str(str=='-') = '_';
str(str==':') = '_';
ftex    = ['temp_',str,'.tex'];

vin = varargin;
for i=1:length(vin)
  if isequal(vin{i},'line1')
    cols = vin{i+1};
  end
  if isequal(vin{i},'col1')
    lines = vin{i+1};
  end
  if isequal(vin{i},'ps')
    psname = vin{i+1};
  end
  if isequal(vin{i},'pdf')
    pdfname = vin{i+1};
  end
  if isequal(vin{i},'str')
    caption = vin{i+1};
  end
  if isequal(vin{i},'hlc')
    hlc=vin{i+1};
  end
  if isequal(vin{i},'hlv')
    hlv=vin{i+1};
  end
  if isequal(vin{i},'format')
    format=vin{i+1};
  end
end

% create tex file:
fid=fopen(ftex,'w');
fprintf(fid,'%s\n','\documentclass{article}');

fprintf(fid,'%s\n','\pagestyle{empty}');
fprintf(fid,'%s\n','\setlength{\parindent}{0mm}');
fprintf(fid,'%s\n','\setlength{\parskip}{0mm}');
fprintf(fid,'%s\n','\setlength{\textwidth}{180mm}');
fprintf(fid,'%s\n','\setlength{\textheight}{240mm}');
fprintf(fid,'%s\n','\setlength{\hoffset}{-1.5in}');
fprintf(fid,'%s\n','\setlength{\voffset}{-1in}');

gen_highlight_colors(fid,hlc,hlv);
fprintf(fid,'%s\n','\begin{document}');

if iscell(m)
  for i=1:length(m)
    M=m{i};
    try
      capt = caption{i};
    catch
      capt=caption;
    end
    insert_table(fid,M,lines,cols,format,hlc,hlv,capt)
  end

else
  insert_table(fid,m,lines,cols,format,hlc,hlv,caption)
end

fprintf(fid,'%s\n','\end{document}');
fclose(fid);

% run Latex and create ps/pdf:
fdvi = [ftex(1:end-3),'dvi'];
fps  = [ftex(1:end-3),'ps'];
faux = [ftex(1:end-3),'aux'];
flog = [ftex(1:end-3),'log'];
fpdf = [ftex(1:end-3),'pdf'];
if isempty(psname),  psname  = fps;  end
[status,result]=system(['! latex -interaction=batchmode ',ftex]);
if exist(fdvi,'file')==2
  if isempty(pdfname)
    eval(['! dvips ',fdvi,' -o ',psname]);
  else
    eval(['! dvipdf ',fdvi,' ',pdfname]);
  end
  eval(['delete ',faux],'');
  eval(['delete ',flog],'');
  eval(['delete ',fdvi],'');
  if isequal(computer,'PCWIN')
    if isempty(pdfname), eval(['! ',psname]);
    else eval(['! ',pdfname]);
    end
  else
    if isempty(pdfname), eval(['! gv ',psname],'');
    else eval(['! acroread ',pdfname,' &'],'');
    end
  end
else
  fprintf(1,'\n:: latex not executed !!\n');  
end
eval(['delete ',ftex ],'');


function insert_table(fid,m,lines,cols,format,hlc,hlv,caption)
ncols=size(m,2);
col1  = ~isempty(lines);
line1 = ~isempty(cols);

cstr    = '|';
if col1
  cstr = '|r||';
end

for j=1:ncols
  cstr=[cstr 'c|'];
end

fprintf(fid,'%s\n','\begin{table}');
fprintf(fid,'%s\n','\centering');
fprintf(fid,'%s\n',['\begin{tabular}{',cstr,'}']);
fprintf(fid,'%s\n','\hline');

if line1
  fprintf(fid,'%s & ','$\spadesuit \diamondsuit \clubsuit \heartsuit$ ');
  for j=1:size(m,2)-1
    fprintf(fid,'%s & ',cols{j});
  end
  fprintf(fid,'%s %s\n',cols{end},'\\');
  fprintf(fid,'%s\n','\hline\hline');
end

for i=1:size(m,1)
  if col1
    fprintf(fid,'%s & ',lines{i});
  end
  for j=1:size(m,2)-1
    s=deal_highlight(m(i,j),hlc,hlv);
    if isnan(m(i,j))
      fprintf(fid,'&');
    else
      fprintf(fid,['%s%',format,' %s\n'],s,m(i,j),'& ');
    end
  end
  s=deal_highlight(m(i,end),hlc,hlv);
  if isnan(m(i,end))
    fprintf(fid,'&');
  else
    fprintf(fid,['%s%',format,' %s\n'],s,m(i,end),'\\');
  end
  fprintf(fid,'%s\n','\hline');
end

fprintf(fid,'%s\n','\end{tabular}');
fprintf(fid,'%s\n',['\caption{',caption,'}']);
fprintf(fid,'%s\n','\end{table}');



function gen_highlight_colors(fid,hlc,hlv)
if isempty(hlv)
  return
end

defaultColors={[.75 1 .75],[1 .75 .75],[.75 .75 1],[.9 .9 .9]};

if isempty(hlc)
  for i=1:length(hlv)
    if i<=length(defaultColors)
      hlc{i}=defaultColors{i};
    else
      hlc{i}=defaultColors{end};
    end
  end
end

fprintf(fid,'%s\n','\usepackage{color}');
fprintf(fid,'%s\n','\usepackage{colortbl}');
for i=1:length(hlc)
  cor = sprintf('%g,%g,%g',hlc{i});
  nome = ['cor_',num2str(i)];
  fprintf(fid,'%s%s%s%s%s\n','\definecolor{',nome,'}{rgb}{',cor,'}');
end


function  s=deal_highlight(v,hlc,hlv)
s='';
if isempty(hlv)
  return
end

for i=1:length(hlv)
  nome = ['cor_',num2str(i)];
  cond=hlv{i};
  if eval([num2str(v),cond])
    s=['\cellcolor{',nome,'}'];
  end
end

