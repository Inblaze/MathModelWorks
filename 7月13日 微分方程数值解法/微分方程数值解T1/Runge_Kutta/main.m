
%fun-微分方程
%四阶龙格-库塔方法求解一阶微分方程数值解
%t0 t的取值范围的左端点
%tl t的取值范围的右端点
%y0 y的迭代初始值
%h 步长
tspan=[0.5*pi 6*pi];
y0=2;
[t,y]=ode45(@myfun,tspan,[2 -0.5*pi]);

plot(t,y(:,1),'Color',[1 0 0])
grid on
hold on
stdy=@(stdx)sin(stdx)*sqrt(2*pi/stdx);
fplot(stdy,tspan,'Color',[0 0 1])
legend('Runge Kutta法','原函数')
xlabel('x'),ylabel('y')
grid on
hold on