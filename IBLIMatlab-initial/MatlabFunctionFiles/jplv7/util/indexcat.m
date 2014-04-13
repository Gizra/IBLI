function x=indexcat(y,val);
% PURPOSE: Extract indices for y being equal to val if val is a scaler
%         or extract indices for y being val(1)<y<=val[2] if val is 2x1
% -----------------------------------------------------
% USAGE:  x = indexcat(y,val)
% where   y = input vector or matrix
%       val = a scalar or 2x1 range of values
% -----------------------------------------------------
% RETURNS: x = indices of values meeting the condition
%              defined by val
% -----------------------------------------------------
% NOTE: a Gauss compatability function
% -----------------------------------------------------
% SEE ALSO: delif
 
% written by:
% James P. LeSage, Dept of Economics
% Texas State University-San Marcos
% 601 University Drive
% San Marcos, TX 78666
% jlesage@spatial-econometrics.com

if rows(val)==1 & cols(val)==1;
   x=find(y==val);
else;
   x=find((y>val(1)).*(y<val(2)));
end;
return;
