function [p,T,mindis]=reach_in_time(tm)
left=0; right=tm-10;
[leftp,leftT]=calc_p(left,0.85,tm/0.01);
leftdis=leftp(tm/0.01-1)-150;
[rightp,rightT]=calc_p(right,0.85,tm/0.01);
rightdis=rightp(tm/0.01-1)-150;

while left<right
    mid=(left+right)/2;
    [tp,T]=calc_p(mid,0.85,tm/0.01);
    middis=tp(tm/0.01-1)-150;
    if middis==0
        ansp=tp;
        mindis=middis;
        break;
    end
    if middis*leftdis<0
        right=mid-0.01;
        [rightp,rightT]=calc_p(right,0.85,tm/0.01);
        rightdis=rightp(tm/0.01-1)-150;
        continue;
    else
        left=mid+0.01;
        [leftp,leftT]=calc_p(left,0.85,tm/0.01);
        leftdis=leftp(tm/0.01-1)-150;
        continue;
    end
end

p=tp; T=mid;
mindis=middis;
end