%RUNSLICEDEMO   Demo for the slice class
%   This will show the features of the slice class
%   In order to work, the file ocean_his_slicedemo.nc
%   must be available.

%   MMA 8-2005, martinho@fis.ua.pt

f        = which(mfilename);
demodir  = f(1:end-length(mfilename)-2);
file     = 'ocean_his_slicedemo.nc';
filename = [demodir,file];

fprintf(1,'\nDemo for the ROMS slice class\n\n');
disp('% :: start slice object:');
disp(['    filename = ',filename]);
echo on
    sc = slice(filename) % or just sc = slice, which will call uigetfile

    pause
% :: make first slice:
    sc.slicej = {'temp',2,50}

    pause
% :: change display dimension:
    sc.dim = 3;
    view([20 50])

    pause
% :: change time index and slice index:
    sc.time = 3; % set time index

    pause
    sc.inct = 1; % increase time index
    pause
    sc.ind = 10; % set slice index
    pause
    sc.inct = -1; % decrease slice index

    pause
% control caxis:
    sc.caxis = [30 40];
    pause
    sc.caxis = []; % go back to default caxis

    pause
% play with s-coordinates parameters:
    sc.dim = {2}; % with {}, the modification takes effect latter
    sc.ind = 55;
    pause
    sc.scoord = [7 1 5] % theta_s, theta_b and hc
    pause % go back to original s-coordinates:
    sc.scoord  = [];

    pause
% other slices available:
    sc.dim = {3};
    sc.slicei = {'temp',4,25}
    pause
    sc.slicek = {'temp',4,7}
    pause
    sc.slicez = {'temp',4,-50}
    pause
    sc.sliceiso = {'salt',4,30}
    % slice iso creates an isosurface. The appearance can be controlled as:
    % sc.sliceiso = {varname,time,isoval,FaceColor,FaceAlpha,EdgeColor,EdgeAlpha,Reduce Patch}
    % not all these options are required but they must keep this sequence.
    % Reduce Patch, if not empty is used by the matlab function reduceparch,
    % and so is > 0 and < 1

    pause
% plot velocity fields (arrows):
    % for this, use any slice, except slice iso, and the variables vel
    % or velbar (ubar x vbar)
    % This is not working with 3-D dimension.
    % Notice that in vertical slices the lengths are scalled in order to allow
    % DataAspectRatio = [1 1 1]; Thus, when using hold on with other variables,
    % the velocity field must come in last place, see next examples.
    % The plotted arrows have the speed as CData, unless using the
    % option color (see bellow)
    sc.slicek = {'vel',4,13,[1 1],1e4}
    % the rate of points used in the i and j direction is here [1 1]
    % and 1e4 stands for the scale, which could also have 2 or 3 elements,
    % example:
    pause
    sc.slicek = {'vel',4,13,[1 2],[1e4 1e5]}
    pause
    % veclocity and vertical slices:
    sc.slicej = {'vel',4,13,1,10}
    pause
    % using color:
    sc.slicej = {'vel',4,13,1,10,'k'}
    pause
    % using hold on:
    sc.slicej = {'temp',4,13};
    sc.hold = 1;
    sc.slicej = {'vel',4,13,1,10,'k'}

    pause
% using contours:
    sc.hold = 0 % or just close the figure
    sc.slicek = {'salt',4,13}
    sc.g2 = 'contour' % sets the 2d display to contour, instead of pcolor
    pause
    % change contour values:
    sc.cvals = [25 30 31] % or sc.cvals = num (n. of contours)
    pause
    % add clabels:
    sc.clabel = 'manual' % or sc.clabel='man' for higher precision, or LabelSpacing
    pause
    % also contours in 3d:
    sc.g3 = 'contourz'
    sc.dim = 3

    pause
% play with bathy:
    sc.show_bathy = 0; % hide
    pause
    sc.show_bathy = 1; % show
    pause
    sc.bathy_vals = 10 % add more bathymetry contours
    % if [], no bathy contours are shown
    pause
    sc.set_bathy = {'facecolor','b'}
    % other options for bathy:
    %  - for contours:  Color, LineStyle and LineWidth
    %  - for surf (3d): FaceColor, FaceAlpha, EdgeColor, EdgeAlpha and material
    pause
    % put labels in bathymetric contours:
    sc.dim = {2};
    sc.slicek = {'salt',3,13};
    sc.clabelh = 'manual' % or man, or num (Labelpacing)

    pause
% play with bottom:
    sc.g2 = 'pcolor'
    sc.slicej = {'temp',4,55};
    sc.show_bottom = 0 % hide
    pause
    sc.show_bottom = 1 % show
    sc.set_bottom = {'color','r'}
    sc.set_bottom = {'linewidth',5}
    % other options: linestyle

    pause
% play with zeta:
    % is the same as for bottom, example:
    sc.set_zeta = {'color','g'}
    sc.set_zeta = {'linewidth',5}

    pause
% play with mask
    % in dim = 2, the mask is shown as marker, in 3d is shown as contour:
    sc.show_mask=0
    pause
    sc.dim=3
    sc.cvals = 10; % notice that cvals had been selected previously !
    sc.show_mask=1
    sc.set_mask = {'LineWidth',2}
    % other options: all options of line and marker

    pause
% play with region border:
    % is the same as for bottom and zeta, example:
    sc.show_border = 0
    pause
    sc.show_border = 1
    sc.set_border = {'color','b'}

    pause
% add a coastline file (.mat file with variables lon and lat):
    % sc.coastline=filename.mat will show the coastline in horizontal
    % 3d slices
    % sc.coastline = 'load' will call uigetfile
    % more options: the same as for bottom, zeta and region border

    pause
% misc: about grid:
    sc.grd
    sc.dim={2}
    sc.grd
    % this shows all except the slice, ie, the bottom, bathy, zeta, ...
    pause
    sc.mr % shows mask_rho

    pause
% misc: animations:
    % you can make animations very fast with the animate method
    % animate(sc,ind1,ind2,dind,type)
    % this will make one flc animation from ind1 to ind2 with interval dind;
    % type can be 'time' (default) or indice.
    % If you start this with no output figure openned the output figures
    % will have the default limits. You can, however create one slice, select
    % the limits you wnat, like making zoom, and then staart the animate
    % which will have the same appearance as the first figure.
    % In order to run, this function requires ImageMagick and ppm2fli or dta.exe,
    % under unix or windows, respectively. See the help of PPM2FLI and DTA2FLI

    pause
% misc: get the slice data
    % [x,y,z,v] = get(sc,'slice_data');
    % or
    % v = get(sc,'slice_data');

    pause
% misc: about limits:
    % sc.limits = 'get'; % store currents limits/view
    % sc.limits = 'set'; % set limits/view to the stored
    % sc.limits = [];    % use default


sc=close(sc);

% ********************************************************************
% and thats it
% for additional help check the site: http://neptuno.fis.ua.pt/~mma
% or the help of the file slice.m
% you may also use my email: martinho@fis.ua.pt
%

echo off
