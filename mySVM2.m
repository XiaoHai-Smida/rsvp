% SVM 分类器
clc
clear
close all

folder = {'5';'6';'10'};

X = [];
Y = [];
for i = 1:3
    
    datapath = ['.\processed\cwt\',folder{i,1},'\cwt_beta_sub_stimu.mat'];
    load(datapath)
    datapath = ['.\processed\cwt\',folder{i,1},'\cwt_beta_sub_nonstimu.mat'];
    load(datapath)

    %% 提取数据
    target = cwt_beta_sub_stimu;
    ntarget = cwt_beta_sub_nonstimu;

    T = []; NT = [];  % 初始化

    subj = size(target,1);

    for s = 1:subj
        temp = target{s,1}';
        T = [T;temp];

        temp = ntarget{s,1}';
        NT = [NT;temp];
    end


    
    X = [X; T; NT];% 所有特征
    Y = [Y; ones(size(T,1),1); zeros(size(NT,1),1)];% 特征对应的目标【数字形式】
end



%% 降采样
% 假设训练数据矩阵为 X，训练数据标签向量为 Y
% 使用 datasample 函数进行欠采样和随机采样
X_undersampled = [];
Y_undersampled = [];
class1_idx = find(Y == 1);
class0_idx = find(Y == 0);

% 生成不重复的随机整数序列
n = length(class0_idx);
k = length(class1_idx);
rand_int = unique(randperm(n, k)); % 随机生成k个数，范围为1~n

idx0 = class0_idx(rand_int);
idx1 = class1_idx;

X = X([idx0;idx1],:);
Y = Y([idx0;idx1],:);

rand_int = unique(randperm(114, 25));   % 找25个目标和非目标作为test
group = zeros(114*2,1);

group([rand_int,rand_int+114]) = 1;


%%

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

%% 10折留一
% group = 1:10;
% error_test = 0;
% for i = 1:114
%     Index((i-1)*10+1:i*10,1) = group';
% end
opts = struct('Optimizer','bayesopt', 'ShowPlots',true);


    % 设置训练集和验证集
Xtrain = X(find(group~=1),:);
Ytrain = Ylabel(find(group~=1),:);

Xtest = X(find(group==1),:);
Ytest = Ylabel(find(group==1),:);

%     Xtrain = Xtrain(1:60,:);
%     Ytrain = Ytrain(1:60,:);
%     Xtest = Xtest(1:10,:);
%     Ytest = Ytest(1:10,:);
    

    %% 方法1
%     Mdltrain = fitcecoc(Xtrain,Ytrain,'Learners',t,'ClassNames',ClassNames,'verbose',0); 
%     predictedY = predict(Mdltrain,Xtest);
%     error_test = error_test + sum(~strcmp(predictedY,Ytest));

    %% 方法2
    % 训练 SVM 模型
    
svmModel = fitcsvm(Xtrain,Ytrain, 'OptimizeHyperparameters', 'auto', ...
'HyperparameterOptimizationOptions', opts, ...
'KernelFunction', 'polynomial', 'KernelScale', 'auto', ...
'Standardize', true, 'ClassNames', ClassNames, ...
 'CacheSize', 'maximal');
predictedY = predict(svmModel,Xtest);
C = confusionmat(Ytest,predictedY);
accuracy = sum(diag(C))/sum(C(:));


precision = C(1,1) / (C(1,1) + C(2,1));
recall = C(1,1) / (C(1,1) + C(1,2));
F1_score = 2 * precision * recall / (precision + recall);
    


%% 方法1的准确度
% na = size(X,1);
% error_test = error_test / na;
% accuracy_test = 1 - error_test;

fprintf('---\n Precision: %2.2f%% \n Recall: %2.2f%% \n F1 score: %1.4f \n---\n',...
    precision*100,recall*100,F1_score);
