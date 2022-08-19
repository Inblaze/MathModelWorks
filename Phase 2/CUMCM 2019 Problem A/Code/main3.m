clc,clear

E_with_p=xlsread('附件3-弹性模量与压力.xlsx','sheet1');
global xs_rho_p xs_p_rho capacity jijiao_jijin new_curve capacity

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

ansp=zeros(1e6,5);

for j=10:10:50
    new_curve=zhenfa_curve;
    new_curve((j/0.01+1):(j/0.01+1)+245,2)=zhenfa_curve(1:246,2);
    left=0; right=2;
    dt=0.1; maxShrinkTime=3; Shrink=10; cntShrinkTime=0;
    while left<=right && cntShrinkTime<=maxShrinkTime
        varp=zeros(uint16((right-left)/dt+1),1);
        cnt=0;
        for i=left:dt:right
            cnt=cnt+1;
            [tp,tperiod]=calc_p_T3(i,1e6);
            txishu=polyfit([1:tperiod*100],tp,1);
            varp(cnt)=abs(txishu(1));
        end
        [minVar,minVarIdx]=min(varp);
        ansT=left+dt*(minVarIdx-1);
        %[ansp,ansPeriod]=calc_p_T3(ansT,1e5);
        dt=dt/Shrink;
        left=ansT-dt*Shrink+dt;
        if ansT==0
            left=0;
        end
        right=ansT+dt*Shrink-dt;
        cntShrinkTime=cntShrinkTime+1;
    end
    ansp(:,j/10)=calc_p_T3(ansT,1e6);
end

xs=zeros(5,2);
for i=1:5
    xs(i,:)=polyfit([1:1e6],ansp(:,i),1);
end

ansp2=zeros(1e6,3);
ansp2(:,3)=ansp(:,4);
for j=35:10:45
    new_curve=zhenfa_curve;
    new_curve((j/0.01+1):(j/0.01+1)+245,2)=zhenfa_curve(1:246,2);
    left=0; right=2;
    dt=0.1; maxShrinkTime=3; Shrink=10; cntShrinkTime=0;
    while left<=right && cntShrinkTime<=maxShrinkTime
        varp=zeros(uint16((right-left)/dt+1),1);
        cnt=0;
        for i=left:dt:right
            cnt=cnt+1;
            [tp,tperiod]=calc_p_T3(i,1e6);
            txishu=polyfit([1:tperiod*100],tp,1);
            varp(cnt)=abs(txishu(1));
        end
        [minVar,minVarIdx]=min(varp);
        ansT=left+dt*(minVarIdx-1);
        %[ansp,ansPeriod]=calc_p_T3(ansT,1e5);
        dt=dt/Shrink;
        left=ansT-dt*Shrink+dt;
        if ansT==0
            left=0;
        end
        right=ansT+dt*Shrink-dt;
        cntShrinkTime=cntShrinkTime+1;
    end
    ansp2(:,(j-25)/10)=calc_p_T3(ansT,1e6);
end

xs2=zeros(3,2);
for i=1:3
    xs2(i,:)=polyfit([1:1e6],ansp2(:,i),1);
end

ansp3=zeros(1e6,9);
for j=36:44
    new_curve=zhenfa_curve;
    new_curve((j/0.01+1):(j/0.01+1)+245,2)=zhenfa_curve(1:246,2);
    left=0; right=2;
    dt=0.1; maxShrinkTime=3; Shrink=10; cntShrinkTime=0;
    while left<=right && cntShrinkTime<=maxShrinkTime
        varp=zeros(uint16((right-left)/dt+1),1);
        cnt=0;
        for i=left:dt:right
            cnt=cnt+1;
            [tp,tperiod]=calc_p_T3(i,1e6);
            txishu=polyfit([1:tperiod*100],tp,1);
            varp(cnt)=abs(txishu(1));
        end
        [minVar,minVarIdx]=min(varp);
        ansT=left+dt*(minVarIdx-1);
        %[ansp,ansPeriod]=calc_p_T3(ansT,1e5);
        dt=dt/Shrink;
        left=ansT-dt*Shrink+dt;
        if ansT==0
            left=0;
        end
        right=ansT+dt*Shrink-dt;
        cntShrinkTime=cntShrinkTime+1;
    end
    ansp3(:,j-35)=calc_p_T3(ansT,1e6);
end

xs3=zeros(9,2);
for i=1:9
    xs3(i,:)=polyfit([1:1e6],ansp3(:,i),1);
end

ansp4=zeros(1e6,9);
for j=40.1:0.1:40.9
    new_curve=zhenfa_curve;
    new_curve((j/0.01+1):(j/0.01+1)+245,2)=zhenfa_curve(1:246,2);
    left=0; right=2;
    dt=0.1; maxShrinkTime=3; Shrink=10; cntShrinkTime=0;
    while left<=right && cntShrinkTime<=maxShrinkTime
        varp=zeros(uint16((right-left)/dt+1),1);
        cnt=0;
        for i=left:dt:right
            cnt=cnt+1;
            [tp,tperiod]=calc_p_T3(i,1e6);
            txishu=polyfit([1:tperiod*100],tp,1);
            varp(cnt)=abs(txishu(1));
        end
        [minVar,minVarIdx]=min(varp);
        ansT=left+dt*(minVarIdx-1);
        %[ansp,ansPeriod]=calc_p_T3(ansT,1e5);
        dt=dt/Shrink;
        left=ansT-dt*Shrink+dt;
        if ansT==0
            left=0;
        end
        right=ansT+dt*Shrink-dt;
        cntShrinkTime=cntShrinkTime+1;
    end
    ansp4(:,uint8((j-40)/0.1))=calc_p_T3(ansT,1e6);
end

xs4=zeros(9,2);
for i=1:9
    xs4(i,:)=polyfit([1:1e6],ansp4(:,i),1);
end

ansT_1=ansT;

tsleft=95; tsright=105;
dts=1; tsMaxShrinkTime=2; tsCntShrinkTime=0;
while tsCntShrinkTime<=tsMaxShrinkTime && tsleft<=tsright
    tsvarp=zeros(uint16((tsright-tsleft)/dts+1),1);
    tscnt=0;
    for ii=tsleft:dts:tsright
        tscnt=tscnt+1;
        [tp,tPeriod]=calc_p_T3_2(ansT_1,ii,1e6);
        tstxishu=polyfit([1:tPeriod*100],tp,1);
        tsvarp(tscnt)=abs(tstxishu(1));
    end
    [tsminVar,tsminVarIdx]=min(tsvarp);
    tsansT=tsleft+dts*(tsminVarIdx-1);
    dts=dts/10;
    tsleft=tsansT-dts*10+dts;
    if tsansT==0
        tsleft=0;
    end
    tsright=tsansT+dts*10-dts;
    tsCntShrinkTime=tsCntShrinkTime+1;
end
tsansp=calc_p_T3_2(ansT_1,tsansT,1e6);

figure(1)
hold on
plot([0:0.01:1e4],[100;ansp(:,1)]);
xlabel('时间t/ms');
ylabel('压力p/MPa');
plot([0,1e4],[100,100],'r--');
hold off

figure(2)
hold on
plot([0:0.01:1e4],[100;ansp(:,2)]);
xlabel('时间t/ms');
ylabel('压力p/MPa');
plot([0,1e4],[100,100],'r--');
hold off

figure(3)
hold on
plot([0:0.01:1e4],[100;ansp(:,3)]);
xlabel('时间t/ms');
ylabel('压力p/MPa');
plot([0,1e4],[100,100],'r--');
hold off

figure(4)
hold on
plot([0:0.01:1e4],[100;ansp(:,4)]);
xlabel('时间t/ms');
ylabel('压力p/MPa');
plot([0,1e4],[100,100],'r--');
hold off

figure(5)
hold on
plot([0:0.01:1e4],[100;ansp(:,5)]);
xlabel('时间t/ms');
ylabel('压力p/MPa');
plot([0,1e4],[100,100],'r--');
hold off

figure(6)
hold on
plot([0:0.01:1e4],[100;ansp4(:,2)]);
xlabel('时间t/ms');
ylabel('压力p/MPa');
plot([0,1e4],[100,100],'r--');
hold off

figure(7)
hold on
plot([0:0.01:1e4],[100;tsansp]);
xlabel('时间t/ms');
ylabel('压力p/MPa');
plot([0,1e4],[100,100],'r--');
hold off
