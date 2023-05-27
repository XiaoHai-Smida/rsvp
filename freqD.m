clc
clear all
close all

data_path='.\processed\averaged\';
data_con_path=strcat(data_path,'\');
File = dir(fullfile(data_con_path));
FileNames = {File.name};
len_dir=size(File);
le=len_dir(1);

for count = 3:1:le  %取目标
    subj = char(FileNames(count));
    file_name = strcat(data_con_path,subj);
    load(file_name);
    
    
end