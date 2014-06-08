function m=stdc(x);
% PURPOSE: standard deviation of each column
% -----------------------------------------------------
% USAGE: x = stdc(y)
%  where    y = input vector 
% -----------------------------------------------------
% RETURNS:  x = standard deviations
% ----------------------------------------------------- 
% NOTE: a Gauss compatability function
% -----------------------------------------------------

% written by:
% James P. LeSage, Dept of Economics
% Texas State University-San Marcos
% 601 University Drive
% San Marcos, TX 78666
% jlesage@spatial-econometrics.com
       
% get standard deviation of each column
m=std(x);
if size(m,2)>1;
   m=m';
end;
