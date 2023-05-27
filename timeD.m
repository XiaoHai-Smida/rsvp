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
    
    %% 
    tx = 200:200/52:400;

    figure (count-2)
    for cha = 1:8
        y = avg0(cha,:,1);
        plot(tx,y,'b');
        hold on
        
        y = avg1(cha,:,1);
        plot(tx,y,'r--');
        hold on        
    end
    hold off
    
    xlim auto
    text_title = subj;
    text_title(end-3:end) = [];
    title(text_title, 'Interpreter', 'none')
    box off
    xlabel('时间(ms)')
    ylabel('幅值(μV)')
    set(gca,'FontName','Microsoft YaHei','FontWeight','bold','linewidth',1)
    
    %% 平均电极
    figure (le+count-2)
    y = mean(avg0(:,:,1));
    plot(tx,y,'b')
    hold on
    y = mean(avg1(:,:,1));
    plot(tx,y,'r--')
    
    xlim auto
    title(text_title, 'Interpreter', 'none')
    box off
    xlabel('时间(ms)')
    ylabel('幅值(μV)')
    set(gca,'FontName','Microsoft YaHei','FontWeight','bold','linewidth',1)
    
end