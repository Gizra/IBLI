% Main Program for Forage contract
% Runs SRSD and LRLD rating and then combines
% last update 7-12-2014
genSRSDrate
genLRLDrate

%get AdminIDS
filepathMain=pwd;%
datafolderpath='\z-scoring_first_CalibratedSeries\';
AdminIDs=importfileAdmin(filepathMain, datafolderpath);

% read and combine rates for Annual
LRLD=load('LRLDrateFinal.mat');
SRSD=load('SRSDrateFinal.mat');

%calc total rate
rateFinal=LRLD.rateFinal+SRSD.rateFinal;

writeIBLI(strcat(filepathMain,'\OutRate\10rateFinal.csv'),'10rateFinal',rateFinal(:,1),AdminIDs);
writeIBLI(strcat(filepathMain,'\OutRate\15rateFinal.csv'),'15rateFinal',rateFinal(:,2),AdminIDs);
writeIBLI(strcat(filepathMain,'\OutRate\20rateFinal.csv'),'20rateFinal',rateFinal(:,3),AdminIDs);
writeIBLI(strcat(filepathMain,'\OutRate\25rateFinal.csv'),'25rateFinal',rateFinal(:,4),AdminIDs);
writeIBLI(strcat(filepathMain,'\OutRate\30rateFinal.csv'),'30rateFinal',rateFinal(:,5),AdminIDs);

clear
% exit