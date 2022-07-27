%求解析解
clc,clear
syms k y(x) d
eqn= diff(y,x)==-k*sqrt(x^2+y^2)/x+y/x;
cond= y(d)==0;
ans=dsolve(eqn,cond)