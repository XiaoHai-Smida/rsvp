function [rmdata,baseLine] = rmbaseline(sig)
%	基线拟合去基线漂移
%   sig：输入信号
%	rmdata：去除基线的信号
%	baseLine：基线
    [M,N] = size(sig);
    px = 1:N;
    for i = 1:M
        py = sig(i,:);
        [p,s,mu] = polyfit(px,py,3);   %p为幂次从高到低的多项式系数向量，矩阵s用于生成预测值的误差估计
        f_x = polyval(p,px,[],mu);   	%返回对应自变量t在给定系数p的多项式的值
        rmdata(i,:) = py'-f_x';			%获得处理后的数据
        baseLine(i,:) = f_x;
    end    
end

