function fname = ncep_getfile(year,type)
%NCEP_GETFILE   Download NCEP reanalysis file
%   Download done with UNIX wget from the ftp site
%   ftp://ftp.cdc.noaa.gov/Datasets/ncep.reanalysis/
%   See ncep_settings for details.
%
%   Syntax:
%      FNAME = NCEP_GETFILE(YEAR,TYPE)
%
%   Inputs:
%      YEAR   Each file contains data for one year
%      TYPE   Type of file, the following is currently accepted:
%         - wind:
%             type = 'wind-u' or 'uwnd'          4xDaily u-wind at 10 m                        (m/s)
%             type = 'wind-v' or 'vwnd'          4xDaily v-wind at 10 m                        (m/s)
%             type = 'wind', get both
%         - cloud:
%             type = 'cloud' or 'tcdc'           Total cloud cover                             (%)
%         - radiation:
%             type = 'radiation-sw' or 'nswrs'   4xDaily Net Shortwave Radiation               (W/m^2)
%             type = 'radiation-lw' or 'nlwrs'   4xDaily Net Longwave Radiation                (W/m^2)
%             type = 'radiation-lh' or 'lhtfl'   4xDaily Latent Heat Net Flux at surface       (W/m^2)
%             type = 'radiation-sh' or 'shtfl'   4xDaily Sensible Heat Net Flux at surface     (W/m^2)
%             type = 'radiation', get all
%         - humidity:
%             type = 'humidity' or 'rhum'        4xDaily relative humidity at sigma level 995  (%)
%         - pressure:
%             type = 'pressure' or 'pres'        4xDaily Surface Pressure                      (Pascals)
%         - precipitation:
%             type = 'precipitation' or 'prate'   4xDaily Precipitation Rate at surface         (Kg/m^2/s)
%         - temperature:
%             type = 'temperature' or 'air'      4xDaily Air temperature at 2 m                (degK)
%
%   Output:
%      FNAME   The name file will have. However case file exist fname is
%              the name file has in ftp site, cos at download wget
%              changes the name to fname.1, or fname.2, etc
%
%   Comment:
%      File is downloaded to current directory
%
%   MMA 27-5-2004, martyinho@fis.ua.pt
%
%   See also NCEP_GEN

%   Department of Physics
%   University of Aveiro, Portugal

%   ??-10-2004 - Small changes

Y=num2str(year);

% to be compatible with ncep_gen:
if isequal(type,'uwnd'),  type = 'wind-u';        end
if isequal(type,'vwnd'),  type = 'wind-v';        end
if isequal(type,'tcdc'),  type = 'cloud';         end
if isequal(type,'nswrs'), type = 'radiation-sw';  end
if isequal(type,'nlwrs'), type = 'radiation-lw';  end
if isequal(type,'lhtfl'), type = 'radiation-lh';  end
if isequal(type,'shtfl'), type = 'radiation-sh';  end
if isequal(type,'rhum'),  type = 'humidity';      end
if isequal(type,'pres'),  type = 'pressure';      end
if isequal(type,'prate'), type = 'precipitation'; end
if isequal(type,'air'),   type = 'temperature';   end

[ncep,ftp] = ncep_settings(Y,type);

ftpSite = ftp.site;
command = ftp.run;
%fname   = ncep.file; % output
fname={};
for i = 1:length(ncep)
  file    = ncep(i).file; fname{i}=file;
  path    = ncep(i).path;
  str     = ncep(i).str;
  file = [ftpSite,path,file];

  fprintf(1,'\n');
  fprintf(1,'|------------------------------------------------\n');
  fprintf(1,'|          --- download NCEP file ---\n');
  fprintf(1,'|  type : %s\n',type);
  fprintf(1,'| %s\n',str);
  fprintf(1,'|  location: %s\n',file);
  fprintf(1,'|  using %s\n',command);
  fprintf(1,'\n');

  eval(['! ',command,file])

  fprintf(1,'|  download complete\n');
  str='[s,fs]=unix([''du -hs '',fname])';
  evalc(str,'fs=[]');
  fprintf(1,'|  file size: %s\n',fs);
  fprintf(1,'|------------------------------------------------\n');
  fprintf(1,'\n');
end
