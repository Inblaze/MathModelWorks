%正规战争求解析解
syms n1(t) n2(t) na nb s1 s2 alpha1 alpha2 beta1 beta2 gamma1 gamma2
eqn=[diff(n1,t)==-s2*beta2*n2-alpha1*n1+gamma1*(exp(1-(n1/na))-1),
     diff(n2,t)==-s1*beta1*n1-alpha2*n2+gamma2*(exp(1-(n2/nb))-1)];
ans=dsolve(eqn)
