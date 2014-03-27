function x=delif(y,cond)
% PURPOSE: select values of x for which cond is false
% -----------------------------------------------------
% USAGE: x = delif(y,cond)
%  where    y = input vector 
%        cond = a vector of 0,1 values  
% -----------------------------------------------------
% RETURNS: x = y(cond == 0)
% ----------------------------------------------------- 
% NOTE: a Gauss compatability function
% -----------------------------------------------------
% SEE ALSO: selif, indexcat

% written by:
% James P. LeSage, Dept of Economics
% Texas State University-San Marcos
% 601 University Drive
% San Marcos, TX 78666
% jlesage@spatial-econometrics.com
       
% Select values of x for which cond is false
x=y(cond==0);
