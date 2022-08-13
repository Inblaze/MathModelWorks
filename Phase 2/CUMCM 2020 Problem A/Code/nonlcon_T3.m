%tx(1~4)为第一到第四温区的温度，tx(5)为传送带速度(cm/s)
function [c,ceq]=nonlcon_T3(tx)
global xm;
u=get_heat_T3(tx,xm);
tmp_con1=0.5*length(find(u>=150 & u<=190));
tmp_con2=0.5*length(find(u>217)); 
tmp_con3=max(u);
c(1)=max(abs(diff(u)))-1.5;
c(2)=60-tmp_con1;
c(3)=tmp_con1-120;
c(4)=40-tmp_con2;
c(5)=tmp_con2-90;
c(6)=240-tmp_con3;
c(7)=tmp_con3-250;
ceq=[];
end