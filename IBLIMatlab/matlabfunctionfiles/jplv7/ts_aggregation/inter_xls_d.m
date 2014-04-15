% PURPOSE: demo of inter_xls()
%          Temporal disaggregation with indicators.
%          Interface with Excel
%
%---------------------------------------------------
% USAGE: inter_xls_d
%---------------------------------------------------
close all; clear all; clc;
% Low-frequency data: Spain's Exports of Goods. 1995 prices
Y=[  20499
% High-frequency data: Spain's Registered exports of goods deflated by 
x=[   5162
% ---------------------------------------------
% Type of aggregation
% Frequency conversion 
% Method of estimation

% Fixed innovation parameter
ip=0.7;

% Degrre of differencing
d=1;

% Method: flax1 =
%  1 = Boot-Feibes-Lisman
%  2 = Denton
%  3 = Fernandez
%  4 = Chow-Lin
%  5 = Litterman
%  6 = Santos-Cardoso
%  7 = Chow-Lin fixed innnov. param.
%  8 = Litterman fixed innnov. param.
%  9 = Santos-Cardoso fixed innnov. param.

flax1=2;

% Output: flax2 =
% 1 = only temporally disaggregated time series y: nx1
% 2 = 1 + s.e. lower bound upper bounf limits residuals y: nx5
% 3 = 2 + output in ASCII file (called file_name)

flax2=3;
% Name of ASCII file for output
% Calling the function: output is loaded in a matrix y

%res=bfl(Y,ta,d,s);
res=denton_uni(Y,x,ta,d,s);
%res=fernandez(Y,x,ta,s);
%res=chowlin(Y,x,ta,s,type);
%res=litterman(Y,x,ta,s,type);
%res=ssc(Y,x,ta,s,type);
%res=chowlin_fix(Y,x,ta,s,type,ip);
%res=litterman_fix(Y,x,ta,s,type,ip);
%res=ssc_fix(Y,x,ta,s,type,ip);

z=res.y;

delta=y(:,1)-z;

[min(delta) mean(delta) max(delta)]