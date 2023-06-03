clc;
clear all;
close all;
path1='.\processed\PSD\stimu';
path2='.\processed\PSD\nonstimu';

a=dir(fullfile(path1,'*.mat'));
b=dir(fullfile(path2,'*.mat'));
subj = 18;                                              %09号数据存在异常，需手动删除09a/b

%% 平均
for i=1:length(a)
    data_name = a(i).name;
    data_name(end-3:end)=[];
    data = load(fullfile(path1,a(i).name));
    eval(['data = ','data.',data_name,';']);
     
    for s = 1:subj
        psd_for_sub(:,s) = mean(data{s,1},2);           %平均试次得到每个人8个channel的psd
    end
    psd1_for_sub_freq(:,:,i) = psd_for_sub;
    psd_for_cha = mean(psd_for_sub,2);                  %平均被试，得到每个channel的psd
    clear psd_for_sub

    psd1_for_freqband(:,i) = psd_for_cha;               %存储4个频段各电极的psd
end


for i=1:length(b)
    data_name = b(i).name;
    data_name(end-3:end)=[];
    data = load(fullfile(path2,b(i).name));
    eval(['data = ','data.',data_name,';']);

    for s = 1:subj
        psd_for_sub(:,s) = mean(data{s,1},2);           %平均试次得到每个人8个channel的psd
    end
    psd0_for_sub_freq(:,:,i) = psd_for_sub;             %用于统计分析，三维：（cha，subj，freq_band）
    
    psd_for_cha = mean(psd_for_sub,2);                  %平均被试，得到每个channel的psd
    clear psd_for_sub
                
    psd0_for_freqband(:,i) = psd_for_cha;               %存储4个频段各电极的psd
end


%% 归一化 为了画图好看
for i = 1:4
    all_psd = [psd1_for_freqband(:,i);psd0_for_freqband(:,i)];
    all_max = max(all_psd);
    all_min = min(all_psd);
    k = 1/(all_max-all_min);
    all_nor = k*(all_psd-all_min);
    nor_psd1(:,i) = all_nor(1:8);
    nor_psd0(:,i) = all_nor(9:16);
end

%% 更改顺序  [alpha beta delta theta] --> [delta theta alpha beta]
nor_psd1 = nor_psd1(:,[3 4 1 2]);
nor_psd0 = nor_psd0(:,[3 4 1 2]);

psd0_for_sub_freq = psd0_for_sub_freq(:,:,[3 4 1 2]);
psd1_for_sub_freq = psd1_for_sub_freq(:,:,[3 4 1 2]);

% save('.\processed\psd_for_sub_freq.mat','psd0_for_sub_freq','psd1_for_sub_freq');

%% 绘制脑电地形图
chanlocs=pop_readlocs('channel_location_64_neuroscan.locs');
% 通道 [57 51 50 42 58 60 53 55]
cha_index = [57 51 50 42 58 60 53 55];
psd_all0 = zeros(64,4);
psd_all1 = psd_all0;
psd_all0(cha_index,:) = nor_psd0;
psd_all1(cha_index,:) = nor_psd1;
Text = ['δ','θ','α','β'];

figure
for i=1:4
    subplot(2,4,i)
    topoplot(psd_all1(:,i)',chanlocs,'electrodes','on','style','both','numcontour',0,'shading','interp','conv','off','drawaxis','off' ,'maplimits', [0,1],'colormap','jet');
    % colorbar
    caxis([0 1])
    set(gca,'fontsize',9,'FontWeight','bold');
    title([Text(i),'-目标'],'FontSize',17)
    
    subplot(2,4,i+4)
    topoplot(psd_all0(:,i)',chanlocs,'electrodes','on','style','both','numcontour',0,'shading','interp','conv','off','drawaxis','off' ,'maplimits', [0,1],'colormap','jet');
    % colorbar
    caxis([0 1])
    set(gca,'fontsize',9,'FontWeight','bold');
    title([Text(i),'-非目标'],'FontSize',17)
end
colorbar
