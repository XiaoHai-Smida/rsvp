% SVM 分类器
% 数据不做叠加平均。

clc
clear
close all

load('.\processed\cwt\6\cwt_beta_sub_stimu.mat')
load('.\processed\cwt\6\cwt_beta_sub_nonstimu.mat')

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

X = [T; NT];% 所有特征
Y = [ones(size(T,1),1);zeros(size(NT,1),1)];% 特征对应的目标【数字形式】

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

rand_int = unique(randperm(300, 75));   % 找25个目标和非目标作为test
group = zeros(75*2,1);

start1 = min(find(Y==1));   % 标签1开始标志
group([rand_int,rand_int+start1]) = 1;


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
'KernelFunction', 'linear', 'KernelScale', 'auto', ...
'Standardize', true, 'ClassNames', ClassNames, ...
 'CacheSize', 'maximal');
% 使用 Sigmoid 核函数进行 SVM 二分类
% svmModel = fitcsvm(Xtrain, Ytrain, 'KernelFunction', 'sigmoid', 'BoxConstraint', 1, 'KernelScale', 0.1);
% 使用多项式核函数进行 SVM 二分类


% for i = 10:20
%     fprintf('\n#### PolynomialOrder=%d ####\n',i)
% svmModel = fitcsvm(Xtrain, Ytrain, 'KernelFunction', 'polynomial', 'PolynomialOrder', i);

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

% end