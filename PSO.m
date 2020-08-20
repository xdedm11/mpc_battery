function[xm,fv] = PSO(fitness,N,c1,c2,w,M,D,soc)
% F=fitness(i,soc) ���룺hor_con��Χ�ڵĵ���i (iΪhor_con*4),��صĵ�ǰsoc(1*4)
% N����ʼ��Ⱥ�������Ŀ
% c1,c2��ѧϰ����
% w������Ȩ��
% M������������
% D�������ռ�ά��,����Ӧ�Ⱥ����й�

% ��ʼ����Ⱥ�ĸ��壨�����������޶�λ�ú��ٶȵķ�Χ��
format long;
x=zeros(D,4,N);v=x;y=x;
for i = 1:N                                 % N����ʼ��Ⱥ�������Ŀ
    for j=1:D                               % D�������ռ�ά��
        for k=1:4                           % 4�����
            x(j,k,i) = rand*0.8+0.1;        % �����ʼ��λ��(���ȷֲ�)(0.1,0.9)
            v(j,k,i) = rand*0.2-0.1;        % �漴��ʼ���ٶ�(-0.1,0.1)
        end
    end
end

% �ȼ���������ӵ���Ӧ�ȣ�����ʼ��p��pg
p=zeros(1,N);
for i=1:N
    p(i) = fitness(x(:,:,i),soc);
    y(:,:,i) = x(:,:,i);                    % yΪ��������(��ά����)
end 
pg = x(:,:,N);                              % pgΪȫ������(��ʼ)����ά����
for i=1:(N-1)
    if fitness(x(:,:,i),soc)<fitness(pg,soc)
        pg = x(:,:,i);
    end
end

% ������Ҫѭ�������չ�ʽ���ε�����ֱ�����㾫��Ҫ��
Pbest=zeros(M,1);
for t=1:M
    for i=1:N                               % �����ٶȡ�λ��
        v(:,:,i)=w*v(:,:,i)+c1*rand*(y(:,:,i)-x(:,:,i))+c2*rand*(pg-x(:,:,i));
        x(:,:,i)=x(:,:,i)+v(:,:,i);
        if fitness(x(:,:,i),soc) < p(i)
            p(i)=fitness(x(:,:,i),soc);
            y(:,:,i)=x(:,:,i);              % ��������
        end
        if p(i) < fitness(pg,soc)
            pg= y(:,:,i);                   % Ⱥ������
        end
    end
    Pbest(t,1)=fitness(pg,soc);                 % ÿ�ε�������ֵ��¼
end

% ������
%disp('Ŀ�꺯��ȡ��Сֵʱ���Ա�����')
xm=pg;
%disp('Ŀ�꺯������СֵΪ��')
fv=fitness(pg);