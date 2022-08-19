clc,clear

E_with_p=xlsread('附件3-弹性模量与压力.xlsx','sheet1');
global xs_rho_p xs_p_rho rho_gaoya repOutSpeed capacity

capacity=500*pi*25;
repOutSpeed=zeros(100/0.01,1);
for i=1:(0.2/0.01)
    repOutSpeed(i)=i;
end
repOutSpeed(21:220)=20;
for i=221:(2.4/0.01)
    repOutSpeed(i)=20-(i-220);
end


rho_with_p=get_rho_with_p(E_with_p);
rho_gaoya=rho_with_p(find(rho_with_p(:,1)==160),2);

figure(1)
plot(rho_with_p(:,2),rho_with_p(:,1))
xlabel('Rho'); ylabel('P');
title('Rho-P真实曲线')

[mindis,xs_rho_p]=get_P_rho_polyfit(rho_with_p);
% xs_rho_p=polyfit(rho_with_p(:,2),rho_with_p(:,1),1);
tmpy=polyval(xs_rho_p,rho_with_p(:,2));
% xs_p_rho=polyfit(rho_with_p(:,1),rho_with_p(:,2),1);
[mindis2,xs_p_rho]=get_rho_p_polyfit(rho_with_p);

figure(2)
plot(rho_with_p(:,2),tmpy)
xlabel('Rho'); ylabel('P');
title('Rho-P拟合曲线')

% left=0; right=990;
% [leftp,leftT]=calc_p(left);
% leftaverdis=mean(leftp)-100;
% [rightp,rightT]=calc_p(right);
% rightaverdis=mean(rightp)-100;
% 
% while left<right
%     mid=(left+right)/2;
%     [tp,T]=calc_p(mid);
%     midaverdis=mean(tp)-100;
%     if midaverdis==0
%         ansp=tp;
%         minaverdis=midaverdis;
%         break;
%     end
%     if midaverdis*leftaverdis<0
%         right=mid-0.01;
%         [rightp,rightT]=calc_p(right);
%         rightaverdis=mean(rightp)-100;
%         continue;
%     else
%         left=mid+0.01;
%         [leftp,leftT]=calc_p(left);
%         leftaverdis=mean(leftp)-100;
%         continue;
%     end
% end


left=0; right=990;
dt=1; maxShrinkTime=3; Shrink=10; cntShrinkTime=0;
while left<=right && cntShrinkTime<=maxShrinkTime
    varp=zeros(uint16((right-left)/dt+1),1);
    cnt=0;
    for i=left:dt:right
        cnt=cnt+1;
        [tp,tperiod]=calc_p(i);
        txishu=polyfit([1:tperiod*100-1],tp,1);
        varp(cnt)=abs(txishu(1));
    end
    [minVar,minVarIdx]=min(varp);
    ansT=left+dt*(minVarIdx-1);
    [ansp,ansPeriod]=calc_p(ansT);
    dt=dt/Shrink;
    left=ansT-dt*Shrink+dt;
    if ansT==0
        left=0;
    end
    right=ansT+dt*Shrink-dt;
    cntShrinkTime=cntShrinkTime+1;
end

figure(3)
plot(linspace(0,ansPeriod,1+length(ansp)),[100;ansp])
xlabel('时间t/ms');
ylabel('压力P/MPa');
hold on
plot([0,700],[100,100],'r--')


rho_p_is_150=rho_with_p(find(rho_with_p(:,1)==150),2);
left=0; right=990;
dt=1; maxShrinkTime=3; Shrink=10; cntShrinkTime=0;
while left<=right && cntShrinkTime<=maxShrinkTime
    varp=zeros(uint16((right-left)/dt+1),1);
    cnt=0;
    for i=left:dt:right
        cnt=cnt+1;
        [tp,tperiod]=calc_p(i,rho_p_is_150);
        txishu=polyfit([1:tperiod*100-1],tp,1);
        varp(cnt)=abs(txishu(1));
    end
    [minVar,minVarIdx]=min(varp);
    ansT_p150=left+dt*(minVarIdx-1);
    [ansp_p150,ansPeriod_p150]=calc_p(ansT_p150,rho_p_is_150);
    dt=dt/Shrink;
    left=ansT_p150-dt*Shrink+dt;
    if ansT_p150==0
        left=0;
    end
    right=ansT_p150+dt*Shrink-dt;
    cntShrinkTime=cntShrinkTime+1;
end

[ansp_2s,ansT_2s,mindis_2s]=reach_in_time(2000);
[ansp_5s,ansT_5s,mindis_5s]=reach_in_time(5000);
[ansp_10s,ansT_10s,mindis_10s]=reach_in_time(10000);
ansT=double(uint16(ansT*100))/100;
ansT_2s=double(uint16(ansT_2s*100))/100;
ansT_5s=double(uint16(ansT_5s*100))/100;
ansT_10s=double(uint16(ansT_10s*100))/100;
ansT_p150=double(uint16(ansT_p150*100))/100;

figure(4)
plot(linspace(0,ansPeriod_p150,1+length(ansp_p150)),[150;ansp_p150])
xlabel('时间t/ms');
ylabel('压力P/MPa');
hold on
plot([0,700],[150,150],'r--')

figure(5)
[tmpp,tmpPeriod]=calc_p(ansT_p150,rho_p_is_150,20*1e5);
plot(linspace(0,tmpPeriod,1+length(tmpp)),[150;tmpp])
xlabel('时间t/ms');
ylabel('压力P/MPa');
hold on
plot([0,20000],[150,150],'r--')
hold off

figure(6)
plot(linspace(0,5000,500000),[100;ansp_2s;tmpp(1:300000)])
xlabel('时间t/ms');
ylabel('压力P/MPa');
hold on
plot([0,5000],[150,150],'r--')
hold off

figure(7)
plot(linspace(0,10000,1000000),[100;ansp_5s;tmpp(1:500000)])
xlabel('时间t/ms');
ylabel('压力P/MPa');
hold on
plot([0,10000],[150,150],'r--')
hold off

figure(8)
plot(linspace(0,20000,2000000),[100;ansp_10s;tmpp(1:1000000)])
xlabel('时间t/ms');
ylabel('压力P/MPa');
hold on
plot([0,20000],[150,150],'r--')
hold off
