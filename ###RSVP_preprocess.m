clear all；
close all;
clc;
data_path='.\New\';    %%orgin data path
save_path='.\processed\';   %%the path where to save processed data
data_con_path=strcat(data_path,'\');
File = dir(fullfile(data_con_path));
FileNames = {File.name};
len_dir=size(File);
le=len_dir(1);
%%实现数据预处理及mat格式转化
    for count=3:1:le
        file_name=strcat(data_con_path,char(FileNames(count)));
        EEG = pop_biosig(file_name);%导入数据
        EEG = eeg_checkset( EEG );
%         EEG = pop_select( EEG, 'nochannel',{'M1','M2','HEO','VEO'});%删除无用导联
%         EEG = eeg_checkset( EEG );
%         EEG = pop_reref( EEG, [31 32] ); %重参考
%         EEG = eeg_checkset( EEG );
        EEG = pop_eegfiltnew(EEG,0.5,25,13518,0,[],0);%带通滤波
        EEG = eeg_checkset( EEG );
%         EEG = pop_runica(EEG, 'extended',0,'interupt','off');%ICA去眼电伪迹
%         EEG = eeg_checkset( EEG );
        EEG = pop_rmbase(EEG, []);%去除基线漂移
        EEG = eeg_checkset( EEG );
        EEG = pop_resample( EEG,64);%降采样
        EEG = eeg_checkset( EEG );
        data_con_save_path=strcat(save_path,'\');
        new_name=replace(char(FileNames(count)),'.edf','.mat');
        save_file_name=strcat(data_con_save_path,new_name);
        save(save_file_name,'EEG');
    end

