error_rate=[];
wet_rate=[];
for attack_QF=70:10:100
    error_rate_temp=[];
    wet_rate_temp=[];
    for payload=0.1:0.1:0.5
        [temp1,temp2]=Test_QMAS('C:\Users\fuqin\Desktop\pic\cover','C:\Users\fuqin\Desktop\pic\stego',payload,70,attack_QF);
        temp=[error_rate_temp,temp1];
        error_rate_temp=temp;
        temp=[wet_rate_temp,temp2];
        wet_rate_temp=temp;
    end
    error_rate(attack_QF/10-6,:)=error_rate_temp;
    wet_rate(attack_QF/10-6,:)=wet_rate_temp;
end
x=0.1:0.1:0.5;%x轴上的数据，第一个值代表数据开始，第二个值代表间隔，第三个值代表终止
 plot(x,error_rate(1,:),'-or',x,error_rate(2,:),'-og',x,error_rate(3,:),'-ob',x,error_rate(4,:),'-oc');
axis([0,0.6,0,0.1])  %确定x轴与y轴框图大小
set(gca,'XTick',[0:0.1:0.6]) %x轴范围1-6，间隔1
set(gca,'YTick',[0:0.01:0.3]) %y轴范围0-700，间隔100
legend('attack QF=70','attack QF=80','attack QF=90','attack QF=100');
%legend('Neo4j','MongoDB');   %右上角标注
xlabel('payload')  %x轴坐标描述
ylabel('error_rate') %y轴坐标描述
