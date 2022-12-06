27*0.05*20+27



B = 27*(1.05)^20
a = 0.4123*12;
LCLV = 0.05;
nMF = 20;
M = a*(1+LCLV)*(-1+(1+LCLV)^nMF)/LCLV

27*(1+LCLV)^nMF+a*(1+LCLV)*(-1+(1+LCLV)^nMF)/LCLV - 0.2*12*(1+LCLV)*(-1+(1+LCLV)^nMF)/LCLV

(B+M)/(1.04)^20

0.2*12*(1+0.05)*(-1+(1+0.05)^20)/0.04;
%
% 0.2*12*(1+0.05)^0*(1+0.05)^(n-1)+...
% 0.2*12*(1+0.05)^1*(1+0.05)^(n-2)+...
% 0.2*12*(1+0.05)^2*(1+0.05)^(n-3)+...
% 0.2*12*(1+0.05)^3*(1+0.05)^(n-4)+...
% 0.2*12*(1+0.05)^4*(1+0.05)^(n-5)+...
% 0.2*12*(1+0.05)^5*(1+0.05)^(n-6)+...

%%
clear all
clc
% 没有考虑房屋折旧费用
% 如果个人理财能力不强，跑不赢通胀率，租房22-32年后会成本高于买房，且后续成本越来越高，买房还会拥有房产价值
% 如果个人理财能力强，跑赢通胀率5%每年，买房前50年成本越来越高，50年时高于买房200万（0.03的房租增长率），如果0.08房租增长率则买房划算
% 美国的房价在过去100多年中的年平均增长率约为3％，略高于美国的通胀率(2．8％)。
a = 0.4123*12;
LCLV = 0.04;
TZL = 0.05;
LCSYLV = LCLV -TZL ;
FZSZL = 0.05;
nMF = 20;

if LCSYLV ==0
    MFZHF = 27+a*nMF;
else
    MFZHF = 27*(1+LCSYLV)^nMF+a*(1+LCSYLV)*(-1+(1+LCSYLV)^nMF)/LCSYLV;
end
FCJZ = 90*(0.03-0.028)*nMF;

nZF =1;
for jj=1:20
    
    nZF =jj;
    
    if nZF >20
        if LCSYLV ==0
            MFZHF = 27+a*nMF;
        else
            MFZHF = (27*(1+LCSYLV)^nMF+a*(1+LCSYLV)*(-1+(1+LCSYLV)^nMF)/LCSYLV)*(1+LCSYLV)^(nZF-20);
        end
        
    else if nZF <20
            if LCSYLV ==0
                MFZHF = 27+a*nMF;
            else
                MFZHF =  27*(1+LCSYLV)^nZF+a*(1+LCSYLV)*(-1+(1+LCSYLV)^nZF)/LCSYLV;
            end            
        end
    end
    
    ZFZHF=0;
    for  i =1:nZF
        ZFYNHF = 0.2*12*(1+FZSZL)^(i-1) * (1+LCSYLV)^(nZF-i);
        ZFZHF = ZFZHF+ZFYNHF;
    end
    FCJZ = 90*(0.07-0.03)*nZF;
    C(jj) = MFZHF - ZFZHF-FCJZ;
    
end


figure
plot(C)








