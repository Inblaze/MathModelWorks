
function [x,y] = my_euler(x0, xf , y0, h)

y(1)=y0;
y1(1)=-2/pi; 
y2(1)=(-x0*y1(1)-(x0^2-0.25)*y0)/(x0^2);
M=floor((xf-x0)/h);     % 离散点的个数
x=zeros(M+1,1);
y=zeros(M+1,1);
 
x=[x0:h:xf]';
 
for i=1:M+1
    y(i+1)=y(i)+h*y1(i);
    y1(i+1)=y1(i)+h*y2(i);
    y2(i+1)=(-x(i+1)*y1(i+1)-(x(i+1)^2-0.25)*y(i+1))/(x(i+1)^2);
end
end