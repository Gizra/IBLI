function m=prodc(x);
% PURPOSE: compute product of each column
% -----------------------------------------
% USAGE: m = prodc(x)
% where:    x = input matrix (or vector) of length nobs
% -----------------------------------------
% RETURNS: m = matrix or vector containing products
%              of the columns
% -----------------------------------------
% NOTE: a Gauss compatibility function
% -----------------------------------------

% written by:
% James P. LeSage, Dept of Economics
% Texas State University-San Marcos
% 601 University Drive
% San Marcos, TX 78666
% jlesage@spatial-econometrics.com

m=prod(x);
if size(m,2)>1;
   m=m';
end;
return;
