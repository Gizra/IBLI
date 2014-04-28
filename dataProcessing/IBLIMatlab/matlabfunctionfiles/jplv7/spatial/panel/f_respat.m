function llike=f_respat(b,beta,y,x,wy,wx,lambda,meany,meanx,wmeany,wmeanx,vmeany,vmeanx,N,T)
% computes teta and spatial autocorrelation
%
% written by: J.Paul Elhorst 9/2006
% University of Groningen
% Department of Economics
% 9700AV Groningen
% the Netherlands
% j.p.elhorst@rug.nl
%
% "Specification and Estimation of Spatial Panel Data Models",
% International Regional Science Review, Vol. 26, pp. 244-268.

teta=b(1);
delta=b(2);
ee=ones(T,1);
eigw=zeros(N,1);
for i=1:N
    eigw(i)=(T*teta^2+1/(1-delta*lambda(i))^2)^(-0.5);
    meanpy(i,1)=eigw(i)*vmeany(i,1)-(meany(i,1)-delta*wmeany(i,1));
    meanpx(i,:)=eigw(i)*vmeanx(i,:)-(meanx(i,:)-delta*wmeanx(i,:));
end
yran=y-delta*wy+kron(ee,meanpy);
xran=x-delta*wx+kron(ee,meanpx);
res=yran-xran*beta;
res2=res'*res;
somp1=0;
somp2=0;
for i=1:N
   p1=1+T*teta^2*(1-lambda(i)*delta)^2;
   p2=1-lambda(i)*delta;
   somp1=somp1+log(p1);
   somp2=somp2+log(p2);
end
llike=(N*T/2)*log(res2)+1/2*somp1-T*somp2;