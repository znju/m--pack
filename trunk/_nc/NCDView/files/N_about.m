function N_about
%N_about
%   is part of NCDView (Matlab GUI for NetCDF visualization)
%
%    MMA 6-2004, martinho@fis.ua.pt
%
%   See also NCDV

% shows about message box

global H

Message={
  'NCDView  -  NetCDF Visualization Utility',
  '',
  'version 1.1, Sep-2004',
  '',
  'Created by:'
  'Martinho Marta Almeida',
  'Physics Department',
  'Aveiro University'
  'Portugal',
  '',
  'http://neptuno.fis.ua.pt/~mma/NCDView',
  'martinho@fis.ua.pt'
};
Title='NCDView, about';
mb=msgbox(Message,Title,'help','modal');



%------------------------ colors:

evalc('set(mb,''color'',H.theme.framebg)','');

% text:
evalc('g=get(mb,''children'');','');
evalc('f=allchild(g(2));','');
evalc('set(f(5),''color'',H.theme.editfg);','');

% button:
evalc('set(g(3),''backgroundcolor'',H.theme.pushbg,''foregroundcolor'',H.theme.pushfg);','');
