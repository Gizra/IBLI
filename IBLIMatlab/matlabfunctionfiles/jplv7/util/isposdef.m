function ans = isposdef(a)
% PURPOSE: test a matrix for Positive definiteness, using cholesky
% ----------------------------------------------------------------
% USAGE: ans = isposdef(x)
% where: x    = input matrix
%---------------------------------------------------
% RETURNS:
%        ans = 1, positive definite
%        ans = 0, not positive definite
% ----------------------------------------------------------------
% NOTES:
% uses: [R,p] = chol(a); ans = (p == 0); which is fairly fast
% ----------------------------------------------------------------


% Written by:
% James P. LeSage, Dept of Economics
% Texas State University-San Marcos
% 601 University Drive
% San Marcos, TX 78666
% jlesage@spatial-econometrics.com


[R,p] = chol(a);
ans = (p == 0);
