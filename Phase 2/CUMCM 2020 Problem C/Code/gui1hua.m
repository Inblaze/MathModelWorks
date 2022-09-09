function gui1=gui1hua(matr,mode)
if nargin==1
    mode=1;
end
[rows,cols]=size(matr);
gui1=zeros(rows,cols);
mMax=max(matr); mMin=min(matr);
if mode==0
    for i=1:cols
        gui1(:,i)=(2*(matr(:,i)-mMin(i))/(mMax(i)-mMin(i)))-1;
    end
else
    for i=1:cols
        gui1(:,i)=(matr(:,i)-mMin(i))/(mMax(i)-mMin(i));
    end
end
end