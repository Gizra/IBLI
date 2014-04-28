function m=sumc(x)
% PURPOSE: compute sum of each column
% -----------------------------------------------------
% USAGE: m = sumc(x)
% where  x = input vector or matrix
% -----------------------------------------------------
% RETURNS: m = sum of x elements for columns
% -----------------------------------------------------
% NOTE: a Gauss compatability function
% -----------------------------------------------------
             
% written by:
% James P. LeSage, Dept of Economics
% Texas State University-San Marcos
% 601 University Drive
% San Marcos, TX 78666
% jlesage@spatial-econometrics.com

% get sum of each column
m=sum(x);
if size(m,2)>1;
   m=m';
end;
