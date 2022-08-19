%计算单向阀开启时长为T时的共轭周期和共轭周期内每0.01ms时刻的压力
function [p,period]=calc_p(T,nowrho,n)
global rho_gaoya xs_rho_p repOutSpeed capacity xs_p_rho

tmpT=uint16(T*100);
if nargin==1
    nowrho=0.85;
    n=lcm(tmpT+10*100,100*100);
end
if nargin==2
    n=lcm(tmpT+10*100,100*100);
end

if nargout==2
    period=double(n)/100;
end

p=zeros(n+1,1);

for i=1:n
    p(i)=polyval(xs_rho_p,nowrho);
    InSpeed=getQ(p(i));
    ti=mod(i,10000);
    if mod(i,10000)==0
        ti=10000;
    end
    md=mod(i,tmpT+1000);
    if md<tmpT
        dVin=InSpeed*0.01;
        if md==0
            dVin=0;
        end
    else
        dVin=0;
    end
    dVout=repOutSpeed(ti)*0.01;
    dm=dVin*rho_gaoya-dVout*polyval(xs_p_rho,p(i));
    nowrho=nowrho+dm/capacity;
end
p=p(2:n);
end

function Q=getQ(nowp)
%nowp为现在的压强，highRho为高压侧的压强
global rho_gaoya;
if nowp>=160
    Q=0;
    return;
end
Q=(0.85*pi*(1.4/2)^2)*sqrt(2*(160-nowp)/rho_gaoya);
end