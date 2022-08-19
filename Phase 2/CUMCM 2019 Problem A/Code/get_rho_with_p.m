function rho_with_p=get_rho_with_p(E_with_p)
%rho-第二列 p-第一列
rho_with_p=zeros(401,2); 
st=find(E_with_p(:,1)==100);
rho_with_p(st,2)=0.85;
ed=length(E_with_p(:,1));
rho_with_p(:,1)=E_with_p(:,1);
dP=0.5;
for i=st:ed-1
    drho=rho_with_p(i,2)*dP/E_with_p(i,2);
    rho_with_p(i+1,2)=rho_with_p(i,2)+drho;
end

ed=1;
for i=st:-1:ed+1
    rho_with_p(i-1,2)=(E_with_p(i-1,2)*rho_with_p(i,2))/(dP+E_with_p(i-1,2));
end

end