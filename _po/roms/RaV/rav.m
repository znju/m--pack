function rav
%ROMS Visualisation GUI
%
%   requirements:
%     M_PACK
%
%  THIS IS ABSOLUTELY TEMPORARY TOOL, UNFINISHED TOOL
%
%   MMA 8-2004, martinho@fis.ua.pt
%   12-2004: work under M_PACK
%
%   See also M_PACK, SPECTRHA2

%   Department of Physics
%   University of Aveiro, Portugal

if 0
  disp(' ');
  disp('-------------------------------------------------------------');
  disp('**                                                         **');
  disp('**                           RAV                           **');
  disp('**                 ROMS VISUALISATION TOOL                 **');
  disp('**                                                         **');
  disp('**   WARNING -- WARNING -- WARNING -- WARNING -- WARNING   **');
  disp('**        THIS  AN ABSOLUTELY TEMPORARY VERSION            **');
  disp('**                                                         **');
  disp('**       MANY BUGS ARE FOR SURE PRESENT, SO YOU ARE        **');
  disp('**         TOTALLY RESPONSIBLE FOR THE USE OF RAV          **');
  disp('**                                                         **');
  disp('**   RAV is a creation of MMA, August-2004                 **');
  disp('**   and may never be finnished... !!                      **');
  disp('**   Martinho Mmarta Almeida                               **');
  disp('**   Phys. Dep., Aveiro Univ., Portugal                    **');
  disp('**   any question, use martinho@fis.ua.pt                  **');
  disp('**   (while this email works...)                           **');
  disp('**                                                         **');
  disp('**   RAV requires many other matlab functions available    **');
  disp('**   at http://neptuno.fis.ua.pt/~mma/m_files              **');
  disp('**   It also requires NCDV, NetCDF files visualization     **');
  disp('**   tool available at                                     **');
  disp('**   http://neptuno.fis.ua.pt/~mma/NCDView                 **');
  disp('**   RAV files must be in path above NCDView cos some      **');
  disp('**   files have been modified                              **');
  disp('**                                                         **');
  disp('**   Good luck                                             **');
  disp('**   MMA                                                   **');
  disp('-------------------------------------------------------------');
  disp(' ');
end


% first check is there is ncdv or rav already openned;
obj  = findobj(0,'name','NCDView');
obj2 = findobj(0,'name','RAV');
obj = [obj obj2];

if ~isempty(obj)
  question = 'It seems you have NCDView openned... ! wanna procced?';
  title='';
  answer=questdlg(question,title,'yes','no','no');
  if isequal(answer,'no')
    return
  end
end


% --------------------------------------------------------------------
% figure
% --------------------------------------------------------------------
clear global  H
global H
H.fig=figure;
set(H.fig,'units','normalized','NumberTitle','off','Name','RAV','MenuBar','none');
set(H.fig,'closerequestfcn','R_exit');

% --------------------------------------------------------------------
% menus
% --------------------------------------------------------------------
H.menu_file     = uimenu(H.fig,            'label','NCDV');
H.menu_load     = uimenu(H.menu_file,      'label','load',        'callback','N_load'                                         );
H.menu_files    = uimenu(H.menu_file,      'label','files',       'callback',''                                               );
H.menu_files0   = uimenu(H.menu_files,     'label','none',        'callback',''                                               );
H.menu_toolbar  = uimenu(H.menu_file,      'label','fig menus',   'callback','N_figtoolbar', 'checked','off','separator','on' );
H.menu_restart  = uimenu(H.menu_file,      'label','restart',     'callback','close, rav',   'Separator','on'                 );
%------------- Add #####################
H.menu_rcdv     = uimenu(H.menu_file,      'label','ncdv',        'callback','R_roms(''stop'')'                               );
%------------ Add, end ################
H.menu_exit     = uimenu(H.menu_file,      'label','exit',        'callback','R_exit',       'Separator','off'                );

H.menu_ED       = uimenu(H.fig,            'label','<E-D>',             'visible','off');
H.menu_ED_      = uimenu(H.menu_ED,        'label','-empty vars-',      'visible','off');

H.menu_0D       = uimenu(H.fig,            'label','<0-D>',             'visible','off');
H.menu_0D_      = uimenu(H.menu_0D,        'label','-all unit vars-',   'visible','off');

H.menu_1D       = uimenu(H.fig,            'label','<1-D>',             'visible','off');
H.menu_1D_      = uimenu(H.menu_1D,        'label','-all 1-D vars-',    'visible','off');

H.menu_2D       = uimenu(H.fig,            'label','<2-D>',             'visible','off');
H.menu_2D_      = uimenu(H.menu_2D,        'label','-all 2-D vars-',    'visible','off');

H.menu_3D       = uimenu(H.fig,            'label','<3-D>',             'visible','off');
H.menu_3D_      = uimenu(H.menu_3D,        'label','-all 3-D vars-',    'visible','off');

H.menu_4D       = uimenu(H.fig,            'label','<4-D>',             'visible','off');
H.menu_4D_      = uimenu(H.menu_4D,        'label','-all 4-D vars-',    'visible','off');


H.menu_misc     = uimenu(H.fig,            'label','misc'                                                                                                   );
H.menu_colormap = uimenu(H.menu_misc,      'label','colormap'                                                                                               );
H.menu_cm(1)    = uimenu(H.menu_colormap,  'label','hsv',      'tag','menu_colormap', 'callback','N_changecm(1)'                                            );
H.menu_cm(2)    = uimenu(H.menu_colormap,  'label','hot',      'tag','menu_colormap', 'callback','N_changecm(2)'                                            );
H.menu_cm(3)    = uimenu(H.menu_colormap,  'label','pink',     'tag','menu_colormap', 'callback','N_changecm(3)'                                            );
H.menu_cm(4)    = uimenu(H.menu_colormap,  'label','cool',     'tag','menu_colormap', 'callback','N_changecm(4)'                                            );
H.menu_cm(5)    = uimenu(H.menu_colormap,  'label','bone',     'tag','menu_colormap', 'callback','N_changecm(5)'                                            );
H.menu_cm(6)    = uimenu(H.menu_colormap,  'label','jet',      'tag','menu_colormap', 'callback','N_changecm(6)',           'checked','on'                  );
H.menu_cm(7)    = uimenu(H.menu_colormap,  'label','copper',   'tag','menu_colormap', 'callback','N_changecm(7)'                                            );
H.menu_cm(8)    = uimenu(H.menu_colormap,  'label','prism',    'tag','menu_colormap', 'callback','N_changecm(8)'                                            );
H.menu_cm(9)    = uimenu(H.menu_colormap,  'label','2 colors', 'tag','menu_colormap', 'callback','N_changecm(9)'                                            );

H.menu_shading  = uimenu(H.menu_misc,      'label','shading'                                                                                                );
H.menu_sh(1)    = uimenu(H.menu_shading,   'label','interp',   'tag','menu_shading',  'callback','N_changesh(1)',           'checked','on'                  );
H.menu_sh(2)    = uimenu(H.menu_shading,   'label','flat',     'tag','menu_shading',  'callback','N_changesh(2)'                                            );
H.menu_sh(3)    = uimenu(H.menu_shading,   'label','faceted',  'tag','menu_shading',  'callback','N_changesh(3)'                                            );
H.menu_sh(4)    = uimenu(H.menu_shading,   'label','color...', 'tag','menu_shading',  'callback','N_changesh(4)'                                            );


H.menu_material = uimenu(H.menu_misc,      'label','material',                                                                              'separator','on');
H.menu_ma(1)    = uimenu(H.menu_material,  'label','shiny',    'tag','menu_material', 'callback','N_changema(1)'                                            );
H.menu_ma(2)    = uimenu(H.menu_material,  'label','dull',     'tag','menu_material', 'callback','N_changema(2)'                                            );
H.menu_ma(3)    = uimenu(H.menu_material,  'label','metal',    'tag','menu_material', 'callback','N_changema(3)'                                            );
H.menu_ma(4)    = uimenu(H.menu_material,  'label','.default', 'tag','menu_material', 'callback','N_changema(4)',           'checked','on'                  );

H.menu_lighting = uimenu(H.menu_misc,      'label','lighting'                                                                                               );
H.menu_li(1)    = uimenu(H.menu_lighting,  'label','flat',     'tag','menu_light',    'callback','N_changeli(1)'                                            );
H.menu_li(2)    = uimenu(H.menu_lighting,  'label','gouraud',  'tag','menu_light',    'callback','N_changeli(2)'                                            );
H.menu_li(3)    = uimenu(H.menu_lighting,  'label','phong',    'tag','menu_light',    'callback','N_changeli(3)'                                            );
H.menu_li(4)    = uimenu(H.menu_lighting,  'label','none',     'tag','menu_light',    'callback','N_changeli(4)',           'checked','on'                  );

H.menu_contourc = uimenu(H.menu_misc,      'label','color contours',                                                                        'separator','on');
H.menu_contrc(1)= uimenu(H.menu_contourc,  'label','black',   'tag','menu_ccolor',    'callback','N_contourcolor(''k'',7)',       'checked','off'           );
H.menu_contrc(2)= uimenu(H.menu_contourc,  'label','white',   'tag','menu_ccolor',    'callback','N_contourcolor(''w'',6)',       'checked','off'           );
H.menu_contrc(3)= uimenu(H.menu_contourc,  'label','red',     'tag','menu_ccolor',    'callback','N_contourcolor(''r'',5)',       'checked','off'           );
H.menu_contrc(4)= uimenu(H.menu_contourc,  'label','green',   'tag','menu_ccolor',    'callback','N_contourcolor(''g'',4)',       'checked','off'           );
H.menu_contrc(5)= uimenu(H.menu_contourc,  'label','blue',    'tag','menu_ccolor',    'callback','N_contourcolor(''b'',3)',       'checked','off'           );
H.menu_contrc(6)= uimenu(H.menu_contourc,  'label','custom',  'tag','menu_ccolor',    'callback','N_contourcolor(uisetcolor,2)',  'checked','off'           );
H.menu_contrc(7)= uimenu(H.menu_contourc,  'label','.default','tag','menu_ccolor',    'callback','N_contourcolor(''default'',1)', 'checked','on'            );



H.menu_axis     = uimenu(H.menu_misc,      'label','axis',                                                                                  'separator','on');
H.menu_ax(1)    = uimenu(H.menu_axis,      'label','normal',   'tag','menu_axis',     'callback','N_changeax(1)',           'checked','on'                  );
H.menu_ax(2)    = uimenu(H.menu_axis,      'label','equal',    'tag','menu_axis',     'callback','N_changeax(2)'                                            );
H.menu_ax(3)    = uimenu(H.menu_axis,      'label','auto',     'tag','menu_axis',     'callback','N_changeax(3)'                                            );

H.menu_gui_size = uimenu(H.menu_misc,      'label','gui size',                                                                              'separator','on');
H.menu_gs_def   = uimenu(H.menu_gui_size,  'label','.default',                        'callback','N_guisize(''default'',''R_positions'')', 'checked','on'                   );
H.menu_gs_h25   = uimenu(H.menu_gui_size,  'label','horiz +25%',                      'callback','N_guisize(''H+25%'',''R_positions'')'                                     );
H.menu_gs_v25   = uimenu(H.menu_gui_size,  'label','vertical +25%',                   'callback','N_guisize(''V+25%'',''R_positions'')'                                     );
H.menu_gs_fill  = uimenu(H.menu_gui_size,  'label','fill',                            'callback','N_guisize(''fill'',''R_positions'')'                                      );
H.menu_gs_cust  = uimenu(H.menu_gui_size,  'label','custom',                          'callback','N_guisize(''custom'',''R_positions'')'                                    );

H.menu_theme    = uimenu(H.menu_misc,      'label','gui theme'                                                                                              );
H.menu_themedef = uimenu(H.menu_theme,     'label','.default', 'tag','menu_theme',    'callback','N_theme(''default'')'                                     );
H.menu_theme1   = uimenu(H.menu_theme,     'label','theme 1',  'tag','menu_theme',    'callback','N_theme(''theme 1'')', 'checked','on'                     );
H.menu_theme2   = uimenu(H.menu_theme,     'label','theme 2',  'tag','menu_theme',    'callback','N_theme(''theme 2'')'                                     );
H.menu_theme3   = uimenu(H.menu_theme,     'label','theme 3',  'tag','menu_theme',    'callback','N_theme(''theme 3'')'                                     );


H.menu_fontsize         = uimenu(H.menu_misc,    'label','fontSize',                                                                       'separator','on' );
H.menu_fontsize_ax      = uimenu(H.menu_fontsize,'label','axes',                                                                           'separator','off');
H.menu_fontsize_edit    = uimenu(H.menu_fontsize,'label','editable',                                                                       'separator','off');
H.menu_fontsize_push    = uimenu(H.menu_fontsize,'label','buttons',                                                                        'separator','off');
H.menu_fontsize_text    = uimenu(H.menu_fontsize,'label','text',                                                                           'separator','off');
%N_genfontsize('H.menu_fontsize_ax','ax');
%N_genfontsize('H.menu_fontsize_edit','edit');
%N_genfontsize('H.menu_fontsize_push','push');
%N_genfontsize('H.menu_fontsize_text','text');
%  -> this must be done in the end, cos there are no buttons or axes yet and
%  they are needed to  set the default value checked.

H.menu_overlay          = uimenu(H.menu_misc,    'label','overlay',                                                                         'separator','on');
H.menu_overlay_wcl      = uimenu(H.menu_overlay, 'label','WCL 0:360',                 'callback','N_plot_wcl(1)'                                            );
H.menu_overlay_wcl      = uimenu(H.menu_overlay, 'label','WCL -180:180',              'callback','N_plot_wcl(2)'                                            );
H.menu_overlay_other    = uimenu(H.menu_overlay, 'label','lon, lat file',             'callback','N_overlay(1)'                                             );
H.menu_overlay_once     = uimenu(H.menu_overlay, 'label','once',                      'callback','N_overlayset(''once'')', 'checked','off', 'separator','on');
H.menu_overlay_always   = uimenu(H.menu_overlay, 'label','always',                    'callback','N_overlayset(''always'')','checked','off'                 );
H.menu_overlay_2d       = uimenu(H.menu_overlay, 'label','on 2-D',                    'callback','N_overlayset(''2d'')','checked','on'                      );

H.menu_varsize          = uimenu(H.menu_misc,    'label','max var size',                                                                    'separator','on');
H.menu_varsize100       = uimenu(H.menu_varsize, 'label','100 x 100',                 'callback','N_maxsize(100*100,9,''var'')'                             );
H.menu_varsize300       = uimenu(H.menu_varsize, 'label','300 x 300',                 'callback','N_maxsize(300*300,8,''var'')'                             );
H.menu_varsize600       = uimenu(H.menu_varsize, 'label','600 x 600',                 'callback','N_maxsize(600*600,7,''var'')'                             );
H.menu_varsizeinf       = uimenu(H.menu_varsize, 'label','inf',                       'callback','N_maxsize(inf,6,''var'')'                                 );
% N_maxsize(300*300,8,'var'); % set initial, done in the end, just after path is set
% for arrows:
H.menu_arrsize          = uimenu(H.menu_varsize, 'label','for arrows:',               'callback','',                                        'separator','on');
H.menu_arrsize50        = uimenu(H.menu_varsize, 'label','50 x 50',                   'callback','N_maxsize(50*50,4,''arrows'')'                            );
H.menu_arrsize100       = uimenu(H.menu_varsize, 'label','100 x 100',                 'callback','N_maxsize(100*100,3,''arrows'')'                          );
H.menu_arrsize200       = uimenu(H.menu_varsize, 'label','200 x 200',                 'callback','N_maxsize(200*200,2,''arrows'')'                          );
H.menu_arrsizeinf       = uimenu(H.menu_varsize, 'label','inf',                       'callback','N_maxsize(inf,1,''arrows'')'                              );
% N_maxsize(50*50,4,'arrows'); % set initial, done in the end, just after path is set

H.menu_setlims          = uimenu(H.menu_misc,    'label','set limits',                                                                      'separator','on');
H.menu_setxlim          = uimenu(H.menu_setlims, 'label','xlim',                      'callback','N_setlims(''xlim'')'                                      );
H.menu_setylim          = uimenu(H.menu_setlims, 'label','ylim',                      'callback','N_setlims(''ylim'')'                                      );
H.menu_setzlim          = uimenu(H.menu_setlims, 'label','zlim',                      'callback','N_setlims(''zlim'')'                                      );
H.menu_setar            = uimenu(H.menu_setlims, 'label','ar',                        'callback','N_setlims(''ar'')'                                        );
H.menu_setall           = uimenu(H.menu_setlims, 'label','all',                       'callback','N_setlims(''all'')',                      'separator','on');

H.menu_advancei         = uimenu(H.menu_misc,    'label','auto ><',                   'callback','N_advanceindex',                          'separator','on');

H.menu_ncphelp =  uimenu(H.fig ,           'label','help'                                                                                                   );
H.menu_www     =  uimenu(H.menu_ncphelp,   'label','www',                             'callback','N_help(''www'')'                                          );
H.menu_help    =  uimenu(H.menu_ncphelp,   'label','help',                            'callback','N_help(''local'')'                                        );
H.menu_about   =  uimenu(H.menu_ncphelp,   'label','about',                           'callback','N_about'                                                  );

% --------------------------------------------------------------------
% axes
% --------------------------------------------------------------------
H.axes = axes;
H.axes_title = uicontrol(                                 'style','text');


% --------------------------------------------------------------------
% frame init
% --------------------------------------------------------------------
H.frameInit  = uicontrol(                                 'style','frame'                                                               );

H.varInfo    = uicontrol('string','varname',              'style','edit',         'callback','N_useedited'                              );
H.varMults   = uicontrol('string','x',                    'style','text'                                                                );
H.varMult    = uicontrol('string','1',                    'style','edit',         'callback','N_checkeditvals(''H.varMult'',1,''1'')'   );
H.varOffsets = uicontrol('string','+',                    'style','text'                                                                );
H.varOffset  = uicontrol('string','0',                    'style','edit',         'callback','N_checkeditvals(''H.varOffset'',1,''0'')' );
H.varInfo1   = uicontrol('string','varname',              'style','text'                                                                );

H.dim1c      = uicontrol('string','I',                                            'callback','N_resetLims(''init'',1)'                  );
H.dim1       = uicontrol('string','1',                    'style','edit',         'callback','N_checkrange(''start'',1,''H.dim1'')'     );
H.dim1e      = uicontrol('string','end',                  'style','edit',         'callback','N_checkrange(''end'',1,''H.dim1e'')'      );
H.dim1s      = uicontrol('string','1',                                            'callback','N_resetLims(''end'',1)'                   );

H.dim2c      = uicontrol('string','J',                                            'callback','N_resetLims(''init'',2)'                  );
H.dim2       = uicontrol('string','1',                    'style','edit',         'callback','N_checkrange(''start'',2,''H.dim2'')'     );
H.dim2e      = uicontrol('string','end',                  'style','edit',         'callback','N_checkrange(''end'',2,''H.dim2e'')'      );
H.dim2s      = uicontrol('string','1',                                            'callback','N_resetLims(''end'',2)'                   );

H.dim3c      = uicontrol('string','K',                                            'callback','N_resetLims(''init'',3)'                  );
H.dim3       = uicontrol('string','1',                    'style','edit',         'callback','N_checkrange(''start'',3,''H.dim3'')'     );
H.dim3e      = uicontrol('string','end',                  'style','edit',         'callback','N_checkrange(''end'',3,''H.dim3e'')'      );
H.dim3s      = uicontrol('string','1',                                            'callback','N_resetLims(''end'',3)'                   );

H.dim4c      = uicontrol('string','L',                                            'callback','N_resetLims(''init'',4)'                  );
H.dim4       = uicontrol('string','1',                    'style','edit',         'callback','N_checkrange(''start'',4,''H.dim4'')'     );
H.dim4e      = uicontrol('string','end',                  'style','edit',         'callback','N_checkrange(''end'',4,''H.dim4e'')'      );
H.dim4s      = uicontrol('string','1',                                            'callback','N_resetLims(''end'',4)'                   );

H.stepI      =  uicontrol('string','>',                                           'callback','N_step(''I'')'                            );
H.stepJ      =  uicontrol('string','>',                                           'callback','N_step(''J'')'                            );
H.stepK      =  uicontrol('string','>',                                           'callback','N_step(''K'')'                            );
H.stepL      =  uicontrol('string','>',                                           'callback','N_step(''L'')'                            );

H.stepi      =  uicontrol('string','1',                   'style','edit',         'callback','N_checkrange(''step'',1,''H.stepi'')'     );
H.stepj      =  uicontrol('string','1',                   'style','edit',         'callback','N_checkrange(''step'',2,''H.stepj'')'     );
H.stepk      =  uicontrol('string','1',                   'style','edit',         'callback','N_checkrange(''step'',3,''H.stepk'')'     );
H.stepl      =  uicontrol('string','1',                   'style','edit',         'callback','N_checkrange(''step'',4,''H.stepl'')'     );

H.stepbI     =  uicontrol('string','<',                                           'callback','N_step(''bI'')'                           );
H.stepbJ     =  uicontrol('string','<',                                           'callback','N_step(''bJ'')'                           );
H.stepbK     =  uicontrol('string','<',                                           'callback','N_step(''bK'')'                           );
H.stepbL     =  uicontrol('string','<',                                           'callback','N_step(''bL'')'                           );

H.disp       = uicontrol('string','display',                                      'callback','N_disp'                                   );
H.plotOnLoad = uicontrol('string','plot on load',         'style','checkbox',                                                  'value',0);

% --------------------------------------------------------------------
% frame 2-D
% --------------------------------------------------------------------
H.frame2D = uicontrol(                                    'style','frame'                                                   );

H.contourcb     = uicontrol(                              'style','checkbox',     'callback','N_2dcb(''contour'')'          );
H.contour       = uicontrol('string','contour',                                   'callback','N_disp(''contour'')'          );
H.contourvals   = uicontrol('string','5',                 'style','edit',         'callback','N_checkcontourvals'           );
H.contourclabel = uicontrol('string','clabel',                                    'callback','N_clabel'                     );

H.pcolorcb      = uicontrol(                              'style','checkbox',     'callback','N_2dcb(''pcolor'')', 'value',1);
H.pcolor        = uicontrol('string','pcolor',                                    'callback','N_disp(''pcolor'')'           );
H.pcolorcaxis   = uicontrol('string','0 1',               'style','edit',         'callback','N_checkeditvals(''H.pcolorcaxis'',2,''0 1'')' );
H.pcolorcaxiscb = uicontrol(                              'style','checkbox',                                      'value',0);

H.surfcb        = uicontrol(                              'style','checkbox',     'callback','N_2dcb(''surf'')'             );
H.surf          = uicontrol('string','surf',                                      'callback','N_disp(''surf'')'             );
H.surfview      = uicontrol('string','0 90',              'style','edit',         'callback','N_checkeditvals(''H.surfview'',2,''0 90'')' );
H.surfviewcb    = uicontrol(                              'style','checkbox',                                      'value',0);

H.xycb          = uicontrol(                              'style','checkbox'                                                );
H.x             = uicontrol('string','X',                 'style','edit',         'callback','N_setVarRange(''x'')'         );
H.xscale        = uicontrol('string',' * 1 + 0 ',         'style','edit',         'callback','N_setVarScale(''x'',''check'');' );
H.xrange        = uicontrol('string','(1:1,1:1,1:1,1:1)', 'style','edit'                                                    );
H.y             = uicontrol('string','Y',                 'style','edit',         'callback','N_setVarRange(''y'')'         );
H.yscale        = uicontrol('string',' * 1 + 0 ',         'style','edit',         'callback','N_setVarScale(''y'',''check'');' );
H.yrange        = uicontrol('string','(1:1,1:1,1:1,1:1)', 'style','edit'                                                    );
H.xyrcb         = uicontrol(                              'style','checkbox'                                                );

% --------------------------------------------------------------------
% frame 1-D
% --------------------------------------------------------------------
H.frame1D       = uicontrol(                              'style','frame'                                                   );

H.d1xcb         = uicontrol(                              'style','checkbox'                                                );
H.d1x           = uicontrol('string','X',                 'style','edit',         'callback','N_setVarRange(''d1x'')'       );
H.d1xscale      = uicontrol('string',' * 1 + 0 ',         'style','edit',         'callback','N_setVarScale(''d1x'',''check'');' );
H.d1xrange      = uicontrol('string','(1:1,1:1,1:1,1:1)', 'style','edit'                                                    );
H.d1xrangecb    = uicontrol(                              'style','checkbox'                                                );

%---- Add ########################################
obj=findobj(gcf,'type','uicontrol');
set(obj,'tag','ncdv-only');
% keep just axes_title:
% set(H.axes_title,'tag','');
% but include axes:
set(gca,'tag','ncdv-only');
%---- Add, end ###################################

% --------------------------------------------------------------------
% axes ctrl
% --------------------------------------------------------------------
H.grid          = uicontrol('string','grid',              'style','togglebutton', 'callback','N_toogle(''grid'')'           );
H.zoom          = uicontrol('string','zoom',              'style','togglebutton', 'callback','N_toogle(''zoom'')'           );
H.rotate        = uicontrol('string','rotate',            'style','togglebutton', 'callback','N_toogle(''rotate'')'         );
H.axis_eq       = uicontrol('string','axis equal',        'style','togglebutton', 'callback','N_toogle(''axis_eq'')'        );

H.hold          = uicontrol('string','hold on',           'style','checkbox',     'callback','N_hold',                      'tag','onFig');
H.cla           = uicontrol('string','cla',                                       'callback','N_cla'                        );
H.free          = uicontrol('string','free',                                      'callback','R_free'                       );

H.xlim          = uicontrol('string','0 1',               'style','edit',         'callback','N_lims(''x'')'                );
H.xlim_cb       = uicontrol(                              'style','checkbox',     'callback','N_lims(''xcb'')',             'tag','onFig');
H.xlim_do       = uicontrol('string','xlim',                                      'callback','N_lims(''x'')'                );

H.ylim          = uicontrol('string','0 1',               'style','edit',         'callback','N_lims(''y'')'                );
H.ylim_cb       = uicontrol(                              'style','checkbox',     'callback','N_lims(''ycb'')',             'tag','onFig');
H.ylim_do       = uicontrol('string','ylim',                                      'callback','N_lims(''y'')'                );

H.zlim          = uicontrol('string','0 1',               'style','edit',         'callback','N_lims(''z'')'                );
H.zlim_cb       = uicontrol(                              'style','checkbox',     'callback','N_lims(''zcb'')',             'tag','onFig');
H.zlim_do       = uicontrol('string','zlim',                                      'callback','N_lims(''z'')'                );

H.ar            = uicontrol('string','1 1 1',             'style','edit',         'callback','N_lims(''ar'')'               );
H.ar_cb         = uicontrol(                              'style','checkbox',     'callback','N_lims(''arcb'')',            'tag','onFig');
H.ar_do         = uicontrol('string','ar',                                        'callback','N_lims(''ar'')'               );

% --------------------------------------------------------------------
% frame att
% --------------------------------------------------------------------
H.frameAtt   = uicontrol(                                 'style','frame'                                                   );
H.varAtt     = uicontrol('string','varname',              'style','listbox'                                                 );

%---- Add ########################################
%add ROMS here:

% axes:
H.ROMS.axes=axes('tag','rcdv-only');
H.ROMS.axes_title = uicontrol('style','text','tag','rcdv-only');

% new menu:
H.menu_opts         = uimenu(H.fig,          'label','<opts>',                                                                                       'tag','rcdv-only' );

% menu guides:
H.menu_guides       = uimenu(H.menu_opts,    'label','guides',                                                                                       'tag','rcdv-only' );
H.menu_guidesij     = uimenu(H.menu_guides,  'label','i x j',          'tag','menu_colormap', 'callback','R_setguides(''ij'')',                      'tag','rcdv-only' );
H.menu_guideslonlat = uimenu(H.menu_guides,  'label','lon x lat',      'tag','menu_colormap', 'callback','R_setguides(''lonlat'')', 'checked','on',  'tag','rcdv-only' );
H.menu_guidesboth   = uimenu(H.menu_guides,  'label','both',           'tag','menu_colormap', 'callback','R_setguides(''both'')',                    'tag','rcdv-only' );
H.menu_guidesnone   = uimenu(H.menu_guides,  'label','none',           'tag','menu_colormap', 'callback','R_setguides(''none'')',                    'tag','rcdv-only' );

% menu draw_bar:
H.menu_drawbar      = uimenu(H.menu_opts,    'label','draw-bar',                                                                                     'tag','rcdv-only' );
H.menu_drawadd      = uimenu(H.menu_drawbar, 'label','show',           'tag','menu_colormap', 'callback','R_drawbar(''add'')',                       'tag','rcdv-only' );
H.menu_drawdel      = uimenu(H.menu_drawbar, 'label','hide',           'tag','menu_colormap', 'callback','R_drawbar(''del'')',                       'tag','rcdv-only' );


% ROMS frame:
H.ROMS.frame = uicontrol('style','frame','tag','rcdv-only');

% head: selection buttons (his, flt, ...)
H.ROMS.toggle_grid   = uicontrol('style','togglebutton','string','grid','callback','R_toogle(''grid'')','value',1,   'tag','rcdv-only');
H.ROMS.toggle_his    = uicontrol('style','togglebutton','string','his', 'callback','R_toogle(''his'')',              'tag','rcdv-only');
H.ROMS.toggle_sta    = uicontrol('style','togglebutton','string','sta', 'callback','R_toogle(''sta'')',              'tag','rcdv-only');
H.ROMS.toggle_flt    = uicontrol('style','togglebutton','string','flt', 'callback','R_toogle(''flt'')',              'tag','rcdv-only');

% grid buttons:
H.ROMS.grid.load    = uicontrol(                'string','load',       'callback','R_load(''grid'')', 'tag','rcdv-only','userdata','roms_grid');
H.ROMS.grid.name    = uicontrol('style','text', 'string','none',                                      'tag','rcdv-only','userdata','roms_grid');
H.ROMS.grid.contour = uicontrol('style','edit', 'string','200   1000', 'callback','R_contour',        'tag','rcdv-only','userdata','roms_grid');

H.ROMS.grid.clabel  = uicontrol(                'string','clabel',     'callback','R_clabel',         'tag','rcdv-only','userdata','roms_grid');
H.ROMS.grid.free3d  = uicontrol(                'string','3-D',        'callback','R_free3d',         'tag','rcdv-only','userdata','roms_grid');
H.ROMS.grid.coast   = uicontrol(                'string','coast',      'callback','R_coastline',      'tag','rcdv-only','userdata','roms_grid');
H.ROMS.grid.mask    = uicontrol(                'string','mask',       'callback','R_freemask',       'tag','rcdv-only','userdata','roms_grid');

% about s-levels:
H.ROMS.grid.thetas_ = uicontrol('style','text', 'string','thetas',     'callback','', 'tag','rcdv-only','userdata','roms_grid');
H.ROMS.grid.thetas  = uicontrol('style','edit', 'string','ts',         'callback','', 'tag','rcdv-only','userdata','roms_grid');
H.ROMS.grid.thetab_ = uicontrol('style','text', 'string','thetab',                                      'tag','rcdv-only','userdata','roms_grid');
H.ROMS.grid.thetab  = uicontrol('style','edit', 'string','tb',                                      'tag','rcdv-only','userdata','roms_grid');
H.ROMS.grid.tcline_ = uicontrol('style','text', 'string','Tcline',     'callback','',        'tag','rcdv-only','userdata','roms_grid');
H.ROMS.grid.tcline  = uicontrol('style','edit', 'string','tc',         'callback','',        'tag','rcdv-only','userdata','roms_grid');
H.ROMS.grid.hmin_   = uicontrol('style','text', 'string','Hmin',       'callback','',        'tag','rcdv-only','userdata','roms_grid');
H.ROMS.grid.hmin    = uicontrol('style','edit', 'string','hm',         'callback','',        'tag','rcdv-only','userdata','roms_grid');
H.ROMS.grid.zeta_   = uicontrol('style','text', 'string','zeta',       'callback','',        'tag','rcdv-only','userdata','roms_grid');
H.ROMS.grid.zeta    = uicontrol('style','edit', 'string','0',          'callback','',        'tag','rcdv-only','userdata','roms_grid');
H.ROMS.grid.N_      = uicontrol('style','text', 'string','N',          'callback','',        'tag','rcdv-only','userdata','roms_grid');
H.ROMS.grid.N       = uicontrol('style','edit', 'string','10',         'callback','',        'tag','rcdv-only','userdata','roms_grid');
H.ROMS.grid.sparams = uicontrol('style','checkbox', 'string','force',  'callback','',        'tag','rcdv-only','userdata','roms_grid');
H.ROMS.grid.slev    = uicontrol(                'string','s-levels',   'callback','R_slev',        'tag','rcdv-only','userdata','roms_grid');


% frame of position:
H.ROMS.frame_pos   = uicontrol('style','frame','callback','','tag','rcdv-only');
H.ROMS.grid.i_     = uicontrol('style','text', 'string','I',         'callback','',                   'tag','rcdv-only','userdata','roms_all');
H.ROMS.grid.i      = uicontrol('style','edit', 'string','i',         'callback','R_pointer(''i'')',   'tag','rcdv-only','userdata','roms_all');
H.ROMS.grid.j_     = uicontrol('style','text', 'string','J',         'callback','',                   'tag','rcdv-only','userdata','roms_all');
H.ROMS.grid.j      = uicontrol('style','edit', 'string','j',         'callback','R_pointer(''j'')',   'tag','rcdv-only','userdata','roms_all');
H.ROMS.grid.lon_   = uicontrol('style','text', 'string','lon',       'callback','',                   'tag','rcdv-only','userdata','roms_all');
H.ROMS.grid.lon    = uicontrol('style','edit', 'string','lon',       'callback','R_pointer(''lon'')', 'tag','rcdv-only','userdata','roms_all');
H.ROMS.grid.lat_   = uicontrol('style','text', 'string','lat',       'callback','',                   'tag','rcdv-only','userdata','roms_all');
H.ROMS.grid.lat    = uicontrol('style','edit', 'string','lat',       'callback','R_pointer(''lat'')', 'tag','rcdv-only','userdata','roms_all');

H.ROMS.grid.k_     = uicontrol('style','text', 'string','K',         'callback','',        'tag','rcdv-only','userdata','roms_all');
H.ROMS.grid.k      = uicontrol('style','edit', 'string','k',         'callback','',        'tag','rcdv-only','userdata','roms_all');
H.ROMS.grid.z_     = uicontrol('style','text', 'string','Z',         'callback','',        'tag','rcdv-only','userdata','roms_all');
H.ROMS.grid.z      = uicontrol('style','edit', 'string','z',         'callback','',        'tag','rcdv-only','userdata','roms_all');

H.ROMS.grid.icb    = uicontrol('style','checkbox', 'string','',      'callback','R_slicecb(''icb'')',        'tag','rcdv-only','userdata','roms_all');
H.ROMS.grid.jcb    = uicontrol('style','checkbox', 'string','',      'callback','R_slicecb(''jcb'')',        'tag','rcdv-only','userdata','roms_all', 'value',1);
H.ROMS.grid.loncb  = uicontrol('style','checkbox', 'string','',      'callback','R_slicecb(''loncb'')',      'tag','rcdv-only','userdata','roms_all');
H.ROMS.grid.latcb  = uicontrol('style','checkbox', 'string','',      'callback','R_slicecb(''latcb'')',      'tag','rcdv-only','userdata','roms_all');
H.ROMS.grid.kcb    = uicontrol('style','checkbox', 'string','',      'callback','R_slicecb(''kcb'')',        'tag','rcdv-only','userdata','roms_all');
H.ROMS.grid.zcb    = uicontrol('style','checkbox', 'string','',      'callback','R_slicecb(''zcb'')',        'tag','rcdv-only','userdata','roms_all');


% his buttons:
H.ROMS.his.load    = uicontrol(                'string','load',       'callback','R_load(''his'')',  'tag','rcdv-only','userdata','roms_his1');
H.ROMS.his.name    = uicontrol('style','text', 'string','none',                                      'tag','rcdv-only','userdata','roms_his1');
% about time, days:
H.ROMS.his.ndays_  = uicontrol(                'string','ndays', 'callback','R_histime(''ndays'')',  'tag','rcdv-only','userdata','roms_his1');
H.ROMS.his.ndays   = uicontrol('style','text', 'string','nd',    'callback','',                      'tag','rcdv-only','userdata','roms_his1');
H.ROMS.his.nhis_   = uicontrol('style','text', 'string','nhis:',  'callback','R_histime(''nhis'')',   'tag','rcdv-only','userdata','roms_his1');
H.ROMS.his.nhis    = uicontrol('style','text', 'string','nh',    'callback','',                      'tag','rcdv-only','userdata','roms_his1');
H.ROMS.his.dhis_   = uicontrol('style','text', 'string','dhis:',  'callback','R_histime(''dhis'')',   'tag','rcdv-only','userdata','roms_his1');
H.ROMS.his.dhis    = uicontrol('style','text', 'string','dh',    'callback','',                      'tag','rcdv-only','userdata','roms_his1');
% ocean time:
H.ROMS.his.t       = uicontrol(                'string','T',     'callback','R_mvhistime(''T'')',    'tag','rcdv-only','userdata','roms_his1');
H.ROMS.his.tless   = uicontrol(                'string','<',     'callback','R_mvhistime(''<'')',    'tag','rcdv-only','userdata','roms_his1');
H.ROMS.his.tmore   = uicontrol(                'string','>',     'callback','R_mvhistime(''>'')',    'tag','rcdv-only','userdata','roms_his1');
H.ROMS.his.tindex  = uicontrol('style','edit', 'string','1',     'callback','R_mvhistime(''i'')',    'tag','rcdv-only','userdata','roms_his1');
H.ROMS.his.tstep   = uicontrol('style','edit', 'string','1',     'callback','R_mvhistime(''step'')', 'tag','rcdv-only','userdata','roms_his1');
H.ROMS.his.tval    = uicontrol('style','text', 'string','tval',  'callback','',                      'tag','rcdv-only','userdata','roms_his1');

% variables
H.ROMS.his.var1   = uicontrol('style','popupmenu', 'string',{'none','u','v','w','ubar','vbar','salt','temp','zeta'},   'callback','',               'tag','rcdv-only','userdata','roms_his1');
H.ROMS.his.var2   = uicontrol('style','popupmenu', 'string',{'none','u','v','w','ubar','vbar','salt','temp','zeta','currents','uv-bar'},   'callback','',        'tag','rcdv-only','userdata','roms_his1');

H.ROMS.his.disp   = uicontrol(                     'string','disp',    'callback','R_disp',          'tag','rcdv-only','userdata','roms_his1');
H.ROMS.his.dispcb = uicontrol('style','checkbox',  'string','',        'callback','set(gcf,''pointer'',''arrow'')',   'tag','rcdv-only','userdata','roms_his1');

% ################################################
% overlay/var options   his_more:
H.ROMS.his.varopts      = uicontrol(                'string','>>',      'callback','R_varopts(''start'')',     'tag','rcdv-only','userdata','roms_his1');

H.ROMS.his.morecvals1   = uicontrol('style','edit', 'string','5',       'callback','R_more(''ctvals1'')',      'tag','rcdv-only','userdata','roms_his_more');
H.ROMS.his.morecvals2   = uicontrol('style','edit', 'string','',        'callback','R_more(''ctvals2'')',      'tag','rcdv-only','userdata','roms_his_more');
H.ROMS.his.moreline1    = uicontrol('style','popupmenu', 'string',{'-',':','-.','--'},       'callback','R_more(''line1'')',        'tag','rcdv-only','userdata','roms_his_more');
H.ROMS.his.moreline2    = uicontrol('style','popupmenu', 'string',{'-',':','-.','--'},      'callback','R_more(''line2'')',        'tag','rcdv-only','userdata','roms_his_more');
H.ROMS.his.morelinew1   = uicontrol('style','popupmenu', 'string',{'0.5','1','2','3','4','5'},       'callback','R_more(''linew1'')',       'tag','rcdv-only','userdata','roms_his_more');
H.ROMS.his.morelinew2   = uicontrol('style','popupmenu', 'string',{'0.5','1','2','3','4','5'},       'callback','R_more(''linew2'')',       'tag','rcdv-only','userdata','roms_his_more');
H.ROMS.his.morelinec1   = uicontrol(                'string','',        'callback','R_more(''linec1'')',       'tag','rcdv-only','userdata','roms_his_more');
H.ROMS.his.morelinec2   = uicontrol(                'string','',        'callback','R_more(''linec2'')',       'tag','rcdv-only','userdata','roms_his_more');

H.ROMS.his.moreclabel1 = uicontrol(                'string','clabel1', 'callback','R_more(''clabel1'')',       'tag','rcdv-only','userdata','roms_his_more');
H.ROMS.his.moreclabel2 = uicontrol(                'string','clabel2', 'callback','R_more(''clabel2'')',       'tag','rcdv-only','userdata','roms_his_more');

H.ROMS.his.morescale1_ = uicontrol('style','text',  'string','scale1:',  'callback','',                         'tag','rcdv-only','userdata','roms_his_more');
H.ROMS.his.morescale1  = uicontrol('style','edit',  'string','1',       'callback','R_more(''scale1'')',       'tag','rcdv-only','userdata','roms_his_more');

H.ROMS.his.morescale2_ = uicontrol('style','text',  'string','scale2:',  'callback','',                         'tag','rcdv-only','userdata','roms_his_more');
H.ROMS.his.morescale2  = uicontrol('style','edit',  'string','1',       'callback','R_more(''scale2'')',       'tag','rcdv-only','userdata','roms_his_more');

H.ROMS.his.moreduv_    = uicontrol('style','text',  'string','du dv:',  'callback','',                          'tag','rcdv-only','userdata','roms_his_more');
H.ROMS.his.moreduv     = uicontrol('style','edit',  'string','10 10',  'callback','N_checkeditvals(''H.ROMS.his.moreduv'',2,''10 10'')',       'tag','rcdv-only','userdata','roms_his_more');

H.ROMS.his.morearrsc_  = uicontrol('style','text',  'string','-->',  'callback','',                          'tag','rcdv-only','userdata','roms_his_more');
H.ROMS.his.morearrsc   = uicontrol('style','edit',  'string','nan nan',  'callback','N_checkeditvals(''H.ROMS.his.morearrsc'',2,''nan nan'')',       'tag','rcdv-only','userdata','roms_his_more');
H.ROMS.his.morearrscgin= uicontrol(                 'string','gin',  'callback','R_arrowpos',                     'tag','rcdv-only','userdata','roms_his_more');
H.ROMS.his.morearrcolor= uicontrol(                 'string','',  'callback','R_colorbutton(''H.ROMS.his.morearrcolor'')',                     'tag','rcdv-only','userdata','roms_his_more');
H.ROMS.his.morearrscval= uicontrol('style','edit',  'string','0 1', 'callback','N_checkeditvals(''H.ROMS.his.morearrscval'',2,''0 1'')',           'tag','rcdv-only','userdata','roms_his_more');


H.ROMS.his.moregridon  = uicontrol('style','checkbox',  'string','grid on',  'callback','',                       'tag','rcdv-only','userdata','roms_his_more','value',1);
H.ROMS.his.morebathy   = uicontrol('style','checkbox',  'string','bathy',    'callback','',                       'tag','rcdv-only','userdata','roms_his_more','value',1);
H.ROMS.his.morebathyc  = uicontrol(                     'string','',         'callback','R_more(''bathycolor'')', 'tag','rcdv-only','userdata','roms_his_more');
H.ROMS.his.moremask    = uicontrol('style','checkbox',  'string','mask',     'callback','',                       'tag','rcdv-only','userdata','roms_his_more','value',1);
H.ROMS.his.moremaskc   = uicontrol(                     'string','',         'callback','R_more(''maskcolor'')',  'tag','rcdv-only','userdata','roms_his_more');

%#################################################

% plot options
H.ROMS.frame_plotopt     = uicontrol('style','frame','callback','','tag','rcdv-only');

H.ROMS.his.contourcb     = uicontrol('style','checkbox', 'string','',        'callback','R_plotopt(''contourcb'')',      'tag','rcdv-only','userdata','roms_his2');
H.ROMS.his.contour       = uicontrol(                    'string','contour', 'callback','R_plotopt(''contour'')',        'tag','rcdv-only','userdata','roms_his2');
H.ROMS.his.contourvals   = uicontrol('style','edit',     'string','5',       'callback','R_plotopt(''contourvals'')',    'tag','rcdv-only','userdata','roms_his2');
H.ROMS.his.contourclabel = uicontrol(                    'string','clabel',  'callback','R_plotopt(''clabel'')',         'tag','rcdv-only','userdata','roms_his2');

H.ROMS.his.pcolorcb      = uicontrol('style','checkbox', 'string','',        'callback','R_plotopt(''pcolorcb'')',       'tag','rcdv-only','userdata','roms_his2', 'value',1);
H.ROMS.his.pcolor        = uicontrol(                    'string','pcolor',  'callback','R_plotopt(''pcolor'')',         'tag','rcdv-only','userdata','roms_his2');
H.ROMS.his.pcolorcaxis   = uicontrol('style','edit',     'string','caxis',   'callback','R_plotopt(''pcolorcaxis'')',    'tag','rcdv-only','userdata','roms_his2');
H.ROMS.his.pcolorcaxiscb = uicontrol('style','checkbox', 'string','',        'callback','',                              'tag','rcdv-only','userdata','roms_his2');

% figure/axes options:
H.ROMS.his.xlimcb  = uicontrol('style','checkbox',     'string','',             'callback','',                              'tag','rcdv-only','userdata','roms_his2');
H.ROMS.his.xlim    = uicontrol('style','edit',         'string','xlim',         'callback','R_outputsett(''xlim'')',        'tag','rcdv-only','userdata','roms_his2');

H.ROMS.his.ylimcb  = uicontrol('style','checkbox',     'string','',             'callback','',                              'tag','rcdv-only','userdata','roms_his2');
H.ROMS.his.ylim    = uicontrol('style','edit',         'string','ylim',         'callback','R_outputsett(''ylim'')',        'tag','rcdv-only','userdata','roms_his2');

H.ROMS.his.zlimcb  = uicontrol('style','checkbox',     'string','',             'callback','',                              'tag','rcdv-only','userdata','roms_his2');
H.ROMS.his.zlim    = uicontrol('style','edit',         'string','zlim',         'callback','R_outputsett(''zlim'')',        'tag','rcdv-only','userdata','roms_his2');

H.ROMS.his.d2  = uicontrol('style','checkbox',     'string','2-d',              'callback','R_2d3d(2)',                     'tag','rcdv-only','userdata','roms_all');
H.ROMS.his.d3  = uicontrol('style','checkbox',     'string','3-d',              'callback','R_2d3d(3)',                     'tag','rcdv-only','userdata','roms_all','value',1);

H.ROMS.his.current = uicontrol(                        'string','currentt',     'callback','R_outputsett(''current'')',     'tag','rcdv-only','userdata','roms_his2');

H.ROMS.his.newfig  = uicontrol('style','checkbox',     'string','new fig',      'callback','R_hold(''newfig'')',            'tag','rcdv-only','userdata','roms_his2');
H.ROMS.his.axauto  = uicontrol(                        'string','ax auto',      'callback','R_outputsett(''ax auto'')',     'tag','rcdv-only','userdata','roms_his2');
H.ROMS.his.axequal = uicontrol('style','togglebutton', 'string','ax eq',        'callback','R_outputsett(''ax equal'')',    'tag','rcdv-only','userdata','roms_his2');
H.ROMS.his.closeall= uicontrol(                        'string','close all',    'callback','R_outputsett(''close all'')',   'tag','rcdv-only','userdata','roms_his2');
H.ROMS.his.hold    = uicontrol('style','checkbox',     'string','hold',         'callback','R_hold(''hold'')',              'tag','rcdv-only','userdata','roms_all');



% flt buttons:
H.ROMS.flt.load    = uicontrol(                'string','load',       'callback','R_load(''flt'')',  'tag','rcdv-only','userdata','roms_flt');
H.ROMS.flt.name    = uicontrol('style','text', 'string','none',                                      'tag','rcdv-only','userdata','roms_flt');
% about time, days:
H.ROMS.flt.ndays_  = uicontrol(                'string','ndays', 'callback','R_flttime(''ndays'')',  'tag','rcdv-only','userdata','roms_flt');
H.ROMS.flt.ndays   = uicontrol('style','text', 'string','nd',    'callback','',                      'tag','rcdv-only','userdata','roms_flt');
H.ROMS.flt.nflt_   = uicontrol('style','text', 'string','nflt:', 'callback','R_flttime(''nflt'')',  'tag','rcdv-only','userdata','roms_flt');
H.ROMS.flt.nflt    = uicontrol('style','text', 'string','nf',    'callback','',                      'tag','rcdv-only','userdata','roms_flt');
H.ROMS.flt.dflt_   = uicontrol('style','text', 'string','dflt:', 'callback','R_flttime(''dflt'')',  'tag','rcdv-only','userdata','roms_flt');
H.ROMS.flt.dflt    = uicontrol('style','text', 'string','df',    'callback','',                      'tag','rcdv-only','userdata','roms_flt');
% ocean time:
H.ROMS.flt.t       = uicontrol(                'string','T',     'callback','R_mvflttime(''T'')',    'tag','rcdv-only','userdata','roms_flt');
H.ROMS.flt.tless   = uicontrol(                'string','<',     'callback','R_mvflttime(''<'')',    'tag','rcdv-only','userdata','roms_flt');
H.ROMS.flt.tmore   = uicontrol(                'string','>',     'callback','R_mvflttime(''>'')',    'tag','rcdv-only','userdata','roms_flt');
H.ROMS.flt.tindex  = uicontrol('style','edit', 'string','1',     'callback','R_mvflttime(''i'')',    'tag','rcdv-only','userdata','roms_flt');
H.ROMS.flt.tstep   = uicontrol('style','edit', 'string','1',     'callback','R_mvflttime(''step'')', 'tag','rcdv-only','userdata','roms_flt');
H.ROMS.flt.tval    = uicontrol('style','text', 'string','tval',  'callback','',                      'tag','rcdv-only','userdata','roms_flt');


% float indexes:
H.ROMS.flt.dimc      = uicontrol('string','I',                                           'callback','R_mvfltindex(''init'')'               ,'tag','rcdv-only','userdata','roms_flt'    );
H.ROMS.flt.stepb     = uicontrol('string','<',                                           'callback','R_mvfltindex(''b'')'                  ,'tag','rcdv-only','userdata','roms_flt'    );
H.ROMS.flt.dimi      = uicontrol('string','1',                   'style','edit',         'callback','R_mvfltindex(''checkinit'')'          ,'tag','rcdv-only','userdata','roms_flt'    );
H.ROMS.flt.dimstep   = uicontrol('string','1',                   'style','edit',         'callback','R_mvfltindex(''checkstep'')'          ,'tag','rcdv-only','userdata','roms_flt'    );
H.ROMS.flt.dime      = uicontrol('string','end',                 'style','edit',         'callback','R_mvfltindex(''checkend'')'           ,'tag','rcdv-only','userdata','roms_flt'    );
H.ROMS.flt.stepf     = uicontrol('string','>',                                           'callback','R_mvfltindex(''f'')'                  ,'tag','rcdv-only','userdata','roms_flt'    );
H.ROMS.flt.dims      = uicontrol('string','1',                                           'callback','R_mvfltindex(''end'')'                ,'tag','rcdv-only','userdata','roms_flt'    );

H.ROMS.flt.disp   = uicontrol(                     'string','disp',    'callback','R_dispflt',                                              'tag','rcdv-only','userdata','roms_flt');
H.ROMS.flt.dispcb = uicontrol('style','checkbox',  'string','',        'callback','set(gcf,''pointer'',''arrow'')',                         'tag','rcdv-only','userdata','roms_flt');

H.ROMS.flt.trackcb = uicontrol('style','checkbox',  'string','track',  'callback','',                                                       'tag','rcdv-only','userdata','roms_flt');


% new, 2-2005, for stations file:
H.ROMS.sta.load    = uicontrol(                'string','load',       'callback','R_load(''sta'')',  'tag','rcdv-only','userdata','roms_sta');
H.ROMS.sta.name    = uicontrol('style','text', 'string','none',                                      'tag','rcdv-only','userdata','roms_sta');
% about time, days:
H.ROMS.sta.ndays_  = uicontrol(                'string','ndays', 'callback','R_statime(''ndays'')',  'tag','rcdv-only','userdata','roms_sta');
H.ROMS.sta.ndays   = uicontrol('style','text', 'string','nd',    'callback','',                      'tag','rcdv-only','userdata','roms_sta');
H.ROMS.sta.nsta_   = uicontrol('style','text', 'string','nsta:', 'callback','R_statime(''nsta'')',   'tag','rcdv-only','userdata','roms_sta');
H.ROMS.sta.nsta    = uicontrol('style','text', 'string','ns',    'callback','',                      'tag','rcdv-only','userdata','roms_sta');
H.ROMS.sta.dsta_   = uicontrol('style','text', 'string','dsta:', 'callback','R_statime(''dsta'')',   'tag','rcdv-only','userdata','roms_sta');
H.ROMS.sta.dsta    = uicontrol('style','text', 'string','ds',    'callback','',                      'tag','rcdv-only','userdata','roms_sta');
% ocean time:
H.ROMS.sta.t       = uicontrol(                'string','T',     'callback','R_mvstatime(''T'')',    'tag','rcdv-only','userdata','roms_sta');
H.ROMS.sta.tless   = uicontrol(                'string','<',     'callback','R_mvstatime(''<'')',    'tag','rcdv-only','userdata','roms_sta');
H.ROMS.sta.tmore   = uicontrol(                'string','>',     'callback','R_mvstatime(''>'')',    'tag','rcdv-only','userdata','roms_sta');
H.ROMS.sta.tindex  = uicontrol('style','edit', 'string','1',     'callback','R_mvstatime(''i'')',    'tag','rcdv-only','userdata','roms_sta');
H.ROMS.sta.tstep   = uicontrol('style','edit', 'string','1',     'callback','R_mvstatime(''step'')', 'tag','rcdv-only','userdata','roms_sta');
H.ROMS.sta.tval    = uicontrol('style','text', 'string','tval',  'callback','',                      'tag','rcdv-only','userdata','roms_sta');

% profiles:
H.ROMS.sta.vprofile  = uicontrol('style','checkbox',  'string','vert.',     'callback','R_stasetts(''v'');', 'tag','rcdv-only','userdata','roms_sta');
H.ROMS.sta.tprofile  = uicontrol('style','checkbox',  'string','time.',     'callback','R_stasetts(''t'');', 'tag','rcdv-only','userdata','roms_sta');

%plot options for v-t profile time series:
H.ROMS.sta.contourcb     = uicontrol('style','checkbox', 'string','',        'callback','R_staplotopt(''contourcb'')',      'tag','rcdv-only','userdata','roms_sta');
H.ROMS.sta.contour       = uicontrol(                    'string','contour', 'callback','R_staplotopt(''contour'')',        'tag','rcdv-only','userdata','roms_sta');
H.ROMS.sta.contourvals   = uicontrol('style','edit',     'string','5',       'callback','R_staplotopt(''contourvals'')',    'tag','rcdv-only','userdata','roms_sta');
H.ROMS.sta.contourclabel = uicontrol(                    'string','clabel',  'callback','R_staplotopt(''clabel'')',         'tag','rcdv-only','userdata','roms_sta');

H.ROMS.sta.pcolorcb      = uicontrol('style','checkbox', 'string','',        'callback','R_staplotopt(''pcolorcb'')',       'tag','rcdv-only','userdata','roms_sta', 'value',1);
H.ROMS.sta.pcolor        = uicontrol(                    'string','pcolor',  'callback','R_staplotopt(''pcolor'')',         'tag','rcdv-only','userdata','roms_sta');
H.ROMS.sta.pcolorcaxis   = uicontrol('style','edit',     'string','caxis',   'callback','R_staplotopt(''pcolorcaxis'')',    'tag','rcdv-only','userdata','roms_sta');
H.ROMS.sta.pcolorcaxiscb = uicontrol('style','checkbox', 'string','',        'callback','',                                 'tag','rcdv-only','userdata','roms_sta');

H.ROMS.sta.plotcb        = uicontrol('style','checkbox', 'string','',        'callback','R_staplotopt(''plotcb'')',         'tag','rcdv-only','userdata','roms_sta', 'value',0);
H.ROMS.sta.plot          = uicontrol(                    'string','plot',    'callback','R_staplotopt(''plot'')',           'tag','rcdv-only','userdata','roms_sta');

% select station, disp, variable and maarker sizes:
H.ROMS.sta.select        = uicontrol(                         'string','select',  'callback','R_staselect(''mouse'');',        'tag','rcdv-only','userdata','roms_sta');
H.ROMS.sta.selectinfo    = uicontrol('style','text',          'string','',        'callback','',        'tag','rcdv-only','userdata','roms_sta');
H.ROMS.sta.selectmarker  = uicontrol('style','popupmenu',     'string',{'0','1','2','4','6','8','10'},      'callback','R_stamarker',        'tag','rcdv-only','userdata','roms_sta');
H.ROMS.sta.selectn       = uicontrol('style','edit',          'string','sta #',   'callback','R_staselect(''edit'');',     'tag','rcdv-only','userdata','roms_sta');
H.ROMS.sta.variable      = uicontrol('style','popupmenu',     'string',{'none','u','v','w','ubar','vbar','salt','temp','zeta','none','none'},     'tag','rcdv-only','userdata','roms_sta');
H.ROMS.sta.disp          = uicontrol(                         'string','disp',    'callback','R_stadisp',        'tag','rcdv-only','userdata','roms_sta');
H.ROMS.sta.dispcb        = uicontrol('style','checkbox',      'string','',        'callback','set(gcf,''pointer'',''arrow'')',                         'tag','rcdv-only','userdata','roms_sta');

% filter:
H.ROMS.sta.filtercb      = uicontrol('style','checkbox',  'string','filter', 'callback','',         'tag','rcdv-only','userdata','roms_sta', 'value',0);
H.ROMS.sta.filterdt      = uicontrol('style','edit',      'string','dt',     'callback','',         'tag','rcdv-only','userdata','roms_sta');
H.ROMS.sta.filterT       = uicontrol('style','edit',      'string','33',     'callback','',         'tag','rcdv-only','userdata','roms_sta');
H.ROMS.sta.filteradd     = uicontrol('style','checkbox',  'string','add',    'callback','',         'tag','rcdv-only','userdata','roms_sta');


%---- Add, end ###################################

% »»»»»»»»»»»»»»»»»»»»»»»»»» final settings ««««««««««««««««««««««««««

% --------------------------------------------------------------------
% set objects positions
% --------------------------------------------------------------------
R_positions;

% --------------------------------------------------------------------
% set theme
% --------------------------------------------------------------------
N_theme('theme 1');

% --------------------------------------------------------------------
% set max var size
% --------------------------------------------------------------------
N_maxsize(300*300,8,'var');  % set initial for variables
N_maxsize(50*50,4,'arrows'); % for arrows

% --------------------------------------------------------------------
% fontSize initialization
% --------------------------------------------------------------------
N_genfontsize('H.menu_fontsize_ax','ax');
N_genfontsize('H.menu_fontsize_edit','edit');
N_genfontsize('H.menu_fontsize_push','push');
N_genfontsize('H.menu_fontsize_text','text');

% --------------------------------------------------------------------
% check netcdf
% --------------------------------------------------------------------
if ~isequal(exist('netcdf'),2)
  err=errordlg({'netcdf seem not to be working...','be sure it is correctly installed'},'','modal');
end


%---- Add ########################################

R_roms('start');
R_varopts('stop');  % hide his_more buttons
R_toogle('grid');

% look:
R_theme;

%---- Add, end ###################################
