%build interept
function b=buildIntercept(lookcol,table_)

 [n,~]=size(lookcol);

 [m,~]=size(table_);

 b=zeros(n,m);

 for i=1:n

    for j=1:m

            if lookcol(i,1)==table_(j,1)

                    b(i,table_(j,2))=1;

                break
            end

    end
end

