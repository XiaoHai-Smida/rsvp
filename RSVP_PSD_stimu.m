clc;
clear all;
close all;
path='E:\GIT\processed\averaged';
a=dir(fullfile(path,'*.mat'));
fs=256;%����Ƶ��
N=53;%��������
%%Ƶ��������Ŀ��̼����ʼ��㣨���������cell���飨22*1��Ϊ22�鱻�ԵĹ���ֵ�����д���ͨ�����д����ԴΣ���
for ii=1:length(a)
     b=load(fullfile(path,a(ii).name));
     avg1=b.avg1;
     for jj=1:size(avg1,3)
         data=avg1(:,:,jj);
         data=double(data);
         %%�˲�
         Wn1 = [0.5*2 3*2]/fs;%����ͨ��Ϊ1-3Hz
         [k1,l1] = butter(2,Wn1);
         Wn2 = [4*2 7*2]/fs;%����ͨ��Ϊ4-7Hz
         [k2,l2] = butter(2,Wn2);
         Wn3 = [8*2 13*2]/fs;%����ͨ��Ϊ8-13Hz
         [k3,l3] = butter(2,Wn3);
         Wn4 = [14*2 25*2]/fs;%����ͨ��Ϊ14-30Hz
         [k4,l4] = butter(2,Wn4);
            for i=1:8
                data1= filtfilt(k1,l1,data(i,:));%1-3Hz�˲�
                tmp1= fft(data1);
                data_delta(i,:) = ifft(tmp1);
                data2= filtfilt(k2,l2,data(i,:));%4-7Hz�˲�
                tmp2= fft(data2);
                data_theta(i,:) = ifft(tmp2);
                data3= filtfilt(k3,l3,data(i,:));%8-13Hz�˲�
                tmp3= fft(data3);
                data_alpha(i,:) = ifft(tmp3);
                data4= filtfilt(k4,l4,data(i,:));%14-25Hz�˲�
                tmp4= fft(data4);
                data_beta(i,:) = ifft(tmp4);
            end  

    %0.5-3Hz���ʼ���
    for j=1:8
          xw = data_delta(j,:).*hanning(N)';
          mag=abs(fft(xw,N));
          P1=mag.^2/N/fs;
          PSD_delta(j,:)=P1;
    end
    PSD_delta_ch= sum(PSD_delta,2);%�����Դ����е���delta����
    PSD_delta_tr(:,jj)= PSD_delta_ch;%�������������Դ�delta����
    
    clear  PSD_delta
    
    %4-8Hz���ʼ���
    for j=1:8
          xw = data_theta(j,:).*hanning(N)';
          mag=abs(fft(xw,N));
          P1=mag.^2/N/fs;
          PSD_theta(j,:)=P1;
    end
    PSD_theta_ch= sum(PSD_theta,2);%�����Դ����е���theta����
    PSD_theta_tr(:,jj)= PSD_theta_ch;%�������������Դ�theta����

    clear  PSD_theta
    
    %8-13Hz���ʼ���
    for j=1:8
          xw = data_alpha(j,:).*hanning(N)';
          mag=abs(fft(xw,N));
          P1=mag.^2/N/fs;
          PSD_alpha(j,:)=P1;
    end
    PSD_alpha_ch= sum(PSD_alpha,2);%�����Դ����е���alpha����
    PSD_alpha_tr(:,jj)= PSD_alpha_ch;%�������������Դ�alpha����
    
    clear  PSD_alpha
    
    %13-25Hz���ʼ���
    for j=1:8
          xw = data_beta(j,:).*hanning(N)';
          mag=abs(fft(xw,N));
          P1=mag.^2/N/fs;
          PSD_beta(j,:)=P1;
    end
    PSD_beta_ch=sum(PSD_beta,2);%�����Դ����е���beta����
    PSD_beta_tr(:,jj)=PSD_beta_ch;%�������������Դ�beta����
    
    clear  PSD_beta 
    clear data_delta data_theta data_alpha data_beta
     end 
    PSD_delta_sub_stimu{ii,1}= PSD_delta_tr;%�������������Դ�delta����
    PSD_theta_sub_stimu{ii,1}= PSD_theta_tr;%�������������Դ�theta����
    PSD_alpha_sub_stimu{ii,1}= PSD_alpha_tr;%�������������Դ�alpha����
    PSD_beta_sub_stimu{ii,1}=PSD_beta_tr;%�������������Դ�beta����
    clear PSD_delta_tr PSD_theta_tr PSD_alpha_tr PSD_beta_tr
end
save('E:\GIT\processed\PSD\stimu\PSD_delta_sub_stimu.mat', 'PSD_delta_sub_stimu');
save('E:\GIT\processed\PSD\stimu\PSD_theta_sub_stimu.mat', 'PSD_theta_sub_stimu');
save('E:\GIT\processed\PSD\stimu\PSD_alpha_sub_stimu.mat', 'PSD_alpha_sub_stimu');
save('E:\GIT\processed\PSD\stimu\PSD_beta_sub_stimu.mat', 'PSD_beta_sub_stimu');