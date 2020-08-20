function F=fitness(i,soc)
% ���룺hor_con��Χ�ڵĵ���i (iΪhor_con*4),��صĵ�ǰsoc(1*4)
% �������Ӧ�Ⱥ���
global R0 Rp Q up I SOC Uoc Pi Pload T hor_pre
% ��ʼSOC
% soc�Ѵ���
delta_soc=zeros(hor_pre,4);
eloss=zeros(hor_pre,4);

%�����Ʊ���i��hor_con���䵽hor_pre
for j=(size(i,1)+1):hor_pre
     i(j,:)=i(size(i,1),:);
end

for j=1:hor_pre
    %���
    for c=1:4
        U(j,c)=Uoc(soc(c))+3.3*i(j,c)*R0(soc(c))+interp2(SOC,I,up,soc(c),i(j,c),'spline');
        Po(j,c)=U(j,c)*i(j,c)*3.3; 
        delta_soc(j,c)=(Pi(j,c)-Po(j,c))/U(j,c)/Q*T;
        if (soc(c)>0.9 && delta_soc(j,c)>0)||(soc(c)<0.1 && delta_soc(j,c)<0)
            delta_soc(j,c)=0;
        end
    end    
    soc=soc+delta_soc(j,:);
    %���
    for c=1:4
        A=0;
        if i(j,c)<0.1||i(j,c)>0.9||Po(j,c)<0||Po(j,c)>1000||U(j,c)>72
            A=1;
        end
        eloss(j,c)=(3.3*3.3*i(j,c)*i(j,c)*R0(soc(c))+interp2(SOC,I,up,soc(c),i(j,c),'spline')^2/Rp(soc(c)))*T+A*1e15;
    end
end
% ����Լ��
B=0;
if any(sum(Po')<0.8*Pload)
    B=1;
end
if any(sum(Po')>1.2*Pload)
    B=1;
end
% ��ŵ繦��Լ��
Num=size(Po,1);
C=0;
if any(any(abs(Pi(1:Num,:)-Po)>200))
    C=1;
end
%���������
Eloss=sum(sum(eloss));
%���SOCһ����
Ediv=0;
for x=1:3
    for y=x+1:4
        Ediv=Ediv+(soc(x)-soc(y))^2;
    end
end
%��������븺�ع���һ����
ePo=abs(sum(Po')-Pload);
EPo=sum(ePo);
F=Eloss+Ediv+EPo*1000+B*1e15+C*1e20;
end