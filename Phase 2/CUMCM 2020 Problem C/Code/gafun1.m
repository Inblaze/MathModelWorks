function y=gafun1(x)
global credit_level allocRate lossFit
y=0;
for i=1:123
    y=y-allocRate(i)*(1-polyval(lossFit(credit_level(i),:),x(i)))*x(i);
end
end

