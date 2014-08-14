%build trend variable
function b=buildtrend(lookcol,table_,trendVec)
%this is set up almost identical to the buildintercept, except it loops
%through yield years and increments the trend...probably faster ways to do
%it since you could just reiteratively stack and multiply by t but I'm
%lazy.
%Right now yearsVec is column vector of linear variables, but this could be
%updated to accomodate other trend forms easily by giving each district its
%own yearsVec column


 [k,~]=size(trendVec);

 [n,~]=size(lookcol);
 
 [m,~]=size(table_);
   
 b=zeros(n*k,m);
 
 for h=1:k
    for i=1:n
     
        for j=1:m    
        
            if lookcol(i,1)==table_(j,1)
                                   
                    b(n*(h-1)+i,table_(j,2))=trendVec(h,1);
                   
                break 
            end
                           
        end
    end
 end