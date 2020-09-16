function [F,delta_soc]=fitness(i,soc)
% 输入：hor_con范围内的电流i (i为hor_con*4),电池的当前soc(1*4)
% 输出：适应度函数
global R0 Rp Q Uoc Pi Pload T hor_pre Up %up I SOC
% 初始SOC
% soc已传入
delta_soc=zeros(hor_pre,4);
eloss=zeros(hor_pre,4);
ediv=zeros(hor_pre,1);

%将控制变量i从hor_con扩充到hor_pre
for j=(size(i,1)+1):hor_pre
     i(j,:)=i(size(i,1),:);
end

U=zeros(hor_pre,4);
Po=zeros(hor_pre,4);
for j=1:hor_pre
    %充电
    for c=1:4
        U(j,c)=Uoc(soc(c))+3.3*i(j,c)*R0(soc(c))+Up(soc(c),i(j,c));
        Po(j,c)=U(j,c)*i(j,c)*3.3; 
        delta_soc(j,c)=(Pi(j,c)-Po(j,c))/U(j,c)/Q*T;
        if (soc(c)>0.9 && delta_soc(j,c)>0)||(soc(c)<0.1 && delta_soc(j,c)<0)
            delta_soc(j,c)=0;
        end
    end    
    soc=soc+delta_soc(j,:);
    %损耗
    for c=1:4
        A=0;
        if i(j,c)<0.1||i(j,c)>0.9||Po(j,c)<0||Po(j,c)>500||U(j,c)>72
            A=1;
        end
        eloss(j,c)=(3.3*3.3*i(j,c)*i(j,c)*R0(soc(c))+Up(soc(c),i(j,c))^2/Rp(soc(c)))*T+A*1e17;
    end
    %SOC一致性
    for x=1:3
        for y=x+1:4
            ediv(j)=ediv(j)+(soc(x)-soc(y))^2;
        end
    end
end

% 负载约束
B=0;
if any(sum(Po,2)<0.8*Pload)
    B=1;
end
if any(sum(Po,2)>1.2*Pload)
    B=1;
end
% 充放电功率约束
C=0;
if any(any(abs(Pi-Po)>200))
    C=1;
end
%总能量损耗
Eloss=sum(sum(eloss));
%电池SOC一致性
Ediv=sum(ediv);
%输出功率与负载功率一致性
ePo=abs(sum(Po,2)-Pload);
EPo=sum(ePo);
% F=Eloss+Ediv*1000000+EPo*1000+B*1e15+C*1e20;
F=Eloss+5e6*Ediv+EPo*100+B*1e15+C*1e20;
end