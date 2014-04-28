function m=cumprodc(x);
% PURPOSE: compute cumulative product of each column
% -----------------------------------------------------
% USAGE: m = cumprodc(x)
% where  x = input vector or matrix
% -----------------------------------------------------
% RETURNS: m = cumulative product of x elements
%              by columns
% -----------------------------------------------------
             
% written by:
% James P. LeSage, Dept of Economics
% Texas State University-San Marcos
% 601 University Drive
% San Marcos, TX 78666
% jlesage@spatial-econometrics.com


m=cumprod(x);
if size(m,2)>1;
   m=m';
end;
return;
