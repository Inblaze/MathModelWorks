%问题4
%tx(1~4)为第一到第四温区的温度，tx(5)为传送带速度(cm/s)

clear,clc
global xm;
xm=[0.000668314078115304;
24987.2763662884;
0.000807627561175476;
1431.52527090079;
0.000974391311848423;
827.919979410674;
0.000849273459566161;
654.770225229180;
0.000528684199173202;
1337.60387605159;];
%tx(1~4)为第一到第四温区的温度，tx(5)为传送带速度(cm/s)
lb=[165;185;225;245;65/60];
ub=[185;205;245;265;100/60];
[x,fval]=ga(@fun_T4_1,5,[],[],[],[],lb,ub,@nonlcon_T4);
%[x,fval]=fmincon(@fun_T4,[175,195,235,255,80/100],[],[],[],[],lb,ub,@nonlcon_T4);

v=x(5);L=50+30.5*11+5*10; T=L/v; dt=0.5;
t=0:dt:T;
u=get_heat_T3(x,xm);

t4=find(u==max(u));
tn=find(u>217);
tn=tn(find(tn<=t4)); %u>217的元素的序号
S=0;
for i=2:length(tn)
    S=S+0.5*0.5*(u(tn(i-1))+u(tn(i))-434);
end

fg1=figure(1);
plot(t,u);
xlabel( '时间（s）');ylabel('温度（℃）');
title('最对称的焊接中心温度随时间变化曲线')
hold on
[tmp_max,fill_end]=max(u);
tmp=abs(u-217); tmp=tmp(1:fill_end);
[tmp_min,fill_st]=min(tmp);
% fill([t(fill_st:fill_end),t(fill_end),t(fill_st)],...
%     [u(fill_st:fill_end)',217,217],[0.4,0.4,0.4]);
% hold on
 plot([0,t(length(t))],[217,217],'k--')
% plot([0,t(fill_end)],[tmp_max,tmp_max],'k--')
% plot([t(fill_st),t(fill_st)],[0,217],'k--')
% plot([t(fill_end),t(fill_end)],[0,tmp_max],'k--')
% hold on
annotation(fg1,'textbox',...
    [0.069642857142857 0.784238094284425 0.0535714285714286 0.0638095247631982],...
    'String','217',...
    'FitBoxToText','off',...
    'EdgeColor','none');
annotation(fg1,'textbox',...
    [0.0239285714285713 0.852333332379662 0.102142857142857 0.0638095247631982],...
    'String',num2str(tmp_max),...
    'FitBoxToText','off',...
    'EdgeColor','none');
hold on

[x,fval]=ga(@fun_T4_2,5,[],[],[],[],lb,ub,@nonlcon_T4);
v=x(5);L=50+30.5*11+5*10; T=L/v; dt=0.5;
t=0:dt:T;
u=get_heat_T3(x,xm);
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
dy=(u(t4)-ty)/u(t4); dS=abs(S_left-S_right)/Smax;
y1=0.5*dy+0.5*dS;
y2=S_left;

fg=figure(1);
plot(t,u);
xlabel( '时间（s）');ylabel('温度（℃）');
title('焊接中心温度随时间变化曲线')
hold on
[tmp_max,fill_end]=max(u);
tmp=abs(u-217); tmp=tmp(1:fill_end);
[tmp_min,fill_st]=min(tmp);
% fill([t(fill_st:fill_end),t(fill_end),t(fill_st)],...
%     [u(fill_st:fill_end)',217,217],[0.4,0.4,0.4]);
% hold on
 plot([0,t(length(t))],[217,217],'k--')
% plot([0,t(fill_end)],[tmp_max,tmp_max],'k--')
% plot([t(fill_st),t(fill_st)],[0,217],'k--')
% plot([t(fill_end),t(fill_end)],[0,tmp_max],'k--')
% hold on
annotation(fg,'textbox',...
    [0.069642857142857 0.784238094284425 0.0535714285714286 0.0638095247631982],...
    'String','217',...
    'FitBoxToText','off',...
    'EdgeColor','none');

