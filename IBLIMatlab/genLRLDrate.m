%% Code to estimate LRLD IBLI Rates

filepathMain=pwd;% or whatever path the datafiles are in, for example'C:\Users\JoshAsus2\Dropbox\IBLIMatlab';
LastLRLDyear=2012;% set last season in historical data for season
LastSRSDyear=2012;% set last season in historical data for season
sensor='eMODIS'; %set the sensor to use from Anton data
season='l'; %set season to estimate, 'l' for long, 's' for short
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
            i
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
csvwrite(strcat(filepathMain,'/LRLDratefinal15.csv'),rateFinal15); 
csvwrite(strcat(filepathMain,'/LRLDratefinal10.csv'),rateFinal10); 

%% Calculate final index value and indemnity (% payment)  
ImportFinalNDVI_LRLD %imports final NDVI preFINAL and postFINAL
xintFINAL=buildIntercept(DistID,[DistNum,[1:nDists]']);
 NDVIvars_FINAL=[matmul(preFINAL,xintFINAL),matmul(preFINAL.^2,xintFINAL),...
    matmul(postFINAL,xintFINAL),matmul(postFINAL.^2,xintFINAL)];
xFINAL=[xintFINAL  NDVIvars_FINAL];

FinalIndexVal_LRLD=max(0,(eye(nDivs,nDivs)-resC(iIter).rho*W)^-1*(xFINAL*resC(iIter).beta));
IndemFinal15=max(FinalIndexVal_LRLD-.15,0);
IndemFinal10=max(FinalIndexVal_LRLD-.10,0);

csvwrite(strcat(filepathMain,'/LRLDfinalIndex.csv'),FinalIndexVal_LRLD);
csvwrite(strcat(filepathMain,'/LRLDfinalIndem15.csv'),IndemFinal15);
csvwrite(strcat(filepathMain,'/LRLDfinalIndem10.csv'),IndemFinal10);

clear
