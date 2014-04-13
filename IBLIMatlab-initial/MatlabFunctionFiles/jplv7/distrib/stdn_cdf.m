function cdf = stdn_cdf(x)  
% PURPOSE: computes the standard normal cumulative
%          distribution for each component of x
%---------------------------------------------------
% USAGE: cdf = stdn_cdf(x)
% where: x = variable vector (nx1)
%---------------------------------------------------
% RETURNS: cdf (nx1) vector
%---------------------------------------------------

% written by:
% James P. LeSage, Dept of Economics
% Texas State University-San Marcos
% 601 University Drive
% San Marcos, TX 78666
%jlesage@spatial-econometrics.com
  if (nargin ~= 1)
    error('Wrong # of arguments to stdn_cdf');
  end;

  cdf = .5*(ones(size(x))+erf(x/sqrt(2)));


