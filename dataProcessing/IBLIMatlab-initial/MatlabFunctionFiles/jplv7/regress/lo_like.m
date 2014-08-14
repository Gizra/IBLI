function out = lo_like(b,y,x)
% PURPOSE: evaluate logit log-likelihood
%-----------------------------------------------------
% USAGE:    like = lo_like(b,y,x,flag) 
% where:     b = parameter vector (k x 1)
%            y = dependent variable vector (n x 1)
%            x = explanatory variables matrix (n x m)
%-----------------------------------------------------
% NOTE: this function returns a scalar
%       k ~= m because we may have additional parameters
%           in addition to the m bhat's (e.g. sigma)
%-----------------------------------------------------
% SEE also: hessian, gradnt, gradt
%-----------------------------------------------------
% REFERENCES: Green, 1997 page 883
%-----------------------------------------------------

% written by:
% James P. LeSage, Dept of Economics
% Texas State University-San Marcos
% 601 University Drive
% San Marcos, TX 78666
%jlesage@spatial-econometrics.com

i = ones(length(y),1);
cdf = i./(i+exp(-x*b));
tmp = find(cdf <=0);
[n1 n2] = size(tmp);
if n1 ~= 0
cdf(tmp) = 0.00001;
end;

tmp = find(cdf >= 1);
[n1 n2] = size(tmp);
if n1 ~= 0
cdf(tmp) = 0.99999;
end;

like = y.*log(cdf)+(i-y).*log(i-cdf);
out = sum(like);


