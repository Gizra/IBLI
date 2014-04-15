% PURPOSE: An example of using sarp_g() Gibbs sampling
%          spatial autoregressive probit model
%          (on a small data set)
%---------------------------------------------------
% USAGE: sarp_gd (see also sarp_gd2 for a large data set)
%---------------------------------------------------

clear all;

% generated data
n = 200;

defaultStream = RandStream.getDefaultStream;

latt = rand(n,1);
long = rand(n,1);
W = make_neighborsw(latt,long,5); % 5 nearest neighbors weight matrix

IN = speye(n);
rho = 0.8;  % true value of rho
sige = 1;
k = 3;

x = [ones(n,1) randn(n,k)];
beta(1,1) = 0.0;
beta(2,1) = 1.0;
beta(3,1) = -1.0;
beta(4,1) = 1.0;

y = (IN-rho*W)\(x*beta) + (IN-rho*W)\randn(n,1);

disp('maximum likelihood estimates based on continuous y');
result = sar(y,x,W);
prt(result);

z = (y > 0);
z = ones(n,1).*z; % eliminate a logical vector

disp('# of zeros and ones');
[n-sum(z) sum(z)]

% Gibbs sampling function homoscedastic prior
% to maximum likelihood estimates
ndraw = 600;
nomit = 100;

prior2.nsteps = 1;
result2 = sarp_g(z,x,W,ndraw,nomit,prior2);
prt(result2);

% takes around 10 times as long but more accurate
prior2.nsteps = 10;
result3 = sarp_g(z,x,W,ndraw,nomit,prior2);
prt(result3);

% plot draws for comparison
tt=1:ndraw-nomit;
plot(tt,result2.bdraw(:,1),'-r',tt,result3.bdraw(:,1),'-g');
xlabel(['true b =' num2str(beta(1,1))]);
legend('steps=1','steps=10');
pause;
plot(tt,result2.bdraw(:,2),'-r',tt,result3.bdraw(:,2),'-g');
xlabel(['true b =' num2str(beta(2,1))]);
legend('steps=1','steps=10');
pause;
plot(tt,result2.bdraw(:,3),'-r',tt,result3.bdraw(:,3),'-g');
xlabel(['true b =' num2str(beta(3,1))]);
legend('steps=1','steps=10');
pause;

plot(tt,result2.bdraw(:,4),'-r',tt,result3.bdraw(:,4),'-g');
xlabel(['true b =' num2str(beta(4,1))]);
legend('steps=1','steps=10');
pause;

plot(tt,result2.pdraw,'-r',tt,result3.pdraw,'-g');
xlabel(['true rho =' num2str(rho)]);
legend('steps=1','steps=10');
pause;


% plot densities for comparison
[h1,f1,y1] = pltdens(result2.bdraw(:,1));
[h2,f2,y2] = pltdens(result3.bdraw(:,1));
[h3,f3,y3] = pltdens(result2.bdraw(:,2));
[h4,f4,y4] = pltdens(result3.bdraw(:,2));
[h5,f5,y5] = pltdens(result2.bdraw(:,3));
[h6,f6,y6] = pltdens(result3.bdraw(:,3));
[h7,f7,y7] = pltdens(result2.bdraw(:,3));
[h8,f8,y8] = pltdens(result3.bdraw(:,3));

plot(y1,f1,'.r',y2,f2,'.g');
legend('steps=1','steps=10');
xlabel(['true b =' num2str(beta(1,1))]);
pause;
plot(y3,f3,'.r',y4,f4,'.g');
legend('steps=1','steps=10');
xlabel(['true b =' num2str(beta(2,1))]);
pause;
plot(y5,f5,'.r',y6,f6,'.g');
legend('steps=1','steps=10');
xlabel(['true b =' num2str(beta(3,1))]);
pause;
plot(y7,f7,'.r',y8,f8,'.g');
legend('steps=1','steps=10');
xlabel(['true b =' num2str(beta(4,1))]);
pause;

[h5,f5,y5] = pltdens(result2.pdraw);
[h6,f6,y6] = pltdens(result3.pdraw);

plot(y5,f5,'.r',y6,f6,'.g');
legend('steps=1','steps=10');
xlabel(['true rho =' num2str(rho)]);
pause;

tt=1:n;
plot(tt,y,'-r',tt,result.yhat,'-g',tt,result3.ymean,'-b');
legend('actual y','sar yhat','sarp mean of y draws');
pause;


[ysort,yind] = sort(y);
plot(tt,ysort,'o',tt,result3.ymean(yind,1),'.');
legend('actual y (sorted),','mean of latent y-draws (sorted)');

% a set of draws for the effects/impacts distribution
total    = result3.total;
indirect = result3.indirect;
direct   = result3.direct;

ndraw = size(total,1);

nobs = result3.nobs;
nvar = result3.nvar;
cflag = result3.cflag;
fid = 1;

% Compute means, std deviation and upper and lower 0.99 intervals
iter = ndraw;
p = result3.p;
total_out = zeros(p,5);
total_save = zeros(ndraw,p);
for i=1:p;
tmp = squeeze(total(:,i,:)); % an ndraw by 1 by ntraces matrix
total_mean = mean(tmp);
total_std = std(tmp);
% Bayesian 0.99 credible intervals
% for the cumulative total effects
total_sum = (sum(tmp'))'; % an ndraw by 1 vector
cum_mean = cumsum(mean(tmp));
cum_std = cumsum(std(tmp));
total_save(:,i) = total_sum;
bounds = cr_interval(total_sum,0.99);
cmean = mean(total_sum);
smean = std(total_sum);
ubounds = bounds(1,1);
lbounds = bounds(1,2);
total_out(i,:) = [cmean cmean./smean tdis_prb(cmean./smean,nobs) lbounds ubounds];
end;

% now do indirect effects
indirect_out = zeros(p,5);
indirect_save = zeros(ndraw,p);
for i=1:p;
tmp = squeeze(indirect(:,i,:)); % an ndraw by 1 by ntraces matrix
indirect_mean = mean(tmp);
indirect_std = std(tmp);
% Bayesian 0.95 credible intervals
% for the cumulative indirect effects
indirect_sum = (sum(tmp'))'; % an ndraw by 1 vector
cum_mean = cumsum(mean(tmp));
cum_std = cumsum(std(tmp));
indirect_save(:,i) = indirect_sum;
bounds = cr_interval(indirect_sum,0.99);
cmean = mean(indirect_sum);
smean = std(indirect_sum);
ubounds = bounds(1,1);
lbounds = bounds(1,2);
indirect_out(i,:) = [cmean cmean./smean tdis_prb(cmean./smean,nobs) lbounds ubounds  ];
end;


% now do direct effects
direct_out = zeros(p,5);
direct_save = zeros(ndraw,p);
for i=1:p;
tmp = squeeze(direct(:,i,:)); % an ndraw by 1 by ntraces matrix
direct_mean = mean(tmp);
direct_std = std(tmp);
% Bayesian 0.95 credible intervals
% for the cumulative direct effects
direct_sum = (sum(tmp'))'; % an ndraw by 1 vector
cum_mean = cumsum(mean(tmp));
cum_std = cumsum(std(tmp));
direct_save(:,i) = direct_sum;
bounds = cr_interval(direct_sum,0.99);
cmean = mean(direct_sum);
smean = std(direct_sum);
ubounds = bounds(1,1);
lbounds = bounds(1,2);
direct_out(i,:) = [cmean cmean./smean tdis_prb(cmean./smean,nobs) lbounds ubounds  ];
end;

% now print x-effects estimates

% handling of vnames
Vname = 'Variable';

        Vname = strvcat(Vname,'constant');
     for i=1:nvar-1
        tmp = ['variable ',num2str(i)];
        Vname = strvcat(Vname,tmp);
     end

% add spatial rho parameter name
    Vname = strvcat(Vname,'rho');


bstring = 'Coefficient';
tstring = 't-stat';
pstring = 't-prob';
lstring = 'lower 01';
ustring = 'upper 99';
cnames = strvcat(bstring,tstring,pstring,lstring,ustring);
ini.cnames = cnames;
ini.width = 2000;

% print effects estimates
if cflag == 1
vnameso = strvcat(Vname(3:end-1,:));
elseif cflag == 0
vnameso = strvcat(Vname(2:end-1,:));
end
ini.rnames = strvcat('Direct  ',vnameso);
ini.fmt = '%16.6f';
ini.fid = fid;

% set up print out matrix
printout = direct_out;
mprint(printout,ini);

printout = indirect_out;
ini.rnames = strvcat('Indirect',vnameso);
mprint(printout,ini);

printout = total_out;
ini.rnames = strvcat('Total   ',vnameso);
mprint(printout,ini);




