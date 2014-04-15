function scale = scstd(y,nobs,nlag,xx)
% PURPOSE: determines bvar() function scaling factor using a
%          univariate AR model (called by bvar() only)
%---------------------------------------------------
% USAGE:   scale = scstd(y,nobs,nlag)
% where:    y    = an (nobs x neqs) matrix of y-vectors in levels
%           nlag = the lag length
%           nobs = # of observations in y
%---------------------------------------------------
% RETURNS:
%  scale = std deviation of the residuals
%---------------------------------------------------

% written by:
% James P. LeSage, Dept of Economics
% Texas State University-San Marcos
% 601 University Drive
% San Marcos, TX 78666
% jlesage@spatial-econometrics.com

if nargin == 3
    nx = 0;
elseif nargin == 4
    [junk,nx] = size(xx);
end;

ylag = mlag(y,nlag);
ylag = [ylag ones(nobs,1)];

% truncate to feed the lag
if nx == 0
xmat = ylag(nlag+1:nobs,:);
elseif nx > 0
xmat = [ylag(nlag+1:nobs,:) xx(nlag+1:nobs,:)];
end;
yvec = y(nlag+1:nobs,1);
n = length(yvec);

b = inv(xmat'*xmat)*xmat'*yvec;
e = yvec - xmat*b;
sige = (e'*e)/(nobs-nlag);

scale = sqrt(sige);