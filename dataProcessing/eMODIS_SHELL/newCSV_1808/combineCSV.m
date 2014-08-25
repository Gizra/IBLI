%% Combine Full seasons from previous years with partial seaon from current year - CSV outputs of the IDL chain


function [] = combineCSV(incsv1,incsv2,outcsv)


data1 = importdata(incsv1);
data2 = importdata(incsv2);

if length(data1.colheaders)>length(data2.colheaders)
     [dataCombined,id1,id2] = union({data1.colheaders},{data2.colheaders});
     idx = 1:length(dataCombined);
     
     
     
     combinetextdata = [{data1.textdata{:,
     combineColHeaders = [{
     combinedData = [{
     
end


end