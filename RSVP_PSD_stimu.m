clc;
clear all;
close all;
path='E:\GIT\processed\averaged';
a=dir(fullfile(path,'*.mat'));
fs=256;%采样频率
N=53;%采样点数
%%频域特征：目标刺激功率计算（结果产生的cell数组（22*1）为22组被试的功率值矩阵（行代表通道，列代表试次））
for ii=1:length(a)
     b=load(fullfile(path,a(ii).name));
     avg1=b.avg1;
     for jj=1:size(avg1,3)
         data=avg1(:,:,jj);
         data=double(data);
         %%滤波
         Wn1 = [0.5*2 3*2]/fs;%设置通带为1-3Hz
         [k1,l1] = butter(2,Wn1);
         Wn2 = [4*2 7*2]/fs;%设置通带为4-7Hz
         [k2,l2] = butter(2,Wn2);
         Wn3 = [8*2 13*2]/fs;%设置通带为8-13Hz
         [k3,l3] = butter(2,Wn3);
         Wn4 = [14*2 25*2]/fs;%设置通带为14-30Hz
         [k4,l4] = butter(2,Wn4);
            for i=1:8
                data1= filtfilt(k1,l1,data(i,:));%1-3Hz滤波
                tmp1= fft(data1);
                data_delta(i,:) = ifft(tmp1);
                data2= filtfilt(k2,l2,data(i,:));%4-7Hz滤波
                tmp2= fft(data2);
                data_theta(i,:) = ifft(tmp2);
                data3= filtfilt(k3,l3,data(i,:));%8-13Hz滤波
                tmp3= fft(data3);
                data_alpha(i,:) = ifft(tmp3);
                data4= filtfilt(k4,l4,data(i,:));%14-25Hz滤波
                tmp4= fft(data4);
                data_beta(i,:) = ifft(tmp4);
            end  

    %0.5-3Hz功率计算
    for j=1:8
          xw = data_delta(j,:).*hanning(N)';
          mag=abs(fft(xw,N));
          P1=mag.^2/N/fs;
          PSD_delta(j,:)=P1;
    end
    PSD_delta_ch= sum(PSD_delta,2);%单个试次所有导联delta功率
    PSD_delta_tr(:,jj)= PSD_delta_ch;%单个被试所有试次delta功率
    
    clear  PSD_delta
    
    %4-8Hz功率计算
    for j=1:8
          xw = data_theta(j,:).*hanning(N)';
          mag=abs(fft(xw,N));
          P1=mag.^2/N/fs;
          PSD_theta(j,:)=P1;
    end
    PSD_theta_ch= sum(PSD_theta,2);%单个试次所有导联theta功率
    PSD_theta_tr(:,jj)= PSD_theta_ch;%单个被试所有试次theta功率

    clear  PSD_theta
    
    %8-13Hz功率计算
    for j=1:8
          xw = data_alpha(j,:).*hanning(N)';
          mag=abs(fft(xw,N));
          P1=mag.^2/N/fs;
          PSD_alpha(j,:)=P1;
    end
    PSD_alpha_ch= sum(PSD_alpha,2);%单个试次所有导联alpha功率
    PSD_alpha_tr(:,jj)= PSD_alpha_ch;%单个被试所有试次alpha功率
    
    clear  PSD_alpha
    
    %13-25Hz功率计算
    for j=1:8
          xw = data_beta(j,:).*hanning(N)';
          mag=abs(fft(xw,N));
          P1=mag.^2/N/fs;
          PSD_beta(j,:)=P1;
    end
    PSD_beta_ch=sum(PSD_beta,2);%单个试次所有导联beta功率
    PSD_beta_tr(:,jj)=PSD_beta_ch;%单个被试所有试次beta功率
    
    clear  PSD_beta 
    clear data_delta data_theta data_alpha data_beta
     end 
    PSD_delta_sub_stimu{ii,1}= PSD_delta_tr;%单个被试所有试次delta功率
    PSD_theta_sub_stimu{ii,1}= PSD_theta_tr;%单个被试所有试次theta功率
    PSD_alpha_sub_stimu{ii,1}= PSD_alpha_tr;%单个被试所有试次alpha功率
    PSD_beta_sub_stimu{ii,1}=PSD_beta_tr;%单个被试所有试次beta功率
    clear PSD_delta_tr PSD_theta_tr PSD_alpha_tr PSD_beta_tr
end
save('E:\GIT\processed\PSD\stimu\PSD_delta_sub_stimu.mat', 'PSD_delta_sub_stimu');
save('E:\GIT\processed\PSD\stimu\PSD_theta_sub_stimu.mat', 'PSD_theta_sub_stimu');
save('E:\GIT\processed\PSD\stimu\PSD_alpha_sub_stimu.mat', 'PSD_alpha_sub_stimu');
save('E:\GIT\processed\PSD\stimu\PSD_beta_sub_stimu.mat', 'PSD_beta_sub_stimu');