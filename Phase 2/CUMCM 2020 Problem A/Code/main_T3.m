%问题3
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
%[x,fval]=ga(@fun_T3,5,[],[],[],[],lb,ub,@nonlcon_T3);
[x,fval]=fmincon(@fun_T3,[175,195,235,255,80/100],[],[],[],[],lb,ub,@nonlcon_T3);

v=x(5);L=50+30.5*11+5*10; T=L/v; dt=0.5;
t=0:dt:T;
u=get_heat_T3(x,xm);
fg=figure(1);
plot(t,u);
xlabel( '时间（s）');ylabel('温度（℃）');
title('焊接中心温度随时间变化曲线')
hold on
[tmp_max,fill_end]=max(u);
tmp=abs(u-217); tmp=tmp(1:fill_end);
[tmp_min,fill_st]=min(tmp);
fill([t(fill_st:fill_end),t(fill_end),t(fill_st)],...
    [u(fill_st:fill_end)',217,217],[0.4,0.4,0.4]);
hold on
plot([0,t(fill_st)],[217,217],'k--')
plot([0,t(fill_end)],[tmp_max,tmp_max],'k--')
plot([t(fill_st),t(fill_st)],[0,217],'k--')
plot([t(fill_end),t(fill_end)],[0,tmp_max],'k--')
hold on
annotation(fg,'textbox',...
    [0.069642857142857 0.784238094284425 0.0535714285714286 0.0638095247631982],...
    'String','217',...
    'FitBoxToText','off',...
    'EdgeColor','none');
annotation(fg,'textbox',...
    [0.0239285714285713 0.852333332379662 0.102142857142857 0.0638095247631982],...
    'String',num2str(tmp_max),...
    'FitBoxToText','off',...
    'EdgeColor','none');
hold on

