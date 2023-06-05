clear all；
close all;
clc;
% eeglab
addpath .\func

data_path='.\processed\6-Hz\';   %%the path where to save processed data
save_path='.\processed\averaged-6\';
data_con_path=strcat(data_path,'\');
File = dir(fullfile(data_con_path));
FileNames = {File.name};
len_dir=size(File);
le=len_dir(1);

for count = 4:2:le  %取目标
    clear avg0 avg1
    
    file_name = strcat(data_con_path,char(FileNames(count)));
    data = importdata(file_name);
    [x,y,z] = size(data);
    % 基线漂移
    for i = 1:size(data,3)
        [temp_data(:,:,i),~] = rmbaseline(data(:,:,i));
    end
    data = temp_data;
    clear temp_data
    zz = fix(z/1); %取商    
%     zz = fix(z/10); %取商   
    for i = 1:zz
        avg1(:,:,i) = mean(data(:,:,1*(i-1)+1:1*i),3);
%         avg1(:,:,i) = mean(data(:,:,10*(i-1)+1:10*i),3);
    end
    
    %% 非目标
    nonT = count-1;
    file_name = strcat(data_con_path,char(FileNames(nonT)));
    data = importdata(file_name);
    % 基线漂移
    for i = 1:size(data,3)
        [temp_data(:,:,i),~] = rmbaseline(data(:,:,i));
    end
    data = temp_data;
    clear temp_data
    
    zz = 9*zz;
    for i = 1:zz
        avg0(:,:,i) = mean(data(:,:,1*(i-1)+1:1*i),3);
%         avg0(:,:,i) = mean(data(:,:,10*(i-1)+1:10*i),3); 
    end
    
    sFile = FileNames(count);
    sFile = sFile{1,1};
    sFile(end-5:end)=[];
    sFile_path = [save_path,sFile,'.mat'];
    
    save(sFile_path,'avg0','avg1');
    
end


