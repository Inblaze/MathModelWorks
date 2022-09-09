clear,clc
nCompany=302;
load("data2.mat");
% 设置导入选项并导入企业行业数据
opts = spreadsheetImportOptions("NumVariables", 1);
opts.Sheet = "企业信息";
opts.DataRange = "C2:C303";
opts.VariableNames = "VarName3";
opts.VariableTypes = "string";
opts = setvaropts(opts, "VarName3", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "VarName3", "EmptyFieldRule", "auto");
industries = readmatrix("企业行业.xlsx", opts, "UseExcel", false);
clear opts

[nrows,ncols]=size(industries);
attr_test(:,7)=0; descend=zeros(nCompany,1);
for i=1:nrows
    if industries(i)=='农林牧渔业'
        descend(i)=-2.6;
        continue;
    end
    if industries(i)=='制造业'
        descend(i)=-10.1;
        continue;
    end
    if industries(i)=='建筑业'
        descend(i)=-18.2;
        continue;
    end
    if industries(i)=='零售批发业'
        descend(i)=-17.5;
        continue;
    end
    if industries(i)=='交通运输业'
        descend(i)=-13.6;
        continue;
    end
    if industries(i)=='住宿餐饮业'
        descend(i)=-39.5;
        continue;
    end
    if industries(i)=='金融业'
        descend(i)=4.9;
        continue;
    end
    if industries(i)=='房地产业'
        descend(i)=-7.6;
        continue;
    end
    if industries(i)=='信息传输，互联网行业'
        descend(i)=14.6;
        continue;
    end
    if industries(i)=='商务服务业'
        descend(i)=-6.7;
        continue;
    end
    if industries(i)=='其他行业'
        descend(i)=-2;
    end
end

attr_test(:,7)=gui1hua(descend);

% 计算得分
score=zeros(nCompany,1);
w_score=shangQuan(attr_test);
for i=1:nCompany
    score(i)=attr_test(i,:)*w_score';
end

% 导入流失率和量化评级
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
                credit_level(i)=4;
                score(i)=0;
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
lb(:)=0.04-0.005; lb(find(credit_level==4))=0;
ub=zeros(nCompany,1); 
ub(:)=0.15-0.005; ub(find(credit_level==4))=0;
[x,maxInterest]=ga(@gafun2,302,[],[],[],[],lb,ub);
maxInterest=-maxInterest;
