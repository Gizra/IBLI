% PURPOSE: computes spatial error model estimates for spatial panels (N regions*T time periods)
%           y = XB + u + v,  u vector of spatial random effects, v = p*W*v + e, 
% Supply data sorted first by time and then by spatial units, so first region 1,
% region 2, et cetera, in the first year, then region 1, region 2, et
% cetera in the second year, and so on

% written by: J.Paul Elhorst 11/2006
% University of Groningen
% Department of Economics
% 9700AV Groningen
% the Netherlands
% j.p.elhorst@rug.nl
%
% REFERENCES: 
% "Specification and Estimation of Spatial Panel Data Models",
% International Regional Science Review, Vol. 26, pp. 244-268.

A=wk1read('g:\lotus\cigardemo.wk1',1,0);
% dimensions of the problem
N=46; % number of spatial units
T=6; % number of time periods
K=4; % number of explanatory variables
nobs=N*T;
% normalize W if still necessary
y=A(:,[3]); % column number in the data matrix that corresponds to the dependent variable
x=A(:,[7,4,5,6]); % column numbers in the data matrix that correspond to the independent variables

% random effects estimator by maximum likelihood + spatial autocorrelation
W1=wk1read('g:\lotus\Spat-Sym-US.wk1'); %W1 in raw-form, should be symmetric and not row-normalized
options.disp=0;
lambda=eigs(W1,1,'LA',options);
W=W1/lambda;
clear W1;
wy=zeros(N*T,1);
wx=zeros(N*T,K);
for t=1:T
   ti=1+(t-1)*N;tj=t*N;
   wy(ti:tj)=W*y(ti:tj);
   wx(ti:tj,:)=W*x(ti:tj,:);
end
delta=1;alpha=0.1;iter=0;converge=1.0;criteria=0.00001;itermax=100;
options.Display='off';
options.MaxFunEvals=1000;
options.MaxIter=1000;
options.TolX=0.005;
options.TolFun=0.001;
eigw=zeros(N,1);
[V D]=eig(W);
lambda=diag(D);
clear D;

for i=1:N
    ym=zeros(T,1);
    xm=zeros(T,K);
    for t=1:T
        ym(t)=y(i+(t-1)*N,1);
        xm(t,:)=x(i+(t-1)*N,:);
    end
    meany(i,1)=mean(ym);
    meanx(i,:)=mean(xm);
end
clear ym wym xm;

wmeany=W*meany;
wmeanx=W*meanx;
vmeany=V'*meany;
vmeanx=V'*meanx;
clear V;

while ( converge>criteria & iter < itermax)
   iter=iter+1;
   deltaold=delta;
   alphaold=alpha;
   b=[delta;alpha];
   ee=ones(T,1);
   eigw=zeros(N,1);
   for i=1:N
      eigw(i)=(T*delta^2+1/(1-alpha*lambda(i))^2)^(-0.5);
      meanpy(i,1)=eigw(i)*vmeany(i,1)-(meany(i,1)-alpha*wmeany(i,1));
      meanpx(i,:)=eigw(i)*vmeanx(i,:)-(meanx(i,:)-alpha*wmeanx(i,:));
   end
   yran=y-alpha*wy+kron(ee,meanpy);
   xran=x-alpha*wx+kron(ee,meanpx);
   results=ols(yran,xran);
   beta=results.beta;
   res=results.resid;
   btemp=fminsearch('f_respat',b,options,beta,y,x,wy,wx,lambda,meany,meanx,wmeany,wmeanx,vmeany,vmeanx,N,T); %elhorst
   delta=btemp(1);
   alpha=btemp(2);
   converge=abs(alpha-alphaold)+abs(delta-deltaold);
end
iter
res=results.resid;
res2=res'*res;
si2=res2/nobs;
bout=[results.beta; delta ; alpha];
bparm=results.beta;
parm=[results.beta; delta ; alpha ; si2];
hessn=zeros(K+3,K+3);
hessn(1:K,1:K)=(1/si2)*(xran'*xran);
hessn(K+1:K+3,K+1:K+3)=hessian('f2_respat',[delta;alpha;si2],y,x,wy,wx,lambda,bparm,meany,meanx,wmeany,wmeanx,vmeany,vmeanx,N,T); %elhorst
nvar=K+2;

if hessn(nvar+1,nvar+1) == 0
 hessn(nvar+1,nvar+1) = 1/si2;  % this is a hack for very large models that 
end;                             % should not affect inference in these cases

xpxi = inv(hessn); 
xpxi = diag(xpxi(1:nvar,1:nvar));
zip = find(xpxi <= 0);

if length(zip) > 0
xpxi(zip,1) = 1;
fprintf(1,'panel: negative or zero variance from numerical hessian \n');
fprintf(1,'panel: replacing t-stat with 0 \n');
end;

tstat = bout./sqrt(xpxi);

if length(zip) ~= 0
tstat(zip,1) = 0;
end;

%printen
fid=1;
vnames=strvcat('logcit','constant','logp','logpn','logy','teta','spat.aut'); % should be changed if x is changed
fprintf(fid,'\n');
fprintf(fid,'random effects + spatial autocorrelation\n');
fprintf(fid,'Dependent Variable = %16s \n',vnames(1,:));
fprintf(fid,'R-squared          = %9.4f   \n',results.rsqr);
fprintf(fid,'Rbar-squared       = %9.4f   \n',results.rbar);
fprintf(fid,'sigma^2            = %9.4f   \n',si2);
%fprintf(fid,'log-likelihood     = %16.8g  \n',functie);
fprintf(fid,'Nobs, Nvars        = %6d,%6d \n',nobs,nvar);
% now print coefficient estimates, t-statistics and probabilities
tout = norm_prb(tstat); % find asymptotic z (normal) probabilities
tmp = [bout tstat tout];  % matrix to be printed
% column labels for printing results
bstring = 'Coefficient'; tstring = 'Asymptot t-stat'; pstring = 'z-probability';
cnames = strvcat(bstring,tstring,pstring);
in.cnames = cnames;
in.rnames = vnames;
in.fmt = '%16.6f';
in.fid = fid;
mprint(tmp,in);