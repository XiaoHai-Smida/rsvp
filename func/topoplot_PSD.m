clc;
clear all;
close all;
path1='E:\GIT\processed\PSD\stimu';
path2='E:\GIT\processed\PSD\nonstimu';

a=dir(fullfile(path1,'*.mat'));
b=dir(fullfile(path2,'*.mat'));


%% 平均
for i=1:length(a)
     a1=load(fullfile(path1,a(i).name));
     
     data_alpha=a1.PSD_alpha_sub_stimu;
     data_avg=mean(data{})
     delta_high=delta_high+data;
end
delta_high=delta_high/length(a);

for i=1:length(b)
     b1=load(fullfile(path2,b(i).name));
     data=b1.RelativePower_delta_low;
     delta_low=delta_low+data;
end
delta_low=delta_low/length(b);

%% 归一化
delta_all=[delta_1;delta_0];
delta_all_max=max(delta_all);
delta_all_min=min(delta_all);
k1=1/(delta_all_max-delta_all_min);
delta_all_nor=k1*(delta_all-delta_all_min);
delta_1_nor=delta_all_nor(1:8,1);
delta_0_nor=delta_all_nor(9:16,1);

theta_all=[theta_high;theta_low];
theta_all_max=max(theta_all);
theta_all_min=min(theta_all);
k2=1/(theta_all_max-theta_all_min);
theta_all_nor=k2*(theta_all-theta_all_min);
theta_high_nor=theta_all_nor(1:60,1);
theta_low_nor=theta_all_nor(61:120,1);



%%绘制脑电地形图
chanlocs=pop_readlocs('channel_location_64_neuroscan.locs');

subplot(3,4,1)
topoplot(delta_high_nor',chanlocs,'electrodes','on','style','both','numcontour',0,'shading','interp','conv','off','drawaxis','off' ,'maplimits', [0,1],'colormap','jet');
% colorbar
caxis([0 1])
set(gca,'fontsize',9,'FontWeight','bold');
title('delta','FontSize',17)
 
subplot(3,4,5)
topoplot(delta_low_nor',chanlocs,'electrodes','on','style','both','numcontour',0,'shading','interp','conv','off','drawaxis','off' ,'maplimits', [0,1],'colormap','jet');
% colorbar
caxis([0 1])


subplot(3,4,2) 
topoplot(theta_high_nor',chanlocs,'electrodes','on','style','both','numcontour',0,'shading','interp','conv','off','drawaxis','off' ,'maplimits', [0,1],'colormap','jet');
% colorbar
caxis([0 1])
set(gca,'fontsize',9,'FontWeight','bold');
title('theta','FontSize',17)

subplot(3,4,6)
topoplot(theta_low_nor',chanlocs,'electrodes','on','style','both','numcontour',0,'shading','interp','conv','off','drawaxis','off' ,'maplimits', [0,1],'colormap','jet');
% colorbar
caxis([0 1])


subplot(3,4,3)
topoplot(alpha_high_nor',chanlocs,'electrodes','on','style','both','numcontour',0,'shading','interp','conv','off','drawaxis','off' ,'maplimits', [0,1],'colormap','jet');
% colorbar
caxis([0 1])
set(gca,'fontsize',9,'FontWeight','bold');
title('alpha','FontSize',17)

subplot(3,4,7)
topoplot(alpha_low_nor',chanlocs,'electrodes','on','style','both','numcontour',0,'shading','interp','conv','off','drawaxis','off' ,'maplimits', [0,1],'colormap','jet');
% colorbar
caxis([0 1])


subplot(3,4,4)
topoplot(beta_high_nor',chanlocs,'electrodes','on','style','both','numcontour',0,'shading','interp','conv','off','drawaxis','off' ,'maplimits', [0,1],'colormap','jet');
% colorbar
caxis([0 1])
set(gca,'fontsize',9,'FontWeight','bold');
title('beta','FontSize',17)

subplot(3,4,8)
topoplot(beta_low_nor',chanlocs,'electrodes','on','style','both','numcontour',0,'shading','interp','conv','off','drawaxis','off' ,'maplimits', [0,1],'colormap','jet');
colorbar;
caxis([0 1])
