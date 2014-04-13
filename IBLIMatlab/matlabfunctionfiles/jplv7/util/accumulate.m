function result = accumulate(x)
% PURPOSE: accumulates column elements of a matrix x
%---------------------------------------------------
% USAGE: result = accumulate(x)
% where: x = an nobs x nvar matrix or vector
%---------------------------------------------------
% RETURNS:
%        results = nobs x nvar matrix containing cumulative sums
%        of the column elements of the matrix argument x 
%--------------------------------------------------

% written by:
% James P. LeSage, Dept of Economics
% Texas State University-San Marcos
% 601 University Drive
% San Marcos, TX 78666
% jlesage@spatial-econometrics.com

if (nargin ~= 1)
error('Wrong number of arguments to accumulate');
end;

[nobs nvar] = size(x);
result = zeros(nobs,nvar);

for j=2:nobs;
for i=1:nvar;
result(1,i) = x(1,i);
result(j,i) = result(j-1,i) + x(j,i);
end;
end;

