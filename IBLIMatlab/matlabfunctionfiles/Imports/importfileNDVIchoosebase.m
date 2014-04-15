function [ ndvipost, ndvipre,NDVIname ] = importfileNDVIchoosebase(filepath,postindex, folderpath)



% season='s'; %set season to estimate
% StartYearSRSD=2001;
% EndYearSRSD=2011;
% StartYearLRLD=2002;
% EndYearLRLD=2012;
%Here I indexed to the actual columns in file provided by anton since they
%will likely need to be checked and likely manually updated with updates.

%postindex=index;
preindex=postindex-1;


filesavg = dir(strcat(filepath,folderpath));
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
    ndvipost.(NDVIname{i})=NDVI.(NDVIname{i})(:,postindex);
    ndvipre.(NDVIname{i})=NDVI.(NDVIname{i})(:,preindex);

end










end