function S_check_displace(in)
%function S_check_displace(in)
%check if should displace phases when using t_tide
%([SpectrHA]->phases t_tide)
%if not, a start_time should be used in t_tide (see menu:S_config_T_TIDE)
%input: in, 'start', or 'default'
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global MENU

set(MENU.phases_atCenter,'checked','off');
set(MENU.phases_atStart,'checked','off');

if isequal(in,'start')
  set(MENU.phases_atStart,'checked','on');
elseif isequal(in,'default')
  set(MENU.phases_atCenter,'checked','on');
end
