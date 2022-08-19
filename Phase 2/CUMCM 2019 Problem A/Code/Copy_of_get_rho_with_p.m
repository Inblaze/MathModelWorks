function rho_with_p=get_rho_with_p(E_with_p)
rho_with_p=zeros(201,2); rho_with_p(1,2)=0.85;
st=find(E_with_p(:,1)==100);
ed=length(E_with_p(:,1));
rho_with_p(:,1)=E_with_p(st:end,1);
dP=0.5;
for i=st:ed-1
    drho=rho_with_p(i-st+1,2)*dP/E_with_p(i,2);
    rho_with_p(i-st+2,2)=rho_with_p(i-st+1,2)+drho;
end
end