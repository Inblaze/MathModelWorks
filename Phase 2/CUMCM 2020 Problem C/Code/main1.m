nMonth=41;
nCompany=123; 
attr=zeros(nCompany,6);
companyProfit=zeros(nCompany,nMonth);
% 计算发展潜力得分
[in_num,in_txt,in_raw]=xlsread("附件1：123家有信贷记录企业的相关数据.xlsx","删去无效信息后的进项发票");
[out_num,out_txt,out_raw]=xlsread("附件1：123家有信贷记录企业的相关数据.xlsx","删去无效信息后的销项发票");
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
attr(:,3)=gui1hua(averageGRate);

% 计算上下游影响力
up_down_stream=zeros(nCompany,4);
inCnt=[]; outCnt=[];
nowCompany=1;
for i=2:inrows
    if in_tmp{i,1}~=nowCompany;
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
    if out_tmp{i,1}~=nowCompany;
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
    attr(i,6)=gui1_tmp(i,:)*w_tmp';
end

% 计算利润总额
attr(any(companyProfit,2),4)=gui1hua(sum(companyProfit(any(companyProfit,2),:),2));

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
attr(maxInAmount~=0,5)=gui1hua(maxInAmount(maxInAmount~=0));

% 信誉评级和是否违约的指标
[info_num,info_txt,info_raw]=xlsread("附件1：123家有信贷记录企业的相关数据.xlsx","企业信息");
[inforows,infocols]=size(info_raw);
for i=2:inforows
    grade=info_raw{i,3};
    wy=info_raw{i,4};
    if grade=='A'
        attr(i-1,1)=1;
    else
        if grade=='B'
            attr(i-1,1)=0.85;
        else
            if grade=='C'
                attr(i-1,1)=0.70;
            else
                attr(i-1,1)=0;
                continue;
            end
        end
    end
    if wy=='是'
        attr(i-1,2)=0;
    else
        attr(i-1,2)=1;
    end
end

% 计算得分
score=zeros(nCompany,1);
w_score=shangQuan(attr(~isnan(attr(:,3)),:));
for i=1:nCompany
    if isnan(attr(i,3))
        score(i)=0;
        continue;
    end
    score(i)=attr(i,:)*w_score';
end

% 计算分配比率
global allocRate
sumScore=sum(score(score>=0));
allocRate=zeros(nCompany,1);
allocRate(score>=0)=score(score>=0)/sumScore;

% 计算利率
loss_xls=xlsread("附件3：银行贷款年利率与客户流失率关系的统计数据.xlsx","Sheet1");
global credit_level lossFit
credit_level=zeros(nCompany,1);
for i=1:nCompany
    if info_txt{i+1,3}=='A'
        credit_level(i)=1;
    else
        if info_txt{i+1,3}=='B'
            credit_level(i)=2;
        else
            if info_txt{i+1,3}=='C'
                credit_level(i)=3;
            else 
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

lb=zeros(nCompany,1); 
lb(:)=0.04; lb(find(credit_level==4))=0;
ub=zeros(nCompany,1); 
ub(:)=0.15; ub(find(credit_level==4))=0;
[x,maxInterest]=ga(@gafun1,123,[],[],[],[],lb,ub);
maxInterest=-maxInterest;