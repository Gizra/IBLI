%% Code to estimate LRLD IBLI Rates
%% Import NDVI Files
filepathMain='C:\Users\JoshAsus2\Dropbox\IBLIMatlab\';
load(strcat(filepathMain,'LRLDbasedata'))
%Add path to include needed files
addpath(genpath(strcat(filepathMain,'MatlabFunctionFiles\')));

%% format data
W=sparse(queenraw(:,1),queenraw(:,2),queenraw(:,3)); %build weight matrix
[N,T]=size(MortwMissing);
xcoordMat=repmat(xyKenya(:,1),1,T);
ycoordMat=repmat(xyKenya(:,2),1,T);
xy1=xcoordMat(:);
xy2=ycoordMat(:);
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

%% Construct X's
%stack
preNDVI=ndvipre(:);
postNDVI=ndvipost(:);
preNDVImax=ndvipremax(:);
postNDVImax=ndvipostmax(:);
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

yNDVIimpact=reshape(((iNT-resC(i).rho*Wt)^-1)*(xC(:,vSpots)*resC(i).beta(vSpots)),N,T);
yNDVIpreimpact=reshape(((iNT-resC(i).rho*Wt)^-1)*(xC(:,vSpotspre)*resC(i).beta(vSpotspre)),N,T);

yFit=reshape(resC(i).yhat,N,T);


%% Run AR models for NDVI
%Note models investigated indicate autocorrelation between years within a
%season (but not across seasons)
%% Run regs
nAR=size(ndvipostAR,2);
xintAR=repmat(buildIntercept(DistID,[DistNum,[1:nDists]']),nAR,1);

xAR=[ndvipreAR(:)];

resAR=ols(ndvipostAR(:),[xAR]);

%currentlagndvi is prev yr season obs 
if firstcontractseason==1
    
    rateprendvi=repmat(currentprendvi,nAR,1); %currentprendvi is 2013 LRLD forecast for first contract offer
    ratendvi=rateprendvi*resAR.beta+resAR.resid;

else
    rateprendvi=ndvipreAR(:);
    ratendvi=ndvipostAR(:);
end
%Calc conditioned current season ndvi

%build xmatrix for rating
NDVIvars_Drate=[matmul(rateprendvi,xintAR),matmul(rateprendvi.^2,xintAR),...
    matmul(ratendvi,xintAR),matmul(ratendvi.^2,xintAR)];
xCrate=[xintAR,NDVIvars_Drate];

%Estimate final fitted y (mortality)
yrate=reshape(kron(eye(nAR,nAR),(eye(nDivs,nDivs)-resC(iIter).rho*W)^-1)*(xCrate*resC(iIter).beta),N,nAR);
trigger=.15;
premrateorig=mean(max(yrate-trigger,0),2);
ratetarget=0.03;
wnot=ones(nDivs,1).*.1;
opt=optimset('fminunc'); %set ops
opt.TolFun=.000000001;
opt.TolX=.000000001;

LB=0;
for i=1:nDivs
    frate=@(x_)(((mean( max(yrate(i,:)+ones(1,nAR).*x_-trigger,0) ,2)-ratetarget)*100).^2);
    [wstar(i,1),fval]=fmincon(frate,0.1,[],[],[],[],LB,[],[],opt);
end

wstar=max(wstar,0);


wstar(premrateorig<ratetarget&wstar<.01)=max(wstar(premrateorig<ratetarget&wstar<.01),mean(wstar(premrateorig<ratetarget)));
wstar=W*wstar.*.3+wstar.*.7;
wstar(premrateorig>ratetarget)=0;
adj=repmat(wstar,nAR,1);
yratein=reshape(kron(eye(nAR,nAR),(eye(nDivs,nDivs)-resC(iIter).rho*W)^-1)*(xCrate*resC(iIter).beta)+adj,N,nAR);

rate10insample=mean( max(yratein-.1,0) ,2);
rate15insample=mean( max(yratein-.15,0) ,2);
yFit=yratein;

%% now do backfill rate using the wstar adjustment and bootstrap
nAR=size(ndvipostAR,2);
xintAR=repmat(buildIntercept(DistID,[DistNum,[1:nDists]']),nAR,1);
xAR=[ndvipreAR(:)];
resAR=ols(ndvipostAR(:),[xAR]);
nAR=size(ndvipostAR,2);
xintAR=repmat(buildIntercept(DistID,[DistNum,[1:nDists]']),nAR,1);
%bootresid is the residuals provided by anton
adj=repmat(wstar,nAR,1);
for i=1:500
    for j=1:nAR
        bootind=randi(size(bootresid,2),1,1);
        bootsamp(:,j)=bootresid(:,bootind);
        bootsamppre(:,j)=bootresidpre(:,bootind);
    end
    if firstcontractseason==1
    
        rateprendvi=repmat(currentprendvi,nAR,1);
        ratendvi=rateprendvi*resAR.beta+resAR.resid+bootsamp(:);
    else
      ratendvi= ndvipostAR(:)+bootsamp(:);
      rateprendvi= ndvipreAR(:)+ bootsamppre(:);
    end

   %build xmatrix for rating plus bootstrap error
    NDVIvars_Drate=[matmul(rateprendvi,xintAR),matmul(rateprendvi.^2,xintAR),...
    matmul(ratendvi,xintAR),matmul(ratendvi.^2,xintAR)];
    xCrate=[xintAR,NDVIvars_Drate];

    yrateout=reshape(kron(eye(nAR,nAR),(eye(nDivs,nDivs)-resC(iIter).rho*W)^-1)*(xCrate*resC(iIter).beta)+adj,N,nAR);

    rate10outsample(:,i)=mean( max(yrateout-.1,0) ,2);
    rate15outsample(:,i)=mean( max(yrateout-.15,0) ,2);
    
end

rate10outsample=mean(rate10outsample,2);
rate15outsample=mean(rate15outsample,2);
credfact=.685;
rateFinal15=rate15outsample.*(1-credfact)+rate15insample.*credfact;
rateFinal10=rate10outsample.*(1-credfact)+rate10insample.*credfact;

%write rates to output
%writes rates to 108x1 matrix in a csv file for all 108 divisions
csvwrite(strcat(filepathMain,'\LRLDratefinal15.csv'),rateFinal15); 
csvwrite(strcat(filepathMain,'\LRLDratefinal10.csv'),rateFinal10); 