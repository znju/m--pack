function ncdv
%NCDV   Matlab GUI for NetCDF visualization
%   NCDView main file
%
%   requirements:
%      NetCDF/Matlab interface, available at:
%      http://woodshole.er.usgs.gov/staffpages/cdenham/public_html/MexCDF/nc4ml5.html
%
%   MMA 6-2004, martinho@fis.ua.pt
%
%   Modif: 20-9-2004 : --> version 1.1
%          Added scale and offset to x, y and d1x
%          12-2004: work under M_PACK
%
%   See also M_PACK

% first check is there is ncdv already openned; if so, close previous one!
obj=findobj(0,'name','NCDView');
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
set(H.fig,'units','normalized','NumberTitle','off','Name','NCDView','MenuBar','none');
set(H.fig,'closerequestfcn','N_exit');

% --------------------------------------------------------------------
% menus
% --------------------------------------------------------------------
H.menu_file     = uimenu(H.fig,            'label','NCDV');
H.menu_load     = uimenu(H.menu_file,      'label','load',        'callback','N_load'                                         );
H.menu_files    = uimenu(H.menu_file,      'label','files',       'callback',''                                               );
H.menu_files0   = uimenu(H.menu_files,     'label','none',        'callback',''                                               );
H.menu_toolbar  = uimenu(H.menu_file,      'label','fig menus',   'callback','N_figtoolbar', 'checked','off','separator','on' );
H.menu_restart  = uimenu(H.menu_file,      'label','restart',     'callback','close, ncdv',   'Separator','on'                );
H.menu_exit     = uimenu(H.menu_file,      'label','exit',        'callback','N_exit',       'Separator','off'                );

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
H.menu_gs_def   = uimenu(H.menu_gui_size,  'label','.default',                        'callback','N_guisize(''default'')', 'checked','on'                   );
H.menu_gs_h25   = uimenu(H.menu_gui_size,  'label','horiz +25%',                      'callback','N_guisize(''H+25%'')'                                     );
H.menu_gs_v25   = uimenu(H.menu_gui_size,  'label','vertical +25%',                   'callback','N_guisize(''V+25%'')'                                     );
H.menu_gs_fill  = uimenu(H.menu_gui_size,  'label','fill',                            'callback','N_guisize(''fill'')'                                      );
H.menu_gs_cust  = uimenu(H.menu_gui_size,  'label','custom',                          'callback','N_guisize(''custom'')'                                    );

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

% --------------------------------------------------------------------
% axes ctrl
% --------------------------------------------------------------------
H.grid          = uicontrol('string','grid',              'style','togglebutton', 'callback','N_toogle(''grid'')'           );
H.zoom          = uicontrol('string','zoom',              'style','togglebutton', 'callback','N_toogle(''zoom'')'           );
H.rotate        = uicontrol('string','rotate',            'style','togglebutton', 'callback','N_toogle(''rotate'')'         );
H.axis_eq       = uicontrol('string','axis equal',        'style','togglebutton', 'callback','N_toogle(''axis_eq'')'        );

H.hold          = uicontrol('string','hold on',           'style','checkbox',     'callback','N_hold',                      'tag','onFig');
H.cla           = uicontrol('string','cla',                                       'callback','N_cla'                        );
H.free          = uicontrol('string','free',                                      'callback','N_free'                       );

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


% »»»»»»»»»»»»»»»»»»»»»»»»»» final settings ««««««««««««««««««««««««««

if 0 % no longer needed
     % also changed files/N_exit (not to remove files - added bellow - from path)
% --------------------------------------------------------------------
% add subdirs to path
% --------------------------------------------------------------------
dir=which(['ncdv']);
dir=dir(1:end-6);
addpath([dir, 'files'    ]);
evalc('addpath([dir, ''datasets'' ]);',''); %  this is needed cos user may not download datasets.
addpath([dir, 'config'   ]);
evalc('addpath([dir, ''help'' ]);',''); %  this is needed cos user may not download help  files
% check if user added the next two files to path, 
% if not, they are added and removed at N_exit
% ps: tools and toolsnc may be always in path cos are useful
p=path;
p=explode(p,pathsep);
tools   = [dir, 'tools'    ];
toolsnc = [dir, 'toolsnc'  ];
if ~ismember(tools,p)
  addpath(tools);
  H.remove_tools=1;
end
if ~ismember(toolsnc,p)
  addpath(toolsnc);
  H.remove_toolsnc=1;
end
end % if 0
% --------------------------------------------------------------------
% set objects positions
% --------------------------------------------------------------------
N_positions;

% --------------------------------------------------------------------
% set theme
% --------------------------------------------------------------------
N_theme('theme 1');

% --------------------------------------------------------------------
% set max var size
% --------------------------------------------------------------------
N_maxsize(300*300,8,'var');  % set initial for variables
N_maxsize(inf,1,'arrows'); % for arrows

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


% next function is here to divide path; it is also included in NCDView/tools dir
function res=explode(str,s)
i=find(str == s);
if isempty(i)
  res={str};
  return
elseif i >=1
  res{1} = str(1:i-1);
  cont=1;
  if i > 1
    for n=1:length(i)-1
      i1=i(n)+1;
      i2=i(n+1)-1;
      cont=cont+1;
      res{cont}=str(i1:i2);
    end
  end
  cont=cont+1;
  evalc('res{cont}=str(i(end)+1:end);','');
end
