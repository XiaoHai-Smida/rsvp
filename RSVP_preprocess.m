clear all；
close all;
clc;
% eeglab
data_path='.\original\5-Hz\';    %%orgin data path
save_path='.\processed\';   %%the path where to save processed data
data_con_path=strcat(data_path,'\');
File = dir(fullfile(data_con_path));
FileNames = {File.name};
len_dir=size(File);
le=len_dir(1);
%%实现数据预处理及mat格式转化
    for count=3:1:le
        clear time T dat
        file_name=strcat(data_con_path,char(FileNames(count)));
        EEG = pop_biosig(file_name);%导入数据
        EEG = eeg_checkset( EEG );
        
        for i = 1:size(EEG.event,2)
            type = EEG.event(i).type;
            late = EEG.event(i).latency;
            time(i,1) = EEG.times(late);
        %     format long g
        %     time(i,1) = temp;

            if ismember('T=0',type) 
                T(i,1)=0;
            elseif ismember('T=1',type)
                   T(i,1)=1;
            else T(i,1)=-1;
            end
        end
        
        
        
        EEG = pop_select( EEG, 'rmchannel',{'Status Channel'});%删除无用导联
        EEG = eeg_checkset( EEG );
%         EEG = pop_reref( EEG, [31 32] ); %重参考
%         EEG = eeg_checkset( EEG );
        EEG = pop_eegfiltnew(EEG,0.5,25,13518,0,[],0);%带通滤波
        EEG = eeg_checkset( EEG );
%         EEG = pop_runica(EEG, 'extended',0,'interupt','off');%ICA去眼电伪迹
%         EEG = eeg_checkset( EEG );
        EEG = pop_rmbase(EEG, []);%去除基线漂移
        EEG = eeg_checkset( EEG );
        EEG = pop_resample( EEG,256);%降采样
        EEG = eeg_checkset( EEG );
        
        data_con_save_path=strcat(save_path,'\');
        
        %% T==0
        index = find(T==0);
        timeindex = time(index);
        data = EEG.data;
        for i = 1:size(timeindex,1)
            t1 = fix((timeindex(i)+200)*256/1000);
            t2 = t1+52;
            dat(:,:,i) = data(:,t1:t2);
        end        
        new_name=replace(char(FileNames(count)),'.edf','_0.mat');
        save_file_name=strcat(data_con_save_path,new_name);
        save(save_file_name,'dat');
        clear dat
        
        %% T==1
        index = find(T==1);
        timeindex = time(index);
        data = EEG.data;
        
        for i = 1:size(timeindex,1)
            t1 = fix((timeindex(i)+200)*256/1000);
            t2 = t1+52;
            dat(:,:,i) = data(:,t1:t2);
        end       

        new_name=replace(char(FileNames(count)),'.edf','_1.mat');
        save_file_name=strcat(data_con_save_path,new_name);
        save(save_file_name,'dat');
        
    end
    
    
    

