%求数值解
clc,clear

tspan=[0 70]; %时间限制为0到70
[t,yx]=ode45(@myfun,tspan,[0 100]);
figure(1)
plot(yx(:,2),yx(:,1),'Color',[1 0 0])
xlabel('x')
ylabel('y')
title('解析解y与x的图像')
grid on

figure(2)
plot(t,yx(:,2),'Color',[0 0 1])
xlabel('t')
ylabel('x')
title('解析解x与t的图像')
grid on

figure(3)
plot(t,yx(:,1),'Color',[0 1 0])
xlabel('t')
ylabel('y')
title('解析解y与t的图像')
grid on