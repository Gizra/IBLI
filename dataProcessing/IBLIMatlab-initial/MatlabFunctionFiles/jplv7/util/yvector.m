function B = yvector(y)
% PURPOSE: repeats an nx1 vector y n times to form
%          an n*n x 1 vector
% --------------------------------------------------
% USAGE: B = yvector(y)
% where: y = an nx1 vector
% --------------------------------------------------
% RETURNS: B = [y
%               y
%               .
%               y], where there are n of them
% --------------------------------------------------

% written by: James P. LeSage 2/98
% Texas State University-San Marcos
% 601 University Drive
% San Marcos, TX 78666
% jlesage@spatial-econometrics.com

n = length(y);
B = y;
for i=2:n
B = [B;
     y];
end;

