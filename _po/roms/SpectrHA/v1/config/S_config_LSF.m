function tide=S_config_LSF
%function S_config_LSF
%Configuration file for LSF (Least Squares Fit)
%configure:
%          frequencies(periods) to use in LSF
%          colors to use in ellipses, if is the case
%          tidal names, instead of frequencies, if T_TIDE(t_constituents) is installed
%See also S_config_T_TIDE
%
%%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt


global LOOK FSTA

%---------------------------------------------------------------------
% start and end time index
interval=FSTA.interval;
days=3; % start after 3 days
evalc('tide.start_t = round(days*24/interval);','tide.start_t =1');
tide.end_t   = -1; % negative means until the end

%---------------------------------------------------------------------
% freq to use in LSF
names=1;
if exist('t_constituents.mat') ~= 2 & names
    s1='t_constituents.mat not found (can be found in t_tide package), using periods...';
    s2='check S_config_LSF';
    errordlg(strvcat(s1,s2),'missing...','modal');
    names=0;
end

if names
  tide.const=['M2  ';    % 1
              'S2  ';    % 2
              'N2  ';    % 3
              'K2  ';    % 4
              'K1  ';    % 5
              'O1  ';    % 6
              'P1  ';    % 7  
              'Q1  '];   % 8
else
  tide.const=[12.42060;  % 1
              12.00000;  % 2
              12.65834;  % 3
              11.96723;  % 4
              23.93446;  % 5
              25.81934;  % 6
              24.06589;  % 7
              26.86835]; % 8
end

%            r g b
tide.colors=[1 0 0;      % 1
             0 0 1;      % 2  
             0 0 1;      % 3 
             0 0 1;      % 4
             0 0 0;      % 5
             0 0 1;      % 6
             0 0 1;      % 7
             0 0 1];     % 8
        
%---------------------------------------------------------------------
% verify names and colors:
const=size(tide.const,1);      
colors=size(tide.colors,1);

err=0;
if names  
  for i=1:const
    if isnan(name2freq(tide.const(i,:)))
      err=1;
      I=i;
    end
  end
end

if colors < const
  for i=colors+1:const
%    tide.colors(i,:)=tide.colors(colors,:); % use last one !!
     tide.colors(i,:)=LOOK.defaultEllipseColor; % use default !!
  end
end

if err
  tide=['tide const error, view S_config_LSF, i= ', int2str(I)];
end

return

