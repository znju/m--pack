function S_obj_positions
%function S_obj_positions
%Controls positions of SpectrHA objects (buttons,...)
%
%this function is part of SpectrHA utility
%MMA, Jul-2003
%martinho@fis.ua.pt

global HANDLES

len=.07; %length of buttons
hig=.03; %hight of buttons
d=.005;  %separation between buttons

P1=[.035 .02]; % output
P2=[.035 .35]; % radio buttons
P3=[.035 .45]; % spectrum
P4=[.6   .2 ]; % grid

%---------------------------------------------------------------------

%output text:
x=.35;y=.28;
set(HANDLES.txt_head,'Position',[P1(1) P1(2)+y x .03]);
set(HANDLES.output,'Position',  [P1(1) P1(2)   x y  ]);

%spetrum axes:
w=.5;h=.5;
set(HANDLES.spectrum_axes,'position',[P3(1) P3(2) w h]);

%radio buttons:
set(HANDLES.radio_is_serie,'Position',  [P2(1)       P2(2)       len hig] );
set(HANDLES.radio_is_ell,'Position',    [P2(1)       P2(2)+hig+d len hig] );
set(HANDLES.radio_is_station,'Position',[P2(1)+len+d P2(2)       len hig] );
set(HANDLES.radio_is_file,'Position',   [P2(1)+len+d P2(2)+hig+d len hig] );

%spectrum axes's controls:
%xlim:
set(HANDLES.xlim_i,'Position',[P1(1)+x+3*d              P2(2)+hig+d  .5*(len+d) hig]);
set(HANDLES.xlim,'Position',  [P1(1)+x+3*d+.5*(len+d)   P2(2)+hig+d  len        hig]);
set(HANDLES.xlim_e,'Position',[P1(1)+x+3*d+1.5*len+.5*d P2(2)+hig+d  .5*(len+d) hig]);
%grids, zoom & hold:
set(HANDLES.add_grids_spect,'Position',[P1(1)+x+3*d     P2(2)       len hig]);
set(HANDLES.hold_spect,'Position',     [P1(1)+x+4*d+len P2(2)       len hig]);
set(HANDLES.zoom,'Position',           [P1(1)+x+4*d+len P2(2)-d-hig len hig]);

%load external data (mat files):
set(HANDLES.load_file,'Position', [P1(1)+x+3*d     P2(2)-4*d-2*hig len hig]);
set(HANDLES.plot_file,'Position', [P1(1)+x+4*d+len P2(2)-4*d-2*hig len hig]);
set(HANDLES.load_struc,'Position',[P1(1)+x+3*d     P2(2)-5*d-3*hig len hig]);
set(HANDLES.plot_struc,'Position',[P1(1)+x+4*d+len P2(2)-5*d-3*hig len hig]);

%analysis:
set(HANDLES.plot_data,'Position',  [P1(1)+x+3*d     P2(2)-8*d-4*hig  len hig]);
set(HANDLES.fsa,'Position',        [P1(1)+x+4*d+len P2(2)-8*d-4*hig  len hig]);
set(HANDLES.xout,'Position',   [P1(1)+x+3*d     P2(2)-9*d-5*hig  len hig]);
set(HANDLES.lsf,'Position',        [P1(1)+x+4*d+len P2(2)-9*d-5*hig  len hig]);
set(HANDLES.t_tide,'Position',     [P1(1)+x+4*d+len P2(2)-10*d-6*hig len hig]);

%t_predic:
set(HANDLES.datenum_s,'Position', [P1(1)+x+3*d     P2(2)-12*d-7*hig 2*len+d hig]);
set(HANDLES.datenum_e,'Position', [P1(1)+x+3*d     P2(2)-13*d-8*hig 2*len+d hig]);
set(HANDLES.datenum_dt,'Position',[P1(1)+x+3*d     P2(2)-14*d-9*hig len     hig]);
set(HANDLES.predic,'Position',    [P1(1)+x+4*d+len P2(2)-14*d-9*hig len     hig]);

%frames:
posi=get(HANDLES.t_tide,'position');
set(HANDLES.frame_analysis,'position',[posi(1)-2*d-len posi(2)-d 3*d+2*len 4*d+3*hig])
posi=get(HANDLES.load_struc,'position');
set(HANDLES.frame_loadMat,'position', [posi(1)-d       posi(2)-d 3*d+2*len 3*d+2*hig])
posi=get(HANDLES.datenum_dt,'position');
set(HANDLES.frame_predic,'position',  [posi(1)-d       posi(2)-d 3*d+2*len 3.3*d+3*hig])

%---------------------------------------------------------------------

%grid axes:
i=.38; j=.75;
set(HANDLES.grid_axes,'position',[P4(1) P4(2) i j]);

%buttons under grid: load, select, field,...
set(HANDLES.load_grid,'Position',     [P4(1)           P2(2)-12*d-7*hig len hig]); %high of datenum!
set(HANDLES.load_station,'Position',  [P4(1)+d+len     P2(2)-12*d-7*hig len hig]);
set(HANDLES.contours,'Position',      [P4(1)           P2(2)-13*d-8*hig len hig]);
set(HANDLES.label,'Position',         [P4(1)+d+len     P2(2)-13*d-8*hig len hig]);
set(HANDLES.axes_equal,'Position',    [P4(1)+2*d+2*len P2(2)-12*d-7*hig len hig]);
set(HANDLES.add_grids_grid,'Position',[P4(1)+2*d+2*len P2(2)-13*d-8*hig len hig]);
set(HANDLES.select,'Position',        [P4(1)+3*d+3*len P2(2)-12*d-7*hig len hig]);
set(HANDLES.selectN,'Position',       [P4(1)+3*d+3*len P2(2)-13*d-8*hig len hig]);
set(HANDLES.vars,'Position',          [P4(1)+4*d+4*len P2(2)-12*d-7*hig len hig]);
set(HANDLES.vlevels,'Position',       [P4(1)+4*d+4*len P2(2)-13*d-8*hig len hig]);
set(HANDLES.zlevel,'Position',        [P4(1)+4*d+4*len P2(2)-13*d-9*hig len hig]);
set(HANDLES.zcheck,'Position',        [P4(1)+4*d+11/3*len P2(2)-13*d-9*hig len/3 hig]);
