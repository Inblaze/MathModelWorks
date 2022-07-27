function [R]=FuzzyMatMul(A,B)
%模糊矩阵相乘，先取小后取大

[m,n]=size(A);[q,p]=size(B);%获得输入矩阵的维度信息
if n~=q
    disp('第一个矩阵的列数和第二个矩阵的行数不相同！');
else
    R=zeros(m,p);%初始化矩阵
for k =1:m    
    for j=1:p
        temp=[];
        for i =1:n
            Min = min(A(k,i),B(i,j)); %求出第i对的最小值
            temp=[temp Min]; %将求出的最小值加入的数组中
        end
        R(k,j)=max(temp);
    end
end

end