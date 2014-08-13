%% Code to estimate LRLD IBLI Rates for Ethiopia/Kenya Forage Type Contract
% JDW 7-2014

UseBiasedRates=1; %Select 1 to use downward biased rates as requested by Apurba. 0 Otherwise.
season='s'; %set season to estimate, 'l' for long, 's' for short
filepathMain=pwd;% or whatever path the datafiles are in, for example'C:\Users\JoshAsus2\Dropbox\IBLIMatlab';
LastLRLDyear=2013;% set last season in historical data for season
LastSRSDyear=2013;% set last season in historical data for season
sensor='eMODIS'; %set the sensor to use from Anton data

%Add path to include needed support files
addpath(genpath(strcat(filepathMain,'\MatlabFunctionFiles\')));
%specify folder with Anton data, which is hopefully in the main folder path
datafolderpath='\z-scoring_first_CalibratedSeries\';
%% Import base NDVI Files for estimation
if season=='l'
    load(strcat(filepathMain,'\LRLDbasedata'));
else
    load(strcat(filepathMain,'\SRSDbasedata'));
end

%% Read UnitID's
AdminIDs=importfileAdmin(filepathMain, datafolderpath);

%% Run rating procedure using all in sample data, unconditional 
%Ethiopia contract has 5 strike levels available, for percetniles 10-30 in
%5% increments

indshiftLRLD=(LastLRLDyear-2002)*2;
indshiftSRSD=(LastSRSDyear-2001)*2;
if strcmp(season,'l')
    %For LRLD we use:
    indexIN=[42:2:42+indshiftLRLD]; 
else
    %For SRSD we use:
    indexIN=[41:2:41+indshiftSRSD];    
end

[ndvipostIN, ndvipreIN,NDVInameIN]=importfileNDVIchoosebase(filepathMain,indexIN, datafolderpath);
ndvipostIN=ndvipostIN.(sensor);
ndvipreIN=ndvipreIN.(sensor);
nIN=size(ndvipostIN,2);

%% import intercalibrated data

if strcmp(season,'l')
    %For LRLD we use:
    indexOUT=2:2:40;
else
    %For SRSD we use:
     indexOUT=3:2:39; 
end

[ndvipostOUT, ndvipreOUT,NDVInameOUT]=importfileNDVIchoosebase(filepathMain,indexOUT, datafolderpath);
ndvipostOUT=ndvipostOUT.(sensor);
ndvipreOUT=ndvipreOUT.(sensor);
nOUT=size(ndvipostOUT,2);

%set up available stikes

strikes=[10:5:30];
nStrike=size(strikes,2);
%Since calibrated values will shrink to the mean, we calc percentiles based
%on in sample data only. jdw 6-2014
%%Updated: Apurba prefers biased percentiles, so now using equally combined
%%intercalibrated and in sample ndvi data for percentiles, jdw, 7-2014

%set other parameters of contract
minpay=.05;
maxpay=.5;
exitpay=min([ndvipostOUT, ndvipostIN]')';

if UseBiasedRates==1
    
    ndvipostComb=[ndvipostOUT, ndvipostIN];
    
    for i=1:nStrike %;loop through all strikes
   
    pstrike(:,i)=prctile( ndvipostComb,strikes(i),2); %note uses intercalibrated and in sample to calc percentiles
    
    for j=1:size( ndvipostComb,1) %loop through all divs 
        for k=1:size( ndvipostComb,2) %loop through all years 
            if ndvipostComb(j,k)<pstrike(j,i)
                yratebiased(j,k)=min(max(((pstrike(j,i)- ndvipostComb(j,k))/(pstrike(j,i)-exitpay(j,1)))*maxpay, minpay),maxpay);
            else
                yratebiased(j,k)=0;
            end
        end
    end
    ratebiased(:,i)=mean( yratebiased ,2);
    end
   
    rateFinal=ratebiased;

else
    %Else use bootstrap correction on intercalibrated

%Estimate post 2001 rate
    for i=1:nStrike %;loop through all strikes
   
        pstrike(:,i)=prctile([ndvipostOUT, ndvipostIN],strikes(i),2); %note uses intercalibrated and in sample to calc percentiles
    
        for j=1:size(ndvipostIN,1) %loop through all divs 
            for k=1:size(ndvipostIN,2) %loop through all years 
                if ndvipostIN(j,k)<pstrike(j,i)
                    yratein(j,k)=min(max(((pstrike(j,i)-ndvipostIN(j,k))/(pstrike(j,i)-exitpay(j,1)))*maxpay, minpay),maxpay);
                else
                  yratein(j,k)=0;
                end
            end
        end
        rateinsample(:,i)=mean( yratein ,2);
       
    %     =IF(C25<C$46,MAX(((C$46-C25)/(C$46-C$44))*C$42, C$43), 0)
    %     =IF(NDVI<pstrike,MAX(((pstrike-NDVI)/(pstrike-EXIT))*maxpay, minpay), 0)
    end

    %Estimate pre 2001 rate using bootstrap to appropriately rescale
    %intercalibrated variance

    for i=1:nStrike %;loop through all strikes
        % pstrike(:,i)=prctile(ndvipostIN,strikes(i),2);
        for g=1:500
            for j=1:nOUT
                bootind=randi(size(bootresid,2),1,1);
                bootsamp(:,j)=bootresid(:,bootind);
                bootsamppre(:,j)=bootresidpre(:,bootind);
            end
            ratendviOUT= ndvipostOUT+bootsamp;     
            for j=1:size( ratendviOUT,1) %loop through all divs 
                for k=1:size( ratendviOUT,2) %loop through all years 
                    if  ratendviOUT(j,k)<pstrike(j,i)
                        yrateOUT(j,k)=min(max(((pstrike(j,i)- min(ratendviOUT(j,k),exitpay(j,1)))/(pstrike(j,i)-exitpay(j,1)))*maxpay, minpay),maxpay);
                    else
                        yrateOUT(j,k)=0;
                    end
                end
            end
            rateboot(:,g)=mean( yrateOUT ,2);
        end
        rateOUTsample(:,i)=mean(  rateboot ,2);
            %     =IF(C25<C$46,MAX(((C$46-C25)/(C$46-C$44))*C$42, C$43), 0)
            %     =IF(NDVI<pstrike,MAX(((pstrike-NDVI)/(pstrike-EXIT))*maxpay, minpay), 0)
    end


    % per Apurba request, weight the intercalibrated dataset more than real
    % dataset per his excel sheet. 
    rateFinal= rateOUTsample.*(nOUT/(nIN+nOUT))+ rateinsample.*(nIN/(nIN+nOUT));

end

%write rates to output

writeIBLI(strcat(filepathMain,'\OutRate\LRLD10rateFinal.csv'),'LRLD10rate',rateFinal(:,1),AdminIDs)
writeIBLI(strcat(filepathMain,'\OutRate\LRLD15rateFinal.csv'),'LRLD15rate',rateFinal(:,2),AdminIDs)
writeIBLI(strcat(filepathMain,'\OutRate\LRLD20rateFinal.csv'),'LRLD20rate',rateFinal(:,3),AdminIDs)
writeIBLI(strcat(filepathMain,'\OutRate\LRLD25rateFinal.csv'),'LRLD25rate',rateFinal(:,4),AdminIDs)
writeIBLI(strcat(filepathMain,'\OutRate\LRLD30rateFinal.csv'),'LRLD30rate',rateFinal(:,5),AdminIDs)
save('LRLDrateFinal.mat','rateFinal');

%% Calculate final index value and indemnity (% payment)  
ImportFinalNDVI_LRLD %imports final NDVI preFINAL and postFINAL
FinalIndexVal=postFINAL;

for i=1:nStrike %;loop through all strikes
   
%     pstrike(:,i)=prctile(ndvipostIN,strikes(i),2);
    
    for j=1:size(postFINAL,1) %loop through all divs 
%         for k=1:size(ndvipostIN,2) %loop through all years 
            if postFINAL(j,1)<pstrike(j,i)
                indemfinal(j,i)=min(max(((pstrike(j,i)-postFINAL(j,1))/(pstrike(j,i)-exitpay(j,1)))*maxpay, minpay),maxpay);
            else
                 indemfinal(j,i)=0;
            end
%         end
    end
 
%     =IF(C25<C$46,MAX(((C$46-C25)/(C$46-C$44))*C$42, C$43), 0)
%     =IF(NDVI<pstrike,MAX(((pstrike-NDVI)/(pstrike-EXIT))*maxpay, minpay), 0)
end

writeIBLI(strcat(filepathMain,'\OutCurrentIndex\LRLD10indem.csv'),'LRLD10indem',indemfinal(:,1),AdminIDs)
writeIBLI(strcat(filepathMain,'\OutCurrentIndex\LRLD15indem.csv'),'LRLD15indem',indemfinal(:,2),AdminIDs)
writeIBLI(strcat(filepathMain,'\OutCurrentIndex\LRLD20indem.csv'),'LRLD20indem',indemfinal(:,3),AdminIDs)
writeIBLI(strcat(filepathMain,'\OutCurrentIndex\LRLD25indem.csv'),'LRLD25indem',indemfinal(:,4),AdminIDs)
writeIBLI(strcat(filepathMain,'\OutCurrentIndex\LRLD30indem.csv'),'LRLD30indem',indemfinal(:,5),AdminIDs)



clear
