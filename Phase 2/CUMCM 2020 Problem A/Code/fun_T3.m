%tx(1~4)为第一到第四温区的温度，tx(5)为传送带速度(cm/s)
function y=fun_T3(tx)
global xm;
u=get_heat_T3(tx,xm);
%t4=floor((L4/tx(5))/0.5)+1;
t4=find(u==max(u));
tn=find(u>217);
tn=tn(find(tn<=t4)); %u>217的元素的序号
y=0;
for i=2:length(tn)
    y=y+0.5*0.5*(u(tn(i-1))+u(tn(i))-434);
end
end