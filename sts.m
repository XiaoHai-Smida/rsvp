clc
clear all
close all

load ./processed/psd_for_sub_freq.mat
[cha,sub,freq] = size(psd0_for_sub_freq);


for f = 1:freq
    for c = 1:cha
        x = psd0_for_sub_freq(c,:,f);
        y = psd1_for_sub_freq(c,:,f);
            % 离群值检测
        x = filloutliers(x,'spline','quartiles');
        y = filloutliers(y,'spline','quartiles');
        % 配对T检验
        [h(c,f),p(c,f)] = ttest(x,y);
    end    
end



% 
% for f = 1:freq
%     fdr(:,f) = mafdr(p(:,f),'BHFDR',true);
% end