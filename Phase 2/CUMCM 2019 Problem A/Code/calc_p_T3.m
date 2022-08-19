function [p,period,ra]=calc_p_T3(angularSpeed,n)
%角速度单位：rad/ms
global jijiao_jijin new_curve xs_rho_p xs_p_rho capacity

tmpT=uint16((2*pi/angularSpeed)*100);
if nargin==1
    n=lcm(uint64(tmpT+10*100),100*100);
end

if nargout==2 || nargout==3
    period=double(n)/100;
end

dt=0.01;
lastRho=0.85; lastAngle=pi; lastpa=0.5; 
lastRhoa=polyval(xs_p_rho,lastpa);
% lastRhoa=feval(xs_p_rho,lastpa);
initialRhoa=lastRhoa;
lastp=100;
minJijin=min(jijiao_jijin(:,2));
S=pi*(5^2)/4; A=pi*((1.4/2)^2); apertureS=pi*(1.4^2)/4; bottomS=pi*(2.5^2)/4;
h0=1.25*cotd(9);
maxCap=20+(max(jijiao_jijin(:,2))-minJijin)*S;
ma=maxCap*initialRhoa;
cntRound=1;
culmulativeAngle=0;

p=zeros(n,1);

for i=1:n
    culmulativeAngle=culmulativeAngle+dt*angularSpeed;
    if culmulativeAngle>=cntRound*pi
        cntRound=cntRound+1;
        ma=initialRhoa*maxCap;
    end
    lastAngle=mod(lastAngle+dt*angularSpeed,2*pi); %nowAngle
    %nowJijin=spline(jijiao_jijin(:,1),jijiao_jijin(:,2),lastAngle);
    nowJijin=2.413*cos(lastAngle)+4.826;
    nowCap=maxCap-(nowJijin-minJijin)*S;
    lastRhoa=ma/nowCap; %nowRhoa
    ra(i)=lastRhoa;
    lastpa=polyval(xs_rho_p,lastRhoa);
    % lastpa=feval(xs_rho_p,lastRhoa);
    if lastpa<=lastp
        dVin=0;
    else
        Qin=0.85*A*sqrt(2*(lastpa-lastp)/lastRhoa);
        dVin=Qin*dt;
        if dVin>nowCap
            dVin=nowCap;
        end
        ma=ma-dVin*lastRhoa;
        if ma<0
            ma=0;
        end
    end
    rise=new_curve(mod(i,10000)+1,2);
    circleR=1.25*(1+rise/h0);
    circleS=pi*(circleR^2)-bottomS;
    if lastp>4
        if circleS<=apertureS
            Qout=0.85*circleS*sqrt(2*(lastp-4)/lastRho);
        else
            Qout=0.85*apertureS*sqrt(2*(lastp-4)/lastRho);
        end
    else
        Qout=0;
    end
    dVout=Qout*dt;
    dm=dVin*lastRhoa-dVout*lastRho;
    lastRho=lastRho+dm/capacity;
    lastp=polyval(xs_rho_p,lastRho); %nowp
    % lastp=feval(xs_rho_p,lastRho);
    p(i)=lastp;
end

end