function [ ndvipost, ndvipre,NDVIname ] = importfileNDVIbase(filepath,season, folderpath)



% season='s'; %set season to estimate
% StartYearSRSD=2001;
% EndYearSRSD=2011;
% StartYearLRLD=2002;
% EndYearLRLD=2012;
%Here I indexed to the actual columns in file provided by anton since they
%will likely need to be checked and likely manually updated with updates.
% Sndvipost82index=[3:2:61];
% Sndvipre82index=Sndvipost82index-1;
Sndvipost2001index=[41:2:61];
Sndvipre2001index=Sndvipost2001index-1;

% Lndvipost82index=[2:2:62];
% Lndvipre82index=Lndvipost82index-1;
Lndvipost2001index=[42:2:62];
Lndvipre2001index=Lndvipost2001index-1;




%folderpathavg='z-scoring_first_CalibratedSeries\';%'Avgz_base2001L-2011L\'; %'Avgz_base1981S-2012S\'
filesavg = dir(strcat(filepath,folderpath));
%filesavg = dir(strcat(filepath,));
fileIndexavg = find(~[filesavg.isdir]);
nfilesavg = length(fileIndexavg);
% filesmax = dir(strcat(filepath,'Maxz_base1981S-2012S\'));
% fileIndexmax = find(~[filesmax.isdir]);
% nfilesmax = length(fileIndexmax);

for i=1:nfilesavg
        fileNameavg{i}= filesavg(fileIndexavg(i)).name;
        filename = strcat(filepath,folderpath,fileNameavg{i});
        [token, remain] = strtok(fileNameavg{i}, '.');
        [token1, remain] = strtok(token, '_');
        [token2, remain] = strtok(remain, '_');
        [sat, remain] = strtok(remain, '_');
        if strcmp(sat,'BOKU')
            [token3, remain] = strtok(remain, '_');
            [sat, remain] = strtok(remain, '_');
            sat=strcat('BOKU',sat);
        end
        NDVIname{i}=sprintf('%s',sat);
        NDVI.(NDVIname{i})= importfileNDVI(filename);
end

% for i=1:nfilesmax
%         fileNamemax{i}= filesmax(fileIndexmax(i)).name;
%         filename = strcat(filepath,'Maxz_base1981S-2012S\',fileNamemax{i});
%
%         [token, remain] = strtok(fileNamemax{i}, '.');
%         [token1, remain] = strtok(token, '_');
%         [token2, remain] = strtok(remain, '_');
%         [sat, remain] = strtok(remain, '_');
%         if strcmp(sat,'BOKU')
%             [token3, remain] = strtok(remain, '_');
%             [sat, remain] = strtok(remain, '_');
%             sat=strcat('BOKU',sat);
%         end
%         NDVInamemax{i}=sprintf('%s',sat);
%         NDVImax.(NDVInamemax{i})= importfileNDVI(filename);
% end
% importNDVIavg=NDVI;
% importNDVImax=NDVImax;


nsats=nfilesavg;


for i=1:nsats
    %these are vals parsed out by pre, post, max, avg, L and S seasons
    sndvipostavg2001.(NDVIname{i})=NDVI.(NDVIname{i})(:,Sndvipost2001index);
    sndvipreavg2001.(NDVIname{i})=NDVI.(NDVIname{i})(:,Sndvipre2001index);


    lndvipostavg2001.(NDVIname{i})=NDVI.(NDVIname{i})(:,Lndvipost2001index);
    lndvipreavg2001.(NDVIname{i})=NDVI.(NDVIname{i})(:,Lndvipre2001index);


end


if strcmp(season,'s')

     ndvipost=sndvipostavg2001;
     ndvipre=sndvipreavg2001;


else

     ndvipost=lndvipostavg2001;
     ndvipre=lndvipreavg2001;


end












end
