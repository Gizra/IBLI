function result = normlt_inv(p,mu,sigma2,left)
% PURPOSE: compute inverse of cdf for left-truncated normal
%          distribution, p = prob(Y<y | mu,sigma2)
%          where: y is a realization of r.v. Y
% ------------------------------------------------------
% USAGE: y = normlt_inv(p,mu,sigma2,left)
% where: p = probability (scalar or vector)
%       mu = mean (scalar or vector)
%   sigma2 = variance (scalar or vector)
%     left = left truncation point (scalar)
% ------------------------------------------------------
% RETURNS: y = invp (a scalar or vector)
% ------------------------------------------------------

% written by:
% James P. LeSage, Dept of Economics
% Texas State University-San Marcos
% 601 University Drive
% San Marcos, TX 78666
%jlesage@spatial-econometrics.com    
if nargin ~= 4
error('normlt_inv: Wrong # of arguments');
end;

  clft=norm_cdf(left,mu,sigma2);
  x = clft + p*(1-clft);
  res=norm_inv(x,mu,sigma2);
result = res;
