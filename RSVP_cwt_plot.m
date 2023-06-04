clc;
clear all;
close all;

path='.\processed\averaged-6';%���ݶ�ȡ·��
a=dir(fullfile(path,'*.mat'));
fs=256;%����Ƶ��
N=53;%��������

%% ʱƵ����
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
          [wt,F]=wsst(data1(j,:),fs);%����С���任
          hp =pcolor(1:200/53:200,F(1:65),abs(wt(1:65,:)));%��ͼ�ã�����
          title('ʱƵ�����ֲ�-Ŀ��̼�')
          xlabel('Time/ms')
          ylabel('Frequecy/Hz')

    end
    subplot 122
        for i=1
          [wt,F]=wsst(data0(i,:),fs);%����С���任
          hp =pcolor(1:200/53:200,F(1:65),abs(wt(1:65,:)));%��ͼ�ã�����
          title('ʱƵ�����ֲ�-��Ŀ��̼�')
          xlabel('Time/ms')
          ylabel('Frequecy/Hz')

    end
     end

end 

