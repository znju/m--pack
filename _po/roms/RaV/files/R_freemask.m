function R_freemask

% free mask of his or grid file

global H

% get fname:
fname = get(H.ROMS.axes_title,'string');
if isempty(fname)
  return
end

%editmask(fname);
figure
show_mask(fname);

if 0
  nc=netcdf(fname);
    m=nc{'mask_rho'}(:);
  nc=close(nc);

  figure,
  pcolor(m);
  colormap([.5 .5 .5; 1 1 1]);
end

title(['mask_rho from file ',fname],'interpreter','none');

