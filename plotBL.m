%{
基线漂移展示
%}


    tx = 200:200/52:400;
    figure
    subplot 211
    plot(tx,dat(1,:,1),'LineWidth',0.7)
    box off
    xlabel('时间(ms)')
    ylabel('幅值(μV)')
    title('原信号')
    set(gca,'FontName','Microsoft YaHei','FontWeight','bold','linewidth',1)
    
%     hold on
%     [data2,bl] = rmbaseline(dat(1,:,1));             %已处理基线漂移
%     plot(tx,bl,'LineWidth',0.7)
    
    
    
    subplot 212
    plot(tx,data2,'LineWidth',0.7)
    box off
    
%     hold on
%     [data3,bl] = rmbaseline(data2);
%     plot(tx,bl,'LineWidth',0.7)
    xlabel('时间(ms)')
    ylabel('幅值(μV)')
    title('去基线漂移后的信号')
    set(gca,'FontName','Microsoft YaHei','FontWeight','bold','linewidth',1)
    
    
    function [rmdata,baseLine] = rmbaseline(sig)
%	基线拟合去基线漂移
%   sig：输入信号
%	rmdata：去除基线的信号
%	baseLine：基线
    [M,N] = size(sig);
    px = 1:N;
    for i = 1:M
        py = sig(i,:);
        [p,s,mu] = polyfit(px,py,5);   %p为幂次从高到低的多项式系数向量，矩阵s用于生成预测值的误差估计
        f_x = polyval(p,px,[],mu);   	%返回对应自变量t在给定系数p的多项式的值
        rmdata(i,:) = py'-f_x';			%获得处理后的数据
        baseLine(i,:) = f_x;
    end    
end





