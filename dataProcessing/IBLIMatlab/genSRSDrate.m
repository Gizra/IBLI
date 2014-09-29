<<<<<<< HEAD
%% Code to estimate LRLD IBLI Rates

filepathMain=pwd;% or whatever path the datafiles are in, for example'C:\Users\JoshAsus2\Dropbox\IBLIMatlab';
LastLRLDyear=2012;% set last season in historical data for season
LastSRSDyear=2012;% set last season in historical data for season
sensor='eMODIS'; %set the sensor to use from Anton data
season='s'; %set season to estimate, 'l' for long, 's' for short
%Add path to include needed support files
addpath(genpath(strcat(filepathMain,'/matlabfunctionfiles/')));
%specify folder with Anton data, which is hopefully in the main folder path
datafolderpath='/z-scoring_first_CalibratedSeries/';
%% Import base NDVI Files for estimation
if season=='l'
    load(strcat(filepathMain,'/LRLDbasedata'));

else
    load(strcat(filepathMain,'/SRSDbasedata'));
end

%import ndvi data for model fitting
[ ndvipost, ndvipre, NDVIname ] = importfileNDVIbase(filepathMain,season,datafolderpath);
ndvipost=ndvipost.(sensor);
ndvipre=ndvipre.(sensor);


%% format data for estimation.
W=sparse(queenraw(:,1),queenraw(:,2),queenraw(:,3)); %build weight matrix
[N,T]=size(MortwMissing);
MortMissStack=MortwMissing(:);
iN=eye(N,N); %identity matrix for yields
trendVec=[1:T]';
iT=eye(T,T); % %identity matrix for time to create panel weight matrix
Wt=kron(iT,W); % create panel weight matrix
iNT=kron(iT,iN);
iTout=eye(T-1,T-1);
Wtout=kron(iTout,W);
iNTout=kron(iTout,iN);
DIVids=[1:N]'; %108 divs
div_idmat=repmat(DIVids,T,1); %stack an id matrix for resorting later
[nObs,~]=size(MortMissStack);
[nDists,~]=size(DistNum);
%% Build district and county xint and xtrends
xint_C=repmat(buildIntercept(DIVids,[DIVids,DIVids]),T,1); %replicate T tilings
xint_D=repmat(buildIntercept(DistID,[DistNum,[1:nDists]']),T,1); %replicate T tilings
xtrend_C=buildtrend(DIVids,[DIVids,DIVids],trendVec);
xtrend_D=buildtrend(DIVids,[DistNum,[1:nDists]'],trendVec); %build it using the yield div addresses and DivNum match

%% set panel model options
panelinfo.rmin=.1; %just to speed it up
panelinfo.rmax=1; %just to speed it up
panelinfo.model = 0; %default
panelinfo.lflag=1; %default
panelinfo.order =50; %default
panelinfo.iter =30; %default

% Construct X's for estimaation
%stack
preNDVI=ndvipre(:);
postNDVI=ndvipost(:);

%Note for prelim rates, we used district level fixed intercept and variable effects
NDVIvars_D=[matmul(preNDVI,xint_D),matmul(preNDVI.^2,xint_D),matmul(postNDVI,xint_D),...
    matmul(postNDVI.^2,xint_D)];

xC=[xint_D,NDVIvars_D];
vSpots=[size(xC,2)-size(NDVIvars_D,2)./2+1:size(xC,2)];
vSpotspre=[size(xC,2)-size(NDVIvars_D,2)+1:size(xC,2)-size(NDVIvars_D,2)./2];

%Treat as missing if obs don't meet certain criteria
MortMissStack(postNDVI<-6&MortMissStack<.1)=NaN; % if implausibly low
MortMissStack(postNDVI>-1&postNDVI<1&MortMissStack>.1)=NaN; %if implausibly high
MortMissStack(MortMissStack>1)=NaN; %if implausibly high
MortMissStack(MortMissStack<.02)=NaN;%if implausibly low
NumMissing=sum(isnan(MortMissStack));
missValsIndic=isnan(MortMissStack);
MortStack=MortMissStack(~isnan(MortMissStack));
MeanMort=mean(MortStack);
yinit=MortMissStack;
yinit(isnan(MortMissStack))=MeanMort;
%% Run spatial model, and rerun successsively replacing missings with expectations
iIter=10; % number of iterations
ytemp=yinit; %set temp variable
yfit(:,1)=ytemp;

for i=1:iIter %iterate to find fitted model with missing
            i/iIter
            resC(i)=sar_panel(ytemp,xC,W,T,panelinfo);
            Residtemp=resC(i).resid;
            Residtemp(isnan(MortMissStack))=0;
            ytemp=((iNT-resC(i).rho*Wt)^-1)*(xC*resC(i).beta+Residtemp);
            ytemp=max(ytemp,0);
            ytemp(~isnan(MortMissStack))=yinit(~isnan(MortMissStack));
            yfit(:,i+1)=ytemp;

end

%% Run rating procedure using all in sample data, unconditional
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
xintIN=repmat(buildIntercept(DistID,[DistNum,[1:nDists]']),nIN,1);
rateprendviIN=ndvipreIN(:);
ratendviIN=ndvipostIN(:);
NDVIvars_rateIN=[matmul(rateprendviIN,xintIN),matmul(rateprendviIN.^2,xintIN),...
    matmul(ratendviIN,xintIN),matmul(ratendviIN.^2,xintIN)];
xCrateIN=[xintIN,NDVIvars_rateIN];

%Estimate final fitted y (mortality)
yratein=reshape(kron(eye(nIN,nIN),(eye(nDivs,nDivs)-resC(iIter).rho*W)^-1)*(xCrateIN*resC(iIter).beta),N,nIN);

%Estimate post 2001 rate
rate10insample=mean( max(yratein-.1,0) ,2);
rate15insample=mean( max(yratein-.15,0) ,2);


%% now do backfill rate using the wstar adjustment and bootstrap

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
xintOUT=repmat(buildIntercept(DistID,[DistNum,[1:nDists]']),nOUT,1);

%bootresid is the residuals provided by anton, already in base data file
rng('default');
for i=1:500
    for j=1:nOUT
        bootind=randi(size(bootresid,2),1,1);
        bootsamp(:,j)=bootresid(:,bootind);
        bootsamppre(:,j)=bootresidpre(:,bootind);
    end
    ratendviOUT= ndvipostOUT(:)+bootsamp(:);
    rateprendviOUT= ndvipreOUT(:)+ bootsamppre(:);
    %build xmatrix for rating plus bootstrap error
    NDVIvars_rateOUT=[matmul(rateprendviOUT,xintOUT),matmul(rateprendviOUT.^2,xintOUT),...
    matmul(ratendviOUT,xintOUT),matmul(ratendviOUT.^2,xintOUT)];
    xCrateOUT=[xintOUT,NDVIvars_rateOUT];
    yrateout=reshape(kron(eye(nOUT,nOUT),(eye(nDivs,nDivs)-resC(iIter).rho*W)^-1)*(xCrateOUT*resC(iIter).beta),N,nOUT);
    rate10outsample(:,i)=mean( max(yrateout-.1,0) ,2);
    rate15outsample(:,i)=mean( max(yrateout-.15,0) ,2);
end

rate10outsample=mean(rate10outsample,2);
rate15outsample=mean(rate15outsample,2);
credfact=1-(1-nIN/(nIN+nOUT))/2;
rateFinal15=rate15outsample.*(1-credfact)+rate15insample.*credfact;
rateFinal10=rate10outsample.*(1-credfact)+rate10insample.*credfact;

%write rates to output
%writes rates to 108x1 matrix in a csv file for all 108 divisions
csvwrite(strcat(filepathMain,'/SRSDratefinal15.csv'),rateFinal15);
csvwrite(strcat(filepathMain,'/SRSDratefinal10.csv'),rateFinal10);

%% Calculate final index value and indemnity (% payment)
ImportFinalNDVI_SRSD %imports final NDVI preFINAL and postFINAL
xintFINAL=buildIntercept(DistID,[DistNum,[1:nDists]']);
 NDVIvars_FINAL=[matmul(preFINAL,xintFINAL),matmul(preFINAL.^2,xintFINAL),...
    matmul(postFINAL,xintFINAL),matmul(postFINAL.^2,xintFINAL)];
xFINAL=[xintFINAL  NDVIvars_FINAL];

FinalIndexVal_SRSD=max(0,(eye(nDivs,nDivs)-resC(iIter).rho*W)^-1*(xFINAL*resC(iIter).beta));
IndemFinal15=max(FinalIndexVal_SRSD-.15,0);
IndemFinal10=max(FinalIndexVal_SRSD-.10,0);

csvwrite(strcat(filepathMain,'/SRSDfinalIndex.csv'),FinalIndexVal_SRSD);
csvwrite(strcat(filepathMain,'/SRSDfinalIndem15.csv'),IndemFinal15);
csvwrite(strcat(filepathMain,'/SRSDfinalIndem10.csv'),IndemFinal10);

clear
=======
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

writeIBLI(strcat(filepathMain,'\OutRate\SRSD10rateFinal.csv'),'SRSD10rate',rateFinal(:,1),AdminIDs)
writeIBLI(strcat(filepathMain,'\OutRate\SRSD15rateFinal.csv'),'SRSD15rate',rateFinal(:,2),AdminIDs)
writeIBLI(strcat(filepathMain,'\OutRate\SRSD20rateFinal.csv'),'SRSD20rate',rateFinal(:,3),AdminIDs)
writeIBLI(strcat(filepathMain,'\OutRate\SRSD25rateFinal.csv'),'SRSD25rate',rateFinal(:,4),AdminIDs)
writeIBLI(strcat(filepathMain,'\OutRate\SRSD30rateFinal.csv'),'SRSD30rate',rateFinal(:,5),AdminIDs)
save('SRSDrateFinal.mat','rateFinal');

%% Calculate final index value and indemnity (% payment)  
ImportFinalNDVI_SRSD %imports final NDVI preFINAL and postFINAL
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

writeIBLI(strcat(filepathMain,'\OutCurrentIndex\SRSD10indem.csv'),'SRSD10indem',indemfinal(:,1),AdminIDs)
writeIBLI(strcat(filepathMain,'\OutCurrentIndex\SRSD15indem.csv'),'SRSD15indem',indemfinal(:,2),AdminIDs)
writeIBLI(strcat(filepathMain,'\OutCurrentIndex\SRSD20indem.csv'),'SRSD20indem',indemfinal(:,3),AdminIDs)
writeIBLI(strcat(filepathMain,'\OutCurrentIndex\SRSD25indem.csv'),'SRSD25indem',indemfinal(:,4),AdminIDs)
writeIBLI(strcat(filepathMain,'\OutCurrentIndex\SRSD30indem.csv'),'SRSD30indem',indemfinal(:,5),AdminIDs)

clear
>>>>>>> 431b3b8de769b0bc4113d4e87351c8ca72810110
