function rnd = unif_rnd (n,a,b)
% PURPOSE: returns a uniform random number between a,b
%---------------------------------------------------
% USAGE: cdf = unif_rnd(n,a,b)
% where: a = scalar left limit
%        b = scalar right limit
%        n = number of draws (default = 1)
% NOTE: mean = (a+b)/2, variance = (b-a)^2/12
%---------------------------------------------------
% RETURNS: rnd scalar or vector
%---------------------------------------------------

% written by:
% James P. LeSage, Dept of Economics
% Texas State University-San Marcos
% 601 University Drive
% San Marcos, TX 78666
%jlesage@spatial-econometrics.com
if nargin < 2
    error('Wrong # of arguments to unif_rnd');
elseif nargin < 3
    b = a;
    a = n;
    n = 1;
end

rnd = a + (b - a) .* rand(n, 1);
