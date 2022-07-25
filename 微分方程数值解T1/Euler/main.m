clc,clear
[x,y]=my_euler(0.5*pi,6*pi,2,0.01*pi);
plot(x,y,'Color',[1 0 0])
grid on
hold on
stdy=@(stdx)sin(stdx)*sqrt(2*pi/stdx);
fplot(stdy,[0.5*pi,6*pi],'Color',[0 0 1])
legend('Euler法','原函数')
xlabel('x'),ylabel('y')
grid on
hold on