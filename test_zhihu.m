num=1;
for attack_QF=50:5:90
    path=['C:\Users\fuqin\Desktop\pic\test_wb\test0\stego\',num2str(num),'.jpg'];
    qf=test_qf(path);
        
    
    a(num)=qf;
    num=num+1;
end
x=50:5:90;%x轴上的数据，第一个值代表数据开始，第二个值代表间隔，第三个值代表终止
plot(x,a,'or');
axis([50,90,50,100])  %确定x轴与y轴框图大小
set(gca,'XTick',[50:5:90]) %x轴范围
set(gca,'YTick',[50:5:100]) %y轴范围

%legend('Neo4j','MongoDB');   %右上角标注
xlabel('coverqf')  %x轴坐标描述
ylabel('stegoqf') %y轴坐标描述
