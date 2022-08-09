function [c,ceq]=nonlincon(x)
c=[-x(1)*x(2);
    x(2)-x(1)];
ceq=[x(1)^2+x(2)^2-1];
end