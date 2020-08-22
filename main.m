clear
clc
%% 参数定义
% MPC参数如下
% 采样时间：T=20s
% 预测范围：30T
% 控制范围：5T
% 注：在6T-30T之间，输入量即电流i值保持不变
global R0 Rp Q up I SOC Uoc Pi Pload T hor_pre
format long;

%单个电池参数（4个电池都一样）
R0=@(soc)(7.1*soc^2-11.49*soc+11.43)/50;
Rp=@(soc)(5036*soc^4-8684*soc^3+5446*soc^2-1436*soc+202.9)/50;
Uoc=@(soc)(0.3865*soc^4+1.8238*soc^3-3.2923*soc^2+1.7595*soc+2.8904)*20;
%Up(i.soc) 插值得到
up=20*[0.0412000000000000,0.0495000000000000,0.0494000000000000,0.0473000000000000,0.0529000000000000,0.0537000000000000,0.0627000000000000,0.0822000000000000,0.130300000000000;0.0417000000000000,0.0513000000000000,0.0499000000000000,0.0478000000000000,0.0534000000000000,0.0541000000000000,0.0633000000000000,0.0839000000000000,0.141500000000000;0.0421000000000000,0.0503000000000000,0.0502000000000000,0.0481000000000000,0.0538000000000000,0.0545000000000000,0.0657000000000000,0.0835000000000000,0.147700000000000;0.0444000000000000,0.0527000000000000,0.0505000000000000,0.0504000000000000,0.0541000000000000,0.0559000000000000,0.0688000000000000,0.0840000000000000,0.152000000000000;0.0474000000000000,0.0537000000000000,0.0516000000000000,0.0485000000000000,0.0522000000000000,0.0569000000000000,0.0662000000000000,0.0861000000000000,0.149800000000000;0.0457000000000000,0.0529000000000000,0.0519000000000000,0.0508000000000000,0.0534000000000000,0.0566000000000000,0.0700000000000000,0.0829000000000000,0.157800000000000;0.0425000000000000,0.0508000000000000,0.0507000000000000,0.0485000000000000,0.0543000000000000,0.0575000000000000,0.0733000000000000,0.0923000000000000,0.152200000000000;0.0463000000000000,0.0509000000000000,0.0508000000000000,0.0517000000000000,0.0544000000000000,0.0601000000000000,0.0735000000000000,0.0935000000000000,0.163600000000000;0.0482000000000000,0.0508000000000000,0.0537000000000000,0.0506000000000000,0.0543000000000000,0.0551000000000000,0.0744000000000000,0.0904000000000000,0.170000000000000;0.0500000000000000,0.0510000000000000,0.0548000000000000,0.0527000000000000,0.0555000000000000,0.0582000000000000,0.0778000000000000,0.0944000000000000,0.169900000000000];
I=0.1:0.1:1;SOC=0.1:0.1:0.9;
[SOC,I]=meshgrid(SOC,I);

hor_pre=30;                     %预测范围
hor_con=5;                      %控制范围
T=20;                           %采样周期
num_con=10;                     %迭代控制次数

Q=3.3*3600;                     %电池容量为3.3Ah
Pload=1000;                     %电池负载
Pi=ones(hor_pre,4)*400;         %光伏输入功率

%% start
im=zeros(hor_con,4,num_con);
fm=zeros(1,num_con);

soc=0.2*ones(1,4,num_con+1);
soc(1,:,1)=[0.2,0.25,0.3,0.35];
delta_soc=zeros(hor_pre,4,num_con);

for t=1:num_con
    t
    [im(:,:,t),fm(t)]=PSO(@fitness,50,1.5,2.5,0.5,100,hor_con,soc(1,:,t));
    [~,delta_soc(:,:,t)]=fitness(im(:,:,t),soc(1,:,t));                     %i作用后的delta_soc(将fitness返回值添加deltasoc)
    soc(1,:,t+1)=soc(1,:,t)+sum(delta_soc(1:hor_con,:,t),1);
end
