function y=gafun2(x)
global credit_level allocAmount lossFit
y=0;
for i=1:302
    y=y-allocAmount(i)*(1-polyval(lossFit(credit_level(i),:),x(i)))*x(i);
end
end
