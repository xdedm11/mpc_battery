function[xm,fv] = PSO(fitness,N,c1,c2,w,M,D,soc)
% F=fitness(i,soc) 输入：hor_con范围内的电流i (i为hor_con*4),电池的当前soc(1*4)
% N：初始化群体个体数目
% c1,c2：学习因子
% w：惯性权重
% M：最大迭代次数
% D：搜索空间维数,与适应度函数有关

% 初始化种群的个体（可以在这里限定位置和速度的范围）
format long;
x=zeros(D,4,N);v=x;y=x;
for i = 1:N                                 % N：初始化群体个体数目
    for j=1:D                               % D：搜索空间维数
        for k=1:4                           % 4个电池
            x(j,k,i) = rand*0.8+0.1;        % 随机初始化位置(均匀分布)(0.1,0.9)
            v(j,k,i) = rand*0.2-0.1;        % 随即初始化速度(-0.1,0.1)
        end
    end
end

% 先计算各个粒子的适应度，并初始化p和pg
p=zeros(1,N);
for i=1:N
    p(i) = fitness(x(:,:,i),soc);
    y(:,:,i) = x(:,:,i);                    % y为个体最优(三维矩阵)
end 
pg = x(:,:,N);                              % pg为全局最优(初始)（二维矩阵）
for i=1:(N-1)
    if fitness(x(:,:,i),soc)<fitness(pg,soc)
        pg = x(:,:,i);
    end
end

% 进入主要循环，按照公式依次迭代，直到满足精度要求
Pbest=zeros(M,1);
for t=1:M
    for i=1:N                               % 更新速度、位移
        v(:,:,i)=w*v(:,:,i)+c1*rand*(y(:,:,i)-x(:,:,i))+c2*rand*(pg-x(:,:,i));
        x(:,:,i)=x(:,:,i)+v(:,:,i);
        if fitness(x(:,:,i),soc) < p(i)
            p(i)=fitness(x(:,:,i),soc);
            y(:,:,i)=x(:,:,i);              % 个体最优
        end
        if p(i) < fitness(pg,soc)
            pg= y(:,:,i);                   % 群体最优
        end
    end
    Pbest(t,1)=fitness(pg,soc);                 % 每次迭代最优值记录
end

% 输出结果
%disp('目标函数取最小值时的自变量：')
xm=pg;
%disp('目标函数的最小值为：')
fv=fitness(pg);