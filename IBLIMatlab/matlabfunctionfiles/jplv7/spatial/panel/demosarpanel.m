A=wk1read('cigardemo.wk1',1,0);
W1=wk1read('Spat-Sym-US.wk1');
% Dataset downloaded from www.wiley.co.uk/baltagi/
% Spatial weights matrix constructed by Elhorst
%
% written by: J.Paul Elhorst 9/2004
% University of Groningen
% Department of Economics
% 9700AV Groningen
% the Netherlands
% j.p.elhorst@rug.nl
%
% dimensions of the problem
T=6; % number of time periods
N=46; % number of regions
nobs=N*T;
% row-normalize W
W=normw(W1); % function of LeSage
y=A(:,[3]); % column number in the data matrix that corresponds to the dependent variable
x=A(:,[4,5,6]); % column numbers in the data matrix that correspond to the independent variables
xconstant=ones(nobs,1);
% ----------------------------------------------------------------------------------------
% pooled model corrected for spatial autocorrelation, including intercept
info.lflag=0; % required for exact results
info.model=0;
results=sar_panel(y,[xconstant x],W,T,info); % Elhorst
vnames=strvcat('logcit','constant','logp','logpn','logy');
prt_sp(results,vnames,1); % Elhorst
% ----------------------------------------------------------------------------------------
% spatial fixed effects + spatial autocorrelation
info.lflag=0;
info.model=1;
results2=sar_panel(y,x,W,T,info);
vnames=strvcat('logcit','logp','logpn','logy');
prt_sp(results2,vnames,1);
% ----------------------------------------------------------------------------------------
% time period fixed effects + spatial autocorrelation
info.lflag=0;
info.model=2;
results3=sar_panel(y,x,W,T,info);
vnames=strvcat('logcit','logp','logpn','logy');
prt_sp(results3,vnames,1);
% ----------------------------------------------------------------------------------------
% spatial and time period fixed effects + spatial autocorrelation
info.lflag=0;
info.model=3;
results4=sar_panel(y,x,W,T,info);
vnames=strvcat('logcit','logp','logpn','logy');
prt_sp(results4,vnames,1);

plot(results4.tfe);
title('time fixed effects');
pause;

plot(results4.sfe);
title('spatial fixed effects');


