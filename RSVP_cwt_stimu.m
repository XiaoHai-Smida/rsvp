clc;
clear all;
close all;
freq = 6 ;      % 5/6/10
path=['.\processed\averaged-',num2str(freq)];
a=dir(fullfile(path,'*.mat'));
fs=256;%����Ƶ��
N=53;%��������

%% ʱƵ������Ŀ��̼�
for ii=1:length(a)
     b=load(fullfile(path,a(ii).name));
     avg1=b.avg1;
     for jj=1:size(avg1,3)
         data=avg1(:,:,jj);
         data=double(data);
         data1=data(:,:);
    for j=1:8
          [wt,F]=cwt(data1(j,:),fs);%����С���任
          %hp =pcolor(1:200/53:200,F(1:65),abs(wt(1:65,:)));%��ͼ�ã�����
          wt_avg0=mean(abs(wt(22:29,:)),2);%��������betaƵ��ʱ��ƽ������
          wt_avg1=mean(wt_avg0);%��������betaƵ��Ƶ��ƽ������
          wt_avg(j,jj)=wt_avg1;
    end
    end
    cwt_beta_sub_stimu{ii,1}= wt_avg;%���б��������Դ�ʱƵ����
    wt1_sub(:,ii) = mean(wt_avg,2);
    clear wt_avg
end 

spath =  ['.\processed\cwt\',num2str(freq),'\cwt_beta_sub_stimu.mat'];

save(spath, 'cwt_beta_sub_stimu');