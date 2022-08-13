%tx(1~4)为第一到第四温区的温度，tx(5)为传送带速度(cm/s)
function y=fun_T4_2(tx)
global xm;
u=get_heat_T3(tx,xm);
%t4=floor((L4/tx(5))/0.5)+1;
t4=find(u==max(u));
tn=find(u>217);
tn_left=tn(tn<=t4); %对称轴左边
tn_right=tn(tn>=t4); %对称轴右边
S_left=0; S_right=0;
y=0;
nleft=length(tn_left);
nright=length(tn_right);
for i=2:nleft
    S_left=S_left+0.5*0.5*(u(tn_left(i-1))+u(tn_left(i))-434);
end

for i=2:nright
    S_right=S_right+0.5*0.5*(u(tn_right(i-1))+u(tn_right(i))-434);
end
Smax=max([S_left,S_right]);
if mod(length(tn),2)==0
    ty=(u(tn(length(tn)/2))+u(tn(length(tn)/2+1)))/2;
else
    ty=u(tn((length(tn)+1)/2));
end
y1=0.5*((u(t4)-ty)/u(t4))+0.5*(abs(S_left-S_right)/Smax);
y2=S_left;
y=(y1-0.0364285879838797)^2+(y2-511.559585524133)^2;
% y=0.5*(abs(nleft-nright)/max([nleft,nright]))+0.5*(abs(S_left-S_right)/Smax);
end