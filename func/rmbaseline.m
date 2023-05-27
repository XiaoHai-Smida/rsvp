function [rmdata,baseLine] = rmbaseline(sig)
%	�������ȥ����Ư��
%   sig�������ź�
%	rmdata��ȥ�����ߵ��ź�
%	baseLine������
    [M,N] = size(sig);
    px = 1:N;
    for i = 1:M
        py = sig(i,:);
        [p,s,mu] = polyfit(px,py,3);   %pΪ�ݴδӸߵ��͵Ķ���ʽϵ������������s��������Ԥ��ֵ��������
        f_x = polyval(p,px,[],mu);   	%���ض�Ӧ�Ա���t�ڸ���ϵ��p�Ķ���ʽ��ֵ
        rmdata(i,:) = py'-f_x';			%��ô���������
        baseLine(i,:) = f_x;
    end    
end

