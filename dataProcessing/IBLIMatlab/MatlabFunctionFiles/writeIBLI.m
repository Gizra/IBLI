%Write to final format per Anton specs with AdminID in first col and name
%of variabel and values in second

function []=writeIBLI(filename,varname,dat,AdminIDs)

%write first column
FID=fopen(filename,  'w+');
fprintf(FID, '%s \n',strcat('UnitID,',varname)); 
fclose(FID);

%append data to file
dlmwrite(filename,[AdminIDs dat], '-append','delimiter',',','precision','%10.5f','roffset',0);

end