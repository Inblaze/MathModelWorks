clc,clear

%获取图像信息并进行预处理的代码

%选择输入的图像路径
selpath = uigetdir(path);
if ~isequal(selpath,0)
    pathname=selpath;
    %app.foldnameEditField.Value=selpath;
else 
     warndlg('selpath fail','Warning');
    return
end

%%批量读取，处理，并输出
fileList=dir(fullfile(pathname,'*.jpg'));
nn=length(fileList);

%读取文件夹下图片的R、G、B值
R=zeros(20,30,nn);
G=zeros(20,30,nn);
B=zeros(20,30,nn);

%文件夹下图片的颜色值
RGB=zeros(20,30,nn);

for ii=1:nn
    filename=fileList(ii).name; 
    filename_new=strcat(filename(1:end-4),"_processed",".jpg");
    photo=imread(fullfile(pathname,filename));
    %使用imadjust增强rgb图像对比度，好像没什么用，所以屏蔽了
    %photo1=imadjust(photo,[.2 .3 0; .6 .7 1],[]);
    %figure,
    %subplot(131),imshow(uint8(photo));
    %subplot(132),imshow(uint8(photo1));
    R(:,:,ii)=photo(:,:,1);
    G(:,:,ii)=photo(:,:,2);
    B(:,:,ii)=photo(:,:,3);
    %颜色值 ＝ (65536 * Blue) + (256 * Green) + (Red)
    %RGB(:,:,ii)=R(:,:,ii)+256*G(:,:,ii)+65536*B(:,:,ii);
    RGB(:,:,ii)=R(:,:,ii)+G(:,:,ii)+B(:,:,ii);
end

disp("[Done] 图像颜色值原始数据");

%下面进行数据标准化，这里采用'平移极差变换'
stdRGB=zeros(20,30,nn); %标准化后的颜色值矩阵
tmpMax=[];
tmpMin=[];
for ii=1:nn
    tmpMax=[tmpMax,max(RGB,[],'all')];
    tmpMin=[tmpMin,min(RGB,[],'all')];
end
pixelMax=max(tmpMax);
pixelMin=min(tmpMin);
for ii=1:nn
    stdRGB(:,:,ii)=(RGB(:,:,ii)-pixelMin)/(pixelMax-pixelMin);
end

disp("[Done] 图像颜色值标准化数据");


%获取模糊相似矩阵并进行聚类的代码

%获取模糊相似矩阵
totImg=size(stdRGB,3);
FSM=zeros(totImg); %Fuzzy Similar Matrix
for i=1:totImg
    for j=1:totImg
        if i==j
            FSM(i,j)=1;
            continue;
        end
        %使用夹角余弦法计算相似度
        FSM(i,j)=sum(stdRGB(:,:,i).*stdRGB(:,:,j),"all")/...
            (sqrt(sum(stdRGB(:,:,i).*stdRGB(:,:,i),"all"))*sqrt(sum(stdRGB(:,:,j).*stdRGB(:,:,j),"all")));
    end
end

disp("[Done] 各图像的模糊相似矩阵");

%平方法求传递闭包
flag=0;
now=FSM;
while flag==0
    %disp("pass");
    next=FuzzyMatMul(now,now);
    if now==next
        flag=1;
    else
        now=next;
    end
end

disp("[Done] 传递闭包");

%最后一步截取，截取值这里取的是0.98
[row_now,col_now]=size(now);
cutNow=zeros(row_now,col_now);
for i=1:row_now
    for j=1:col_now
        if now(i,j)>=0.98
            cutNow(i,j)=1;
        end
    end
end

disp("[Done] 截取");
disp('')
disp('截阵:')
disp(cutNow)

classification=zeros(30,30); %行数i表示第i类，列数j表示该类中的第j个样本
numOfElemInClass=zeros(30); %每一类中样本的数量
totClass=0; %类数
for i=1:30
    if ismember(i,classification)
        continue;
    end
    totClass=totClass+1;
    for j=1:30
        if cutNow(i,j)==1
            numOfElemInClass(totClass)=numOfElemInClass(totClass)+1;
            classification(totClass,numOfElemInClass(totClass))=j;
        end
    end
end
classification=classification(1:totClass,1:max(numOfElemInClass));
disp('[Done] 分类')
disp('')
disp('分类结果（行表示类号，元素为0表示无）:')
disp(classification)

%使用纯度作为指标进行聚类评估
maxSameNum=zeros(totClass); %纯度
stdClass=[1:10;11:20;21:30]; %题干给的标准分类
for i=1:totClass
    for j=1:3
        maxSameNum(i)=max(maxSameNum(i),length(intersect(classification(i,:),stdClass(j,:))));
    end
end
purity=sum(maxSameNum,'all')/30;
disp('[Done] Purity')
disp(purity)