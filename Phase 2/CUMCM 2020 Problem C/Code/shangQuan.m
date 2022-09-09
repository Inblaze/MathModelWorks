function w=shangQuan(x)
p=[];
E=[];
[n,m]=size(x);
for k=1:m
    s=sum(x(:,k));
    p=x(:,k)/s;
    s=0.0;
    for i=1:n
        if p(i)>0 
            s=s+p(i)*log(p(i)); 
        end
    end
    E(k)=-s/log(n); %获得熵
end
s=sum(E);
w=(1-E)/(m-s);
end