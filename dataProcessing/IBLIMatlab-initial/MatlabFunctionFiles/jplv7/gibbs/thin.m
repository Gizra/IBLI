function [x, y] = thin(run,n,kthin)
% PURPOSE: function called by raftery.m

% written by:
% James P. LeSage, Dept of Economics
% Texas State University-San Marcos
% 601 University Drive
% San Marcos, TX 78666
% jlesage@spatial-econometrics.com

% NOTE: this is a translation of FORTRAN code
%       (which is why it looks so bad)

 ind=1:kthin:n; y=run(ind,1); [t1 j]=size(y);  x=t1;
