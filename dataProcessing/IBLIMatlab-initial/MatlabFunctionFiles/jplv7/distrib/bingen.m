function s = bingen(p0,p1,m)
% PURPOSE: generate binomial probability
% ----------------------------------------
% USAGE:  s = bingen(p0,p1,m)
% where: p0 = probability 1
%        p1 = probability 2
%         m = number of outputs
% ----------------------------------------
% RETURNS: an (m x 1) vector of 0,1 values
%          based on unif_rnd(m) >= p0/(p0+p1)        

% written by:
% James P. LeSage, Dept of Economics
% Texas State University-San Marcos
% 601 University Drive
% San Marcos, TX 78666
% jlesage@spatial-econometrics.com


pr0 = p0./(p0+p1);
u = rand(m,1);
s = (u >= pr0);
