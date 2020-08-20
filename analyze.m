%分析及绘图
for k=1:10
%[im(:,:,k),fm(k)] = PSO(@fitness,50,1.5,2.5,0.5,100,num);
[fm(k),Eloss(k)]=fitnesse(im(:,:,k));
end
subplot(2,1,1);
plot(fm,'x')
xlabel('实验次数');
ylabel('目标函数')
subplot(2,1,2);
plot(Eloss,'x')
xlabel('实验次数');
ylabel('能量损耗/J')
figure
plot(2:100,Pbest(2:100,3))
xlabel('迭代次数');
ylabel('目标函数')