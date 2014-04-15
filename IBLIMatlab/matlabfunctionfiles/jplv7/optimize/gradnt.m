function g = gradnt(funfcn,theta,deltagrad,varargin)
% PURPOSE: compute the gradient of func at b
% ------------------------------------------------
% USAGE: grd = gradnt(func,b,delta,varargin)
% Where: func     = function, as a string argument
%        b        = (kx1) parameter vector at which to evaluate
%        delta    = perturbation to use
%        varargin = arguments list passed to func
% ------------------------------------------------
% RETURNS: grd  = 1xk vector with the gradient
% ------------------------------------------------

% written by:
% James P. LeSage, Dept of Economics
% Texas State University-San Marcos
% 601 University Drive
% San Marcos, TX 78666
% jlesage@spatial-econometrics.com


funfcn = fcnchk(funfcn,length(varargin));
[m k] = size(theta) ;
if m ==1;
theta = theta';
end;
m=rows(theta); ii = eye(m);
fbase = feval(funfcn,theta,varargin{:});
for i = 1:m ;
theta2 = theta + deltagrad * ii(:,i);
g(:,i) = (feval(funfcn,theta2,varargin{:}) - fbase) / deltagrad ;
end ;

