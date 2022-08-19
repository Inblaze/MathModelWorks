clc,clear

E_with_p=xlsread('附件3-弹性模量与压力.xlsx','sheet1');
global xs_rho_p xs_p_rho capacity jijiao_jijin zhenfa_curve capacity

capacity=500*pi*25;
rho_with_p=get_rho_with_p(E_with_p);
% fittp=fittype('a*log(x)+b'); %函数拟合形式
% xs_p_rho=fit(rho_with_p(:,1),rho_with_p(:,2),fittp); %p-x,rho-y
% xs_rho_p=fit(rho_with_p(:,2),rho_with_p(:,1),fittp); %rho-x,p-y
[mindis,xs_rho_p]=get_P_rho_polyfit(rho_with_p);
tmpy=polyval(xs_rho_p,rho_with_p(:,2));
[mindis2,xs_p_rho]=get_rho_p_polyfit(rho_with_p);

capacity=500*pi*25;

jijiao_jijin=xlsread("附件1-凸轮边缘曲线.xlsx");
load('zhenfa_curve.mat');


left=0; right=2;
dt=0.1; maxShrinkTime=3; Shrink=10; cntShrinkTime=0;
while left<=right && cntShrinkTime<=maxShrinkTime
    varp=zeros(uint16((right-left)/dt+1),1);
    cnt=0;
    for i=left:dt:right
        cnt=cnt+1;
        [tp,tperiod]=calc_p_T2(i,1e6);
        txishu=polyfit([1:tperiod*100],tp,1);
        varp(cnt)=abs(txishu(1));
    end
    [minVar,minVarIdx]=min(varp);
    ansT=left+dt*(minVarIdx-1);
    %[ansp,ansPeriod]=calc_p_T2(ansT,1e5);
    dt=dt/Shrink;
    left=ansT-dt*Shrink+dt;
    if ansT==0
        left=0;
    end
    right=ansT+dt*Shrink-dt;
    cntShrinkTime=cntShrinkTime+1;
end

[ansp,ansPeriod]=calc_p_T2(ansT,1e6);

figure(1)
hold on
plot([0:0.01:1e4],[100;ansp]);
xlabel('时间t/ms');
ylabel('压力p/MPa');
plot([0,1e4],[100,100],'r--');
hold off