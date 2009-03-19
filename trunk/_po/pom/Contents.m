%  pom, Data extraction and analysis of POM files
%
%    grd_pom2roms - Create ROMS NetCDF grid from POM text grid
%    plot_pomgrd  - Plot POM grid
%    pom_border   - Get POM slice border
%    pom_grid     - Get POM grid data x, y, h and mask
%    pom_gridtxt  - Read POM gid text file
%    pom_read_out - Extract EK from POM output
%    pom_rho2u_2d - Transform 2D array from rho to u points
%    pom_rho2uv   - Transform lon,lat from rho to u and v points
%    pom_rho2v_2d - Transform 2D array from rho to v points
%    pom_s_levels - Get POM vertical s-coordinates levels
%    pom_slicei   - Make POM slice across y direction (x=const)
%    pom_slicej   - Make POM slice across x direction (y=const)
%    pom_slicek   - Make POM slice at s-level (k=const)
%    pom_slicell  - Make POM slice along any path
%    pom_sliceuv  - Get horizontal velocity field at POM slice
%    pom_slicez   - Make POM slice at z=const
%    pom_transpij - POM transport across fixed index vertical section
%    roms2pombin  - Create POM input binary files from ROMS input files
%
%    mma, 25-Jul-2008 16:54:21
%    poseidon.fisnuc.intranet.ufba.br
