% PURPOSE: An example of using sem 
% Maximum likelihood spatial error model(on a small data set)  
%                                   
%---------------------------------------------------
% USAGE: sem_gcd (see also sem_gcd2 for a large data set)
%---------------------------------------------------

% A spatial dataset on crime, household income and housing values
% in 49 Columbus, Ohio neighborhoods
% from:
% Anselin, L. 1988. Spatial Econometrics: Methods and Models,
% (Dorddrecht: Kluwer Academic Publishers).

% 5 columns:
% column1 = crime
% column2 = household income
% column3 = house values
% column4 = latitude coordinate
% column5 = longitude coordinate

% load Anselin (1988) Columbus neighborhood crime data
% load anselin.dat;
% n = length(anselin);
% y = anselin(:,1);
% x = [ones(n,1) anselin(:,2:3)];
% latt = anselin(:,4);
% long = anselin(:,5);
% vnames = strvcat('crime','constant','income','hvalue');
% 
% clear anselin;
% 
% load anselin.ford;
% 
% W = anselin;
% % use defaults including lndet approximation
% 
clear all;
% NOTE a large data set with 3107 observations
% from Pace and Barry, takes around 150-250 seconds
load elect.dat;                    % load data on votes
y =  (elect(:,7)./elect(:,8));     % convert to proportions
x1 = log(elect(:,9)./elect(:,8));  % of population
x2 = log(elect(:,10)./elect(:,8));
x3 = log(elect(:,11)./elect(:,8));
latt = elect(:,5);
long = elect(:,6);
n = length(y);
x = [ones(n,1) x1 x2 x3];
clear x1; clear x2; clear x3;
clear elect;                % conserve on RAM memory

[j,W,j] = xy2cont(latt,long); % contiguity-based spatial Weight matrix

vnames = strvcat('voters','const','educ','homeowners','income');


options.lflag = 0;
tic;
result1 = sem_test(y,x,W,options);
toc;
prt(result1,vnames);

tic;
results0 = sem(y,x,W,options);
toc;
prt(results0,vnames);


