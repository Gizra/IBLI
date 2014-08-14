function y = crlag(x,n)
% PURPOSE: circular lag function
% -----------------------------------------------------
% USAGE: y = crlag(x,n)
% where  x = input vector tx1
%        n = # of values to return
% -----------------------------------------------------
% RETURNS: y = x(n)
%              x(2)
%               .
%              x(n-1)
% -----------------------------------------------------
             
% written by:
% James P. LeSage, Dept of Economics
% Texas State University-San Marcos
% 601 University Drive
% San Marcos, TX 78666
%jlesage@spatial-econometrics.com% Modified for speed by
% Kevin Sheppard
% kksheppard@ucsd.edu

y= zeros(n,1);
y(1)=x(n);
y(2:n)=x(1:n-1);


