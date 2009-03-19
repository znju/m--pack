function out = read_tpxo(grid,model_files,run_path,constituents,vars)
%READ_TPXO   Read TPXO6 tidal data
%   This function will extract data from TPXO6, available free at
%   http://www.coas.oregonstate.edu/research/po/research/tide/index.html
%   It was tested with the North Atlantic regional model.
%
%   Syntax:
%      OUT = READ_TPXO(GRID,MODEL_FILES,RUN_PATH,CONSTITUENTS,VARIABLES)
%
%   Inputs:
%      GRID           ROMS NetCDF grid
%      MODEL_FILES    TPXO model files, structure with fields
%                     .elevation
%                     .transport
%                     .bathymetry
%      RUN_PATH       Path of the TPXO executable extract_HC
%      CONSTITUENTS   Tidal constituents cell array, available are:
%                     m2, s2, n2, k2, k1, o1, p1 and q1
%      VARIABLES      TPXO variables cell array, available are:
%                     z, u, v, U, V
%
%   Output:
%      OUT   Structure with the several amplitude and phase fields
%
%   Example:
%      grid                   = 'ocean_grd.nc';
%      model_files.elevation  = '/home/user/tpxo/DATA/h_NA';
%      model_files.transport  = '/home/user/tpxo/DATA/UV_NA';
%      model_files.bathymetry = '/home/user/tpxo/DATA/grid_NA';
%      run_path               = '/home/user/tpxo/';
%      constituents           = {'m2','s2','n2','k2','k1','o1','p1','q1'};
%      variables              = {'z','u','v'};
%      out = read_tpxo(grid,model_files,run_path,constituents,variables);
%      % the output will be:
%      out.z_m2_amp
%      out.z_m2_pha
%      out.z_s2_amp
%      out.z_...
%      out.u_m2_amp
%      out.u_m2_pha
%      out.u_...
%      out.v_m2_amp
%      out.v_m2_pha
%      out.v_...
%
%   MMA 5-2005, martinho@fis.ua.pt
%
%   See Also GEN_TPXOFRC, PLOT_TIDALFRC

%   Department of Physics
%   University of Aveiro, Portugal

elevation_model_file = model_files.elevation;
transport_model_file = model_files.transport;
bathymetry_grid_file = model_files.bathymetry;
run = 'extract_HC';

n_constituents     = length(constituents);
tidal_constituents = [];
for i=1:n_constituents
  tidal_constituents = [tidal_constituents,constituents{i},','];
end
tidal_constituents = tidal_constituents(1:end-1);

[x,y,h,m] = roms_grid(grid);

% gen lon_lat file:
lon_lat_fname = 'lon_lat_file';
x = reshape(x,prod(size(x)),1);
y = reshape(y,prod(size(y)),1);
xy = [y x];
eval(['save ',lon_lat_fname,' xy -ascii'])

% gen tidal model control file:
control_fname = 'Model_file';
fid = fopen(control_fname','w');
fprintf(fid,'%s\n',elevation_model_file);
fprintf(fid,'%s\n',transport_model_file);
fprintf(fid,'%s\n',bathymetry_grid_file);
fclose(fid);

% gen setup file:
for i = 1:length(vars)
  setup_fname = ['setup_file_',vars{i}];
  output      = ['output_file_',vars{i}];

  fid = fopen(setup_fname','w');
  fprintf(fid,'%s\n',control_fname);       % 1. tidal model control file
  fprintf(fid,'%s\n',lon_lat_fname);       % 2. latitude/longitude/time file
  fprintf(fid,'%s\n',vars{i});             % 3. z/U/V/u/v
  fprintf(fid,'%s\n',tidal_constituents);  % 4. tidal constituents to include
  fprintf(fid,'%s\n','AP');                % 5. AP/RI
  fprintf(fid,'%s\n','oce');               % 6. oce/geo
  fprintf(fid,'%s\n','1');                 % 7. 1/0 correct for minor constituents
  fprintf(fid,'%s\n',output);              % 8. output file (ASCII)
  fclose(fid);
end

% execution:
for i = 1:length(vars)
  setup_fname = ['setup_file_',vars{i}];
  eval(['! ',run_path,run,' < ',setup_fname]);

  % read output:
  output      = ['output_file_',vars{i}];
  fid = fopen(output);
  init = 1;
  str = '************* Site is out of model grid OR land ***************';
  wb = waitbar(0,['reading output: ',num2str(i),' of ',num2str(length(vars))]);
  c = 0;
  eval(['V_',vars{i},' = repmat(0,length(x),2+(n_constituents*2));']);
  while 1
    if mod(c,20) == 0, waitbar(c/length(x),wb); end

    tline = fgetl(fid);
    if ~ischar(tline), break, end
    v = str2num(tline);
    % find begin of data:
    if ~isempty(v) & isempty(findstr(tline,str)), init =  0; end
    if ~init
      c = c+1;
      if isempty(findstr(tline,str))
        eval(['V_',vars{i},'(c,:) = v;']);
      else
        eval(['V_',vars{i},'(c,:) = nan;']);
      end
    end
  end
  fclose(fid);
  close(wb);
end

% gen output:
for i = 1:length(vars)
  for n = 1:n_constituents
    amp = [vars{i},'_',constituents{n},'_amp'];
    pha = [vars{i},'_',constituents{n},'_pha'];

    eval([amp,' = V_',vars{i},'(:,2*n+1);']);
    eval([pha,' = V_',vars{i},'(:,2*n+2);']);

    eval(['out.',amp,' = reshape(',amp,',size(m));']);
    eval(['out.',pha,' = reshape(',pha,',size(m));']);
  end
end

% delete temporary files:
delete(lon_lat_fname);
delete(control_fname);
for i = 1:length(vars)
  setup_fname = ['setup_file_',vars{i}];
  output      = ['output_file_',vars{i}];
  delete(setup_fname);
  delete(output);
end
