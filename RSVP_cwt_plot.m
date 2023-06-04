clc;
clear all;
close all;

path='.\processed\averaged-6';%数据读取路径
a=dir(fullfile(path,'*.mat'));
fs=256;%采样频率
N=53;%采样点数

%% 时频能量
for ii=2:length(a)
     b=load(fullfile(path,a(ii).name));
     avg1=b.avg1;
     avg0=b.avg0;
     for jj=1:size(avg1,3)
         data1=avg1(:,:,jj);
         data1=double(data1);
         data1=data1([4,7],:);
         
         data0=avg0(:,:,jj);
         data0=double(data0);
         data0=data0([4,7],:);
         figure
         
    subplot 121
    for j=1
          [wt,F]=wsst(data1(j,:),fs);%连续小波变换
          hp =pcolor(1:200/53:200,F(1:65),abs(wt(1:65,:)));%画图用，忽略
          title('时频能量分布-目标刺激')
          xlabel('Time/ms')
          ylabel('Frequecy/Hz')

    end
    subplot 122
        for i=1
          [wt,F]=wsst(data0(i,:),fs);%连续小波变换
          hp =pcolor(1:200/53:200,F(1:65),abs(wt(1:65,:)));%画图用，忽略
          title('时频能量分布-非目标刺激')
          xlabel('Time/ms')
          ylabel('Frequecy/Hz')

    end
     end

end 

