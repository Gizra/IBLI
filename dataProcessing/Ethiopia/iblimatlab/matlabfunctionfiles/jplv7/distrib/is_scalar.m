function ret = is_scalar(x)
% PURPOSE: determines if argument x is scalar
%---------------------------------------------
% USAGE: return = is_scalar(x)
% where:      x = input argument
% RETURNS: 0 if x == scalar, (size(1,1))
%          1 if x ~= scalar
%---------------------------------------------

% written by:
% James P. LeSage, Dept of Economics
% Texas State University-San Marcos
% 601 University Drive
% San Marcos, TX 78666
% jlesage@spatial-econometrics.com

if nargin~=1
error('Wrong # of arguments to is_scalar');
end;

[n k] = size(x);

ret = 0;

if n == 1 & k == 1
ret = 1;
end;