% SVM 分类器
clc
clear
close all

load('D:\GIT\processed\PSD\nonstimu\PSD_beta_sub_nonstimu.mat')
load('D:\GIT\processed\PSD\stimu\PSD_beta_sub_stimu.mat')

%% 提取数据
target = PSD_beta_sub_stimu;
ntarget = PSD_beta_sub_nonstimu;
cha = 1;


T = 1; NT = 1;  % 初始化

subj = size(target,1);

for s = 1:subj
    temp = target{s,1}(cha,:)';
    T = [T;temp];
    
    temp = ntarget{s,1}(cha,:)';
    NT = [NT;temp];
end

T(1) = [];
NT(1) = [];

X = [T; NT];% 所有特征
Y = [ones(size(T,1),1);zeros(size(NT,1),1)];% 特征对应的目标【数字形式】

t = templateSVM('kernelfunction','linear','standardize',true); % 设置SVM分类器参数
ClassNames = {'Target', 'Notarget'};% 分类

% 特征对应的目标【标签形式】
for i = 1:size(Y,1)
    if Y(i) == 1
        Ylabel{i,1} = ClassNames{1};
    else Ylabel{i,1} = ClassNames{2};
    end
end

%% 
% train_index = [1:30,(35+1):(350-35)]; % 用于训练的编号
% test_index = [31:35,(350-35+1):350];
% 
% Xtrain = X(train_index,1);
% Ytrain = Ylabel(train_index,1);
% Xtest = X(test_index,1);
% Ytest = Ylabel(test_index,1);
% 
% Mdltrain = fitcecoc(Xtrain,Ytrain,'Learners',t,'ClassNames',ClassNames,'verbose',0); 
% predictedY = predict(Mdltrain,Xtest);
% 
% error_test = sum(~strcmp(predictedY,Ytest));

%% 7折留一
group = 1:7;
error_test = 0;
for i = 1:50
    Index((i-1)*7+1:i*7,1) = group';
end
opts = struct('Optimizer','bayesopt', 'ShowPlots',true);
for g = 1:7
    
    % 设置训练集和验证集
    Xtrain = X(Index~=g,1);
    Ytrain = Ylabel(Index~=g,1);
    Xtest = X(Index==g,1);
    Ytest = Ylabel(Index==g,1);

    %% 方法1
%     Mdltrain = fitcecoc(Xtrain,Ytrain,'Learners',t,'ClassNames',ClassNames,'verbose',0); 
%     predictedY = predict(Mdltrain,Xtest);
%     error_test = error_test + sum(~strcmp(predictedY,Ytest));

    %% 方法2
    % 训练 SVM 模型
    
    svmModel = fitcsvm(Xtrain,Ytrain, 'OptimizeHyperparameters', 'auto', ...
    'HyperparameterOptimizationOptions', opts, ...
    'KernelFunction', 'RBF', 'KernelScale', 'auto', ...
    'Standardize', true, 'ClassNames', ClassNames, ...
    'BoxConstraint', 1, 'CacheSize', 'maximal');
    predictedY = predict(svmModel,Xtest);
    C = confusionmat(Ytest,predictedY);
    accuracy(g) = sum(diag(C))/sum(C(:));
    

end

%% 方法1的准确度
na = size(X,1);
error_test = error_test / na;
accuracy_test = 1 - error_test;
