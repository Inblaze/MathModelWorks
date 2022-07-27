x=[0:0.01:1];
t=[0:0.01:3];
sol=pdepe(0,@heatpde,@icfun,@bcfun,x,t);
u=sol(:,:,1);
surf(x,t,u)
xlabel('x')
ylabel('t')
zlabel('u(x,t)')
view([150 25])