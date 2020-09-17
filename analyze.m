global R0 Uoc % up I SOC
%% 电流
process_i=zeros(hor_con*num_con,4);
for j=1:num_con
    process_i((hor_con*(j-1)+1):hor_con*j,:)=im(:,:,j);
end
figure(1)
hold on
for j=1:4
    plot(process_i(:,j));
end
xlabel('时间/T (T=20s)')
ylabel('充放电电流/C')
%% 荷电状态
process_delta_soc=zeros(hor_con*num_con,4);
for j=1:num_con
    process_delta_soc((hor_con*(j-1)+1):hor_con*j,:)=delta_soc(1:hor_con,:,j);
end
% process_soc=permute(soc,[3,2,1]); %11x4
process_soc=zeros(hor_con*num_con+1,4);
% process_soc(1,:)=0.2*ones(1,4);
process_soc(1,:)=[0.2,0.25,0.3,0.35];
for j=1:num_con*hor_con
    process_soc(j+1,:)=process_soc(j,:)+process_delta_soc(j,:);
end
figure(2)
hold on
for j=1:4
    plot(process_soc(:,j));
end
xlabel('时间/T (T=20s)')
ylabel('SoC')
%% 输出功率
process_U=zeros(hor_con*num_con,4);
process_Po=zeros(hor_con*num_con,4);
for j=1:hor_con*num_con
    for c=1:4
        process_U(j,c)=Uoc(process_soc(j,c))+3.3*process_i(j,c)*R0(process_soc(j,c))+Up(process_soc(j,c),process_i(j,c));
        process_Po(j,c)=process_U(j,c)*process_i(j,c)*3.3;
    end
end
sum_Po=sum(process_Po,2);
figure(3)
hold on
for j=1:4
    plot(process_Po(:,j));
end
plot(sum_Po)
xlabel('时间/T (T=20s)')
ylabel('输出功率/W')