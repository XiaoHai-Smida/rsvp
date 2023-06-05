clc
clear all
close all

% load ./processed/psd_for_sub_freq.mat
% data0 = psd0_for_sub_freq;
% data1 = psd1_for_sub_freq;

load ./processed/wt_sub.mat
data0 = wt0_sub;
data1 = wt1_sub;

[cha,sub,freq] = size(data0);




for f = 1:freq
    for c = 1:cha
        x = data0(c,:,f);
        y = data1(c,:,f);
            % 离群值检测
        x = filloutliers(x,'spline','quartiles');
        y = filloutliers(y,'spline','quartiles');
        % 配对T检验
        [h(c,f),p(c,f)] = ttest(x,y);
    end    
end




% for f = 1:freq
%     fdr(:,f) = mafdr(p(:,f),'BHFDR',true);
% end