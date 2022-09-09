%计算训练集数据

nMonth=41;
nCompany=123; 
attr_train=zeros(nCompany,6);
companyProfit=zeros(nCompany,nMonth);
% 计算发展潜力得分
[in_num,in_txt,in_raw]=xlsread("附件1：123家有信贷记录企业的相关数据.xlsx","仅删去作废发票的进项发票信息");
[out_num,out_txt,out_raw]=xlsread("附件1：123家有信贷记录企业的相关数据.xlsx","仅删去作废发票的销项发票信息");
in_tmp=[in_raw(:,9),in_raw(:,3),in_raw(:,7),in_raw(:,4)];
out_tmp=[out_raw(:,9),out_raw(:,3),out_raw(:,7),out_raw(:,4)];
[inrows,xlscols]=size(in_tmp);
[outrows,xlscols]=size(out_tmp);

cnt=0;
for i=2:inrows
    dt=datetime(in_tmp{i,2});
    if year(dt)~=2016
        cnt=(year(dt)-2017)*12+3+month(dt);
    else
        cnt=month(dt)-9;
    end
    companyProfit(in_tmp{i,1},cnt)=companyProfit(in_tmp{i,1},cnt)-in_tmp{i,3};
end
for i=2:outrows
    dt=datetime(out_tmp{i,2});
    if year(dt)~=2016
        cnt=(year(dt)-2017)*12+3+month(dt);
    else
        cnt=month(dt)-9;
    end
    companyProfit(out_tmp{i,1},cnt)=companyProfit(out_tmp{i,1},cnt)+out_tmp{i,3};
end

averageGRate=zeros(nCompany,1);
for i=1:nCompany
    not0pro=companyProfit(i,companyProfit(i,:)~=0);
    averageGRate(i)=mean(diff(not0pro)./abs(not0pro(1:length(not0pro)-1)),2);
end
attr_train(:,3)=gui1hua(averageGRate);

% 计算上下游影响力
up_down_stream=zeros(nCompany,4);
inCnt=[]; outCnt=[];
nowCompany=1;
for i=2:inrows
    if in_tmp{i,1}~=nowCompany
        up_down_stream(nowCompany,2)=length(inCnt);
        inCnt=[];
        nowCompany=in_tmp{i,1};
    end
    up_down_stream(nowCompany,1)=up_down_stream(nowCompany,1)+in_tmp{i,3};
    if ismember(in_tmp{i,4},inCnt)==0
        inCnt=[inCnt in_tmp{i,4}];
    end
end
nowCompany=1;
for i=2:outrows
    if out_tmp{i,1}~=nowCompany
        up_down_stream(nowCompany,4)=length(outCnt);
        outCnt=[];
        nowCompany=out_tmp{i,1};
    end
    up_down_stream(nowCompany,3)=up_down_stream(nowCompany,3)+out_tmp{i,3};
    if ismember(out_tmp{i,4},outCnt)==0
        outCnt=[outCnt out_tmp{i,4}];
    end
end
gui1_tmp=gui1hua(up_down_stream);
w_tmp=shangQuan(gui1_tmp(all(gui1_tmp,2),:));
for i=1:nCompany
    attr_train(i,6)=gui1_tmp(i,:)*w_tmp';
end

% 计算利润总额
attr_train(any(companyProfit,2),4)=gui1hua(sum(companyProfit(any(companyProfit,2),:),2));

% 计算最大流动资金
nowCompany=1;
maxAmount=-99999999;
maxInAmount=zeros(nCompany,1);
for i=2:inrows
    if in_tmp{i,1}~=nowCompany
        maxInAmount(nowCompany)=maxAmount;
        nowCompany=in_tmp{i,1};
        maxAmount=-99999999;
    end
    if maxAmount<in_tmp{i,3}
        maxAmount=in_tmp{i,3};
    end
end
attr_train(maxInAmount~=0,5)=gui1hua(maxInAmount(maxInAmount~=0));

% 计算测试集数据

nMonth=41;
nCompany=123+302; 
attr_test=zeros(nCompany,6);
companyProfit=zeros(nCompany,nMonth);
% 计算发展潜力得分
[in_num,in_txt,in_raw]=xlsread("附件2：302家无信贷记录企业的相关数据.xlsx","仅删去作废发票的进项发票信息");
[out_num,out_txt,out_raw]=xlsread("附件2：302家无信贷记录企业的相关数据.xlsx","仅删去作废发票的销项发票信息");
in_tmp=[in_raw(:,9),in_raw(:,3),in_raw(:,7),in_raw(:,4)];
out_tmp=[out_raw(:,9),out_raw(:,3),out_raw(:,7),out_raw(:,4)];
[inrows,xlscols]=size(in_tmp);
[outrows,xlscols]=size(out_tmp);

cnt=0;
for i=2:inrows
    dt=datetime(in_tmp{i,2});
    if year(dt)~=2016
        cnt=(year(dt)-2017)*12+3+month(dt);
    else
        cnt=month(dt)-9;
    end
    companyProfit(in_tmp{i,1},cnt)=companyProfit(in_tmp{i,1},cnt)-in_tmp{i,3};
end
for i=2:outrows
    dt=datetime(out_tmp{i,2});
    if year(dt)~=2016
        cnt=(year(dt)-2017)*12+3+month(dt);
    else
        cnt=month(dt)-9;
    end
    companyProfit(out_tmp{i,1},cnt)=companyProfit(out_tmp{i,1},cnt)+out_tmp{i,3};
end

averageGRate=zeros(nCompany,1);
for i=1:nCompany
    not0pro=companyProfit(i,companyProfit(i,:)~=0);
    averageGRate(i)=mean(diff(not0pro)./abs(not0pro(1:length(not0pro)-1)),2);
end
attr_test(:,3)=gui1hua(averageGRate);

% 计算上下游影响力
up_down_stream=zeros(nCompany,4);
inCnt=[]; outCnt=[];
nowCompany=1;
for i=2:inrows
    if in_tmp{i,1}~=nowCompany
        up_down_stream(nowCompany,2)=length(inCnt);
        inCnt=[];
        nowCompany=in_tmp{i,1};
    end
    up_down_stream(nowCompany,1)=up_down_stream(nowCompany,1)+in_tmp{i,3};
    if ismember(in_tmp{i,4},inCnt)==0
        inCnt=[inCnt in_tmp{i,4}];
    end
end
nowCompany=1;
for i=2:outrows
    if out_tmp{i,1}~=nowCompany
        up_down_stream(nowCompany,4)=length(outCnt);
        outCnt=[];
        nowCompany=out_tmp{i,1};
    end
    up_down_stream(nowCompany,3)=up_down_stream(nowCompany,3)+out_tmp{i,3};
    if ismember(out_tmp{i,4},outCnt)==0
        outCnt=[outCnt out_tmp{i,4}];
    end
end
gui1_tmp=gui1hua(up_down_stream);
w_tmp=shangQuan(gui1_tmp(all(gui1_tmp,2),:));
for i=1:nCompany
    attr_test(i,6)=gui1_tmp(i,:)*w_tmp';
end

% 计算利润总额
attr_test(any(companyProfit,2),4)=gui1hua(sum(companyProfit(any(companyProfit,2),:),2));

% 计算最大流动资金
nowCompany=1;
maxAmount=-99999999;
maxInAmount=zeros(nCompany,1);
for i=2:inrows
    if in_tmp{i,1}~=nowCompany
        maxInAmount(nowCompany)=maxAmount;
        nowCompany=in_tmp{i,1};
        maxAmount=-99999999;
    end
    if maxAmount<in_tmp{i,3}
        maxAmount=in_tmp{i,3};
    end
end
attr_test(maxInAmount~=0,5)=gui1hua(maxInAmount(maxInAmount~=0));
attr_test=attr_test(124:(123+302),:); nCompany=302;

% 导入训练集
opts = spreadsheetImportOptions("NumVariables", 6);
opts.Sheet = "Sheet1";
opts.DataRange = "A2:F124";
opts.VariableNames = ["VarName1", "VarName2", "VarName3", "VarName4", "VarName5", "VarName6"];
opts.VariableTypes = ["double", "double", "double", "double", "categorical", "categorical"];
opts = setvaropts(opts, ["VarName5", "VarName6"], "EmptyFieldRule", "auto");
train = readtable("train.xlsx", opts, "UseExcel", false);
clear opts

% 导入需要预测的数据集
opts = spreadsheetImportOptions("NumVariables", 4);
opts.Sheet = "Sheet1";
opts.DataRange = "A2:D303";
opts.VariableNames = ["VarName1", "VarName2", "VarName3", "VarName4"];
opts.VariableTypes = ["double", "double", "double", "double"];
test = readtable("test.xlsx", opts, "UseExcel", false);
clear opts

[trainedClassifier1,validationAccuracy1]=trainClassifier1(train);
yfit1=trainedClassifier1(test);
[trainedClassifier2,validationAccuracy2]=trainClassifier2(train);
yfit2=trainedClassifier2(test);

for i=1:nCompany
    if yfit1(i)=='A'
        attr_test(i,1)=1;
    else
        if yfit1(i)=='B'
            attr_test(i,1)=0.85;
        else
            if yfit1(i)=='C'
                attr_test(i,1)=0.7;
            else
                attr_test(i,1)=0;
            end
        end
    end

    if yfit2(i)=="否"
        attr_test(i,2)=1;
    else
        attr_test(i,2)=0;
    end
end

% 计算得分
score=zeros(nCompany,1);
w_score=shangQuan(attr_test);
for i=1:nCompany
    score(i)=attr_test(i,:)*w_score';
end

% 导入流失率数据并拟合
loss_xls=xlsread("附件3：银行贷款年利率与客户流失率关系的统计数据.xlsx","Sheet1");
global credit_level lossFit
credit_level=zeros(nCompany,1);
for i=1:nCompany
    if yfit1(i)=='A'
        credit_level(i)=1;
    else
        if yfit1(i)=='B'
            credit_level(i)=2;
        else
            if yfit1(i)=='C'
                credit_level(i)=3;
            else 
                score(i)=0;
                credit_level(i)=4;
            end
        end
    end
end
lossFit=zeros(3,4);
lossFit(1,:)=polyfit(loss_xls(:,1),loss_xls(:,2),3);
lossFit(2,:)=polyfit(loss_xls(:,1),loss_xls(:,3),3);
lossFit(3,:)=polyfit(loss_xls(:,1),loss_xls(:,4),3);
lossFit(4,:)=[0,0,0,1];

% 计算贷款额度
global allocAmount
bankAmount=1e8;
sumScore=sum(score);
allocAmount=(score/sumScore)*bankAmount;
alloc_tmp=allocAmount(allocAmount>1e6);
rest=sum(alloc_tmp)-1e6*length(alloc_tmp);
alloc_tmp=allocAmount(allocAmount<1e5);
rest=rest+sum(alloc_tmp);
sum_tmp=sum(score(allocAmount<1e6 & allocAmount>1e5));
alloc_tmp=(score(allocAmount<1e6 & allocAmount>1e5)/sum_tmp)*rest;
allocAmount(allocAmount<1e6 & allocAmount>1e5)=allocAmount(allocAmount<1e6 & allocAmount>1e5)+alloc_tmp;
allocAmount(allocAmount>1e6)=1e6;
allocAmount(allocAmount<1e5)=0;

% 计算利率
lb=zeros(nCompany,1); 
lb(:)=0.04; lb(find(credit_level==4))=0;
ub=zeros(nCompany,1); 
ub(:)=0.15; ub(find(credit_level==4))=0;
[x,maxInterest]=ga(@gafun2,302,[],[],[],[],lb,ub);
maxInterest=-maxInterest;
