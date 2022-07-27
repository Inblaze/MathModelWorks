function dydt=myfun(t,y)
dydt=zeros(2,1);
dydt(1)=y(2);
dydt(2)=(-t*y(2)-(t^2-0.25)*y(1))/(t^2);
end