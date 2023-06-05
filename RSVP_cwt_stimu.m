clc;
clear all;
close all;
freq = 6 ;      % 5/6/10
path=['.\processed\averaged-',num2str(freq)];
a=dir(fullfile(path,'*.mat'));
fs=256;%采样频率
N=53;%采样点数

%% 时频能量：目标刺激
for ii=1:length(a)
     b=load(fullfile(path,a(ii).name));
     avg1=b.avg1;
     for jj=1:size(avg1,3)
         data=avg1(:,:,jj);
         data=double(data);
         data1=data(:,:);
    for j=1:8
          [wt,F]=cwt(data1(j,:),fs);%连续小波变换
          %hp =pcolor(1:200/53:200,F(1:65),abs(wt(1:65,:)));%画图用，忽略
          wt_avg0=mean(abs(wt(22:29,:)),2);%单个导联beta频段时域平均能量
          wt_avg1=mean(wt_avg0);%单个导联beta频段频域平均能量
          wt_avg(j,jj)=wt_avg1;
    end
    end
    cwt_beta_sub_stimu{ii,1}= wt_avg;%所有被试所有试次时频能量
    wt1_sub(:,ii) = mean(wt_avg,2);
    clear wt_avg
end 

spath =  ['.\processed\cwt\',num2str(freq),'\cwt_beta_sub_stimu.mat'];

save(spath, 'cwt_beta_sub_stimu');