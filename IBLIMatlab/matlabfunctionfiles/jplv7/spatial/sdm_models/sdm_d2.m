% PURPOSE: An example of using sdm() on a large data set
%          max likelihood spatial Durbin model
%---------------------------------------------------
% USAGE: sdm_d2 (see sdm_d for a small data set)
%---------------------------------------------------

clear all;
% NOTE a large data set with 3107 observations from Pace and Barry
load elect.dat;             % load data on votes
y =  log(elect(:,7));
x0 = log(elect(:,8)); % population
x1 = log(elect(:,9));
x2 = log(elect(:,10));
x3 = log(elect(:,11));
n = length(y); x = [ones(n,1) x0 x1 x2 x3  ];
xc = elect(:,5);
yc = elect(:,6);
clear x1; clear x2; clear x3;
clear elect;                % conserve on RAM memory
[j1 W j2] = xy2cont(xc,yc);

n = 3107;
vnames = strvcat('voters','constant','pop','educ','homeowners','income');

info.lflag = 0;
result0 = sdm(y,x,W,info);
prt(result0,vnames);
