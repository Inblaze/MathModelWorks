function [mindis,xs]=get_rho_p_polyfit(rho_with_p)

xishu=zeros(10,11);

for i=1:10
    xishu(i,1:i+1)=polyfit(rho_with_p(:,1),rho_with_p(:,2),i);
end

dis=zeros(10,1);

for i=1:10
    ty=zeros(length(rho_with_p(:,1)),1);
    tmp=ones(length(rho_with_p(:,1)),1);
    for j=i:-1:1
        tmp=tmp.*rho_with_p(:,1);
        ty=ty+xishu(i,j)*tmp;
    end
    ty=ty+xishu(i,i+1);
    dis(i)=sqrt(sum((ty-rho_with_p(:,2)).^2));
end

[mindis,idx]=min(dis);
xs=xishu(idx,1:idx+1);
end