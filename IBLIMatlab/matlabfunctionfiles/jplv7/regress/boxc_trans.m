function bdata = boxc_trans(x,lam)
% PURPOSE: compute box-cox transformation
%----------------------------------------------------
% USAGE: bdata = boxc_trans(data,lam)
% where:    lam  = scalar transformation parameter
%           data = matrix nobs x k
%----------------------------------------------------
% RETURNS: bdata = data matrix box-cox transformed

% written by:
% James P. LeSage, Dept of Economics
% Texas State University-San Marcos
% 601 University Drive
% San Marcos, TX 78666
% jlesage@spatial-econometrics.com

[n k] = size(x);
z = zeros(n,k);
iota = ones(n,1);

 for i=1:k;
   if lam ~= 0
   z(:,i) = (x(:,i).^lam - iota)/lam;
   else
   z(:,i) = log(abs(x(:,i)));
   end;
 end;

bdata = z;
