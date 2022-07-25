function dydx=myfun(t,yx)
dydx=zeros(2,1);
dydx(1)=1-2*yx(1)/sqrt(yx(2)^2+yx(1)^2);
dydx(2)=-2*yx(2)/sqrt(yx(2)^2+yx(1)^2);
end