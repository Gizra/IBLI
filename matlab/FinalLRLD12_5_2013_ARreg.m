%% Run AR models for NDVI
%Note models investigated indicate autocorrelation between years within a
%season (but not across seasons)
% filepathAR='C:\Users\Joshua\Dropbox\IndexLivestock\FinalAnalysis2013\';
% % season='s'; %set season to estimate
% folderpathAR='z-scoring_first_CalibratedSeries\';
filepathAR=filepath;
% season='s'; %set season to estimate
folderpathAR=folderpath;
post2001=1; %use only post 2001 data for regs
if strcmp(season,'l')
    %For SRSD we use:
    if post2001==0; indexAR=3:2:63; else  indexAR=[42:2:62]; end;
else
    %For LRLD we use:
    if post2001==0; indexAR=2:2:62; else  indexAR=[41:2:61]; end;    
end

[ndvipostAR, ndvipreAR,NDVInameAR]=importfileNDVIchoosebase(filepathAR,indexAR, folderpathAR);
%this is the lagged season 1 year previous (i.e., if LRLD then this is
%previous year LRLD
% [ndvipostAR2, ndvipreAR2,NDVInameAR2]=importfileNDVIchoosebase(filepathAR,indexAR-2, folderpathAR);

%[ndvipostAR, ndvipreAR,NDVInameAR]=importfileNDVIbase(filepath,season, folderpath);
ndvipostAR=ndvipostAR.(sensor);
ndvipreAR=ndvipreAR.(sensor);
% ndvipostAR2=ndvipostAR2.(sensor);
% ndvipreAR2=ndvipreAR2.(sensor);
%% Run regs
nAR=size(ndvipostAR,2);
xintAR=repmat(buildIntercept(DistID,[DistNum,[1:nDists]']),nAR,1);
% xAR=[matmul(ndvipreAR(:),xintAR)];
% xAR=[matmul(ndvipostAR2(:),xintAR)];
% xAR=[ndvipreAR(:),ndvipostAR2(:), ndvipreAR2(:)];
xAR=[ndvipreAR(:)];
%xAR=[matmul(ndvipreAR(:),xintAR)];
%xAR=kron(eye(nAR,nAR),W)*kron(eye(nAR,nAR),W)*[matmul(ndvipreAR(:),xintAR)];
%resAR=sar_panel(ndvipostAR(:),xAR,W,size(indexAR,2),panelinfo);
% sqrt(mean((resAR.yhat-ndvipostAR(:)).^2))
resAR=ols(ndvipostAR(:),[xAR]);

%currentlagndvi is prev yr season obs 
if firstcontractseason==1
    
    rateprendvi=repmat(currentprendvi,nAR,1); %currentprendvi is 2013 LRLD forecast for first contract offer
%     ratelagndvi=repmat(currentlagndvi,nAR,1);
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
% opt.MaxIter=100000;
% opt.MaxFunEvals=100000;
  opt.TolFun=.000000001;
  opt.TolX=.000000001;
% %opt.NonlEqnAlgorithm='lm';
% %opt.Display='off';
% %opt.LargeScale='off';
%opt.Algorithm='sqp';
% %opt.Algorithm='interior-point';
% %opt.Algorithm='interior-point';
% %opt.Algorithm='active-set';
% %opt.Algorithm='trust-region-reflective';
% frate(.05)
%  ((  (mean( max(yrate(i,:)+ones(1,nAR).*.0-trigger,0) ,2)-ratetarget)*100   ).^2);
LB=0;
% UB=.2.*ones(nDivs,1);
for i=1:nDivs
% frate=@(x_)(mean(abs(mean(max(yrate+matmul(ones(size(yrate)),x_)-trigger,0),2)-ratetarget)));
    frate=@(x_)(((mean( max(yrate(i,:)+ones(1,nAR).*x_-trigger,0) ,2)-ratetarget)*100).^2);
    [wstar(i,1),fval]=fmincon(frate,0.1,[],[],[],[],LB,[],[],opt);
end
%mean(max(yrate(i,:)+ones(1,nAR).*wstar(i,1)-trigger,0) ,2)
% [wstar,fval]=fmincon(frate,wnot,[],[],[],[],LB,UB,[],opt);
% [wstar,fval]=fminunc(frate,0.1,opt);
wstar=max(wstar,0);
% adj=repmat(W*wstar.*.4+wstar.*.6,nAR,1);

wstar(premrateorig<ratetarget&wstar<.01)=max(wstar(premrateorig<ratetarget&wstar<.01),mean(wstar(premrateorig<ratetarget)));
wstar=W*wstar.*.3+wstar.*.7;
wstar(premrateorig>ratetarget)=0;
adj=repmat(wstar,nAR,1);
yratein=reshape(kron(eye(nAR,nAR),(eye(nDivs,nDivs)-resC(iIter).rho*W)^-1)*(xCrate*resC(iIter).beta)+adj,N,nAR);

% adj=repmat((eye(nDivs,nDivs)-resC(iIter).rho*W)*wstar,nAR,1);
rate10insample=mean( max(yratein-.1,0) ,2);
rate15insample=mean( max(yratein-.15,0) ,2);
yFit=yratein;

%% now do backfill rate using the wstar adjustment and bootstrap


post2001=0; %use only post 2001 data for regs
if strcmp(season,'l')
    %For SRSD we use:
    if post2001==0; indexAR=2:2:40; else  indexAR=[42:2:62]; end;
else
    %For LRLD we use:
    if post2001==0; indexAR=2:2:62; else  indexAR=[41:2:61]; end;    
end

[ndvipostAR, ndvipreAR,NDVInameAR]=importfileNDVIchoosebase(filepathAR,indexAR, folderpathAR);
%this is the lagged season 1 year previous (i.e., if LRLD then this is
%previous year LRLD
% [ndvipostAR2, ndvipreAR2,NDVInameAR2]=importfileNDVIchoosebase(filepathAR,indexAR-2, folderpathAR);

%[ndvipostAR, ndvipreAR,NDVInameAR]=importfileNDVIbase(filepath,season, folderpath);
ndvipostAR=ndvipostAR.(sensor);
ndvipreAR=ndvipreAR.(sensor);
nAR=size(ndvipostAR,2);
xintAR=repmat(buildIntercept(DistID,[DistNum,[1:nDists]']),nAR,1);
% xAR=[matmul(ndvipreAR(:),xintAR)];
% xAR=[matmul(ndvipostAR2(:),xintAR)];
% xAR=[ndvipreAR(:),ndvipostAR2(:), ndvipreAR2(:)];
xAR=[ndvipreAR(:)];
%xAR=[matmul(ndvipreAR(:),xintAR)];
%xAR=kron(eye(nAR,nAR),W)*kron(eye(nAR,nAR),W)*[matmul(ndvipreAR(:),xintAR)];
%resAR=sar_panel(ndvipostAR(:),xAR,W,size(indexAR,2),panelinfo);
% sqrt(mean((resAR.yhat-ndvipostAR(:)).^2))
resAR=ols(ndvipostAR(:),[xAR]);

nAR=size(ndvipostAR,2);
xintAR=repmat(buildIntercept(DistID,[DistNum,[1:nDists]']),nAR,1);




% 
% nDivs*nAR
%bootresid is the residuals provided by anton
adj=repmat(wstar,nAR,1);
for i=1:500
    for j=1:nAR
        bootind=randi(size(bootresid,2),1,1);
        bootsamp(:,j)=bootresid(:,bootind);
        bootsamppre(:,j)=bootresidpre(:,bootind);
    end
    if firstcontractseason==1
    
        rateprendvi=repmat(currentprendvi,nAR,1);%+ bootsamppre(:);%currentprendvi is 2013 LRLD forecast for first contract offer
%       ratelagndvi=repmat(currentlagndvi,nAR,1);
        ratendvi=rateprendvi*resAR.beta+resAR.resid+bootsamp(:);%need to sample if from srsd!!!!!!!

    else
      ratendvi= ndvipostAR(:)+bootsamp(:);
      rateprendvi= ndvipreAR(:)+ bootsamppre(:);
    end

   %build xmatrix for rating plus bootstrap error
    NDVIvars_Drate=[matmul(rateprendvi,xintAR),matmul(rateprendvi.^2,xintAR),...
    matmul(ratendvi,xintAR),matmul(ratendvi.^2,xintAR)];
    xCrate=[xintAR,NDVIvars_Drate];

    yrateout=reshape(kron(eye(nAR,nAR),(eye(nDivs,nDivs)-resC(iIter).rho*W)^-1)*(xCrate*resC(iIter).beta)+adj,N,nAR);


    % adj=repmat((eye(nDivs,nDivs)-resC(iIter).rho*W)*wstar,nAR,1);
    rate10outsample(:,i)=mean( max(yrateout-.1,0) ,2);
    rate15outsample(:,i)=mean( max(yrateout-.15,0) ,2);
    
end

rate10outsample=mean(rate10outsample,2);
rate15outsample=mean(rate15outsample,2);
credfact=.685;
rateFinal15=rate15outsample.*(1-credfact)+rate15insample.*credfact;
rateFinal10=rate10outsample.*(1-credfact)+rate10insample.*credfact;
clear xintAR xAR ndvipremaxAR ndvipostmaxAR ndvipreAR ndvipostAR  indexAR filepathAR resAR nAR xCrate NDVIvars_Drate rateprendvi ratendvi


