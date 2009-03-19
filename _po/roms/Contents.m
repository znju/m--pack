%  roms, Data extraction and analysis of ROMS NetCDF files
%
%    add_hraw           - Copy h from ROMS grid to hr
%    b_smooth           - Smooth ROMS bathymetry
%    editmask           - Edit land mask of ROMS NetCDF grid file
%    fill_border        - Fill around ROMS region
%    find_romsfiles     - Find ROMS filenames
%    flt_age            - Get ROMS float age
%    gen_bry            - Create ROMS boundary file
%    gen_ini            - Create ROMS ini file
%    get_ncepgrib       - Download NCEP grib files form NOMAD
%    get_sigma          - Get s-coordinates parameters from ROMS file (deprecated)
%    get_sta            - Get vertical profile of a ROMS variable (deprecated)
%    hv_dist            - Compute number of grid points according to resolution
%    lon2xcoast         - Convert lon/lat to distance to coast
%    m_hslope           - Compute bathymetry slope
%    minimal_roms_grd   - Create ROMS NetCDF grid file with minimum variables
%    plot_border        - Plot ROMS rho border/extremes box
%    plot_border2d      - Display ROMS grid 2D
%    plot_border3d      - Display ROMS grid boundaries
%    plot_romsflt       - Plot floats from ROMS output floats file
%    plot_romsgrd       - Plot ROMS grid
%    plot_romssta       - Fast way to see all stations of ROMS output
%    roms_border        - Get ROMS slice border
%    roms_clm2ini       - Create ROMS ini file from clm file
%    roms_dt            - Get time info from ROMS output file
%    roms_extractstr    - Get range of ROMS NetCDF variables
%    roms_grid          - Get ROMS grid data x, y, h and mask
%    roms_near          - Search nearest index from point in ROMS file
%    roms_read_out      - Parse ROMS output text file
%    roms_time          - Retrieve time info from ROMS output
%    roms_transpclm     - Transport of ROMS clm file at boundaries
%    roms_ts            - Extract time series and z-profiles from ROMS output
%    roms_tsf           - Filter ROMS time series
%    roms_uvbar         - Compute ROMS barotropic currents from 3d currents
%    ruse               - Extract ROMS NetCDF variables
%    s_levels           - Get vertical s-coordinates levels
%    s_params           - Get s-coordinates parameters from ROMS file
%    show_mask          - Display mask from ROMS grid or history file
%    sta_grid_pos       - Plot ROMS stations location
%    sta_slice          - Slice at ROMS station
%    sta_time           - Get interval and length of ROMS output stations
%    sta_yx             - Get dimensions of longitude in ROMS stations file
%    vertical_slice     - ROMS vertical slice along any path
%    vertical_slice_aux - Auxiliary tool for VERTICAL_SLICE
%
%    [RaV]              - ROMS visualisation interface (rav)
%    [SpectrHA]         - ROMS harmonic analysis gui
%    [roms_ncep]        - Creation of ROMS bulk fluxes forcing files from NCEP database
%    [roms_rivers]      - Creation of ROMS rivers forcing files
%    [roms_slice]       - Extraction of 2D slices from ROMS output NetCDF files
%    [roms_tides]       - Creation of ROMS tides forcing files
%    [slice]            - @slice, object oriented ROMS utility
%
%    mma, 25-Jul-2008 16:54:22
%    poseidon.fisnuc.intranet.ufba.br
