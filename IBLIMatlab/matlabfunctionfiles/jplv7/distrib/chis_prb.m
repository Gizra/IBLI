function prob = chis_prb(x,v)
% PURPOSE: computes the chi-squared probability function
%---------------------------------------------------
% USAGE: prob = chis_prb(x,v)
% where: x = the value to test
%            (may be a matrix size(v), or a scalar)
%        v = the degrees of freedom 
%                (may be a matrix size(x), or a scalar)
%---------------------------------------------------
% RETURNS:
%        prob = the probability of observing a chi-squared
%               value <= x, i.e., prob(x | v).                  
% --------------------------------------------------
% SEE ALSO: chis_d, chis_pdf, chis_cdf, chis_inv, chis_rnd
%---------------------------------------------------

% written by:
% James P. LeSage, Dept of Economics
% Texas State University-San Marcos
% 601 University Drive
% San Marcos, TX 78666
% jlesage@spatial-econometrics.com


if nargin ~= 2
error('Wrong # of arguments to chis_prb');
end;

 prob = gammainc(x/2, v/2);

