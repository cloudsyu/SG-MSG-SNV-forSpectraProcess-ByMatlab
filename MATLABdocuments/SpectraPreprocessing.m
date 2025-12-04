clc
clear
close all

%按顺序进行SG、MSC、SNV预处理

%Coded by CloudsYu87 王天宇-Wang Tianyu
%School of Civil Engineering, Southwest Jiaotong University (SWJTU)  
%+86-19173163751 
%cloudsyu87@qq.com ; cloudsyu87@swjtu.edu.cn

%% 1. 数据导入
[file, path] = uigetfile('*.csv', '请选择你的红外光谱CSV数据文件');
if isequal(file, 0)
    disp('用户取消了操作');
    return;
else
    fullpath = fullfile(path, file);
    disp(['正在读取文件: ', file, ' ...']);
end

raw_data = readmatrix(fullpath);
% 检查并去除可能存在的含NaN表头
if any(isnan(raw_data(1,:)))
    raw_data(1,:) = [];
end

wavenumbers = raw_data(:, 1);      % 波数 (X轴)
spectra_raw = raw_data(:, 2:end);  % 原始吸光度矩阵
[n_points, n_samples] = size(spectra_raw);

%% 2. 第一步：Savitzky-Golay (SG) 卷积平滑
% 作用：去除随机噪声，保留峰形
% 参数：2阶多项式，11点窗口
sg_order = 2;
sg_frame = 11;
spectra_sg = sgolayfilt(spectra_raw, sg_order, sg_frame, [], 1); 
disp('Step 1: SG 平滑处理完成');

%% 3. 第二步：多元散射校正 (MSC)
% 作用：消除基线平移和乘性散射误差
spectra_msc = zeros(n_points, n_samples);
mean_spectrum = mean(spectra_sg, 2); % 计算参考光谱(均值)

for i = 1:n_samples
    x = mean_spectrum;
    y = spectra_sg(:, i);
    
    % 线性回归: y = kx + b
    p = polyfit(x, y, 1);
    k = p(1); % 斜率
    b = p(2); % 截距
    
    % MSC校正公式: (y - b) / k
    spectra_msc(:, i) = (y - b) / k;
end

disp('Step 2: MSC 散射校正完成');

%% 4. 第三步：标准正态化 (SNV)
% 作用：对每个样本进行标准化 (均值0，标准差1)
% 基于 MSC 的结果继续处理
mean_msc = mean(spectra_msc, 1); % 按列求均值
std_msc = std(spectra_msc, 0, 1); % 按列求标准差

% SNV计算。也可以直接用zscore函数运算，更加直接
spectra_final = (spectra_msc - mean_msc) ./ std_msc;

disp('Step 3: SNV 标准化完成 (预处理结束)');

%% 5. 结果可视化

% 创建一个大图窗口显示过程
figure('Name', '数据处理全流程', 'Units', 'normalized', 'Position', [0.1 0.1 0.8 0.8]);

% 子图1: 原始光谱
subplot(2,2,1);
plot(wavenumbers, spectra_raw);
title('1. 原始光谱 (Raw)');
xlabel('Wavenumber'); axis tight;

% 子图2: SG平滑后
subplot(2,2,2);
plot(wavenumbers, spectra_sg);
title(['2. SG 平滑 (Window: ' num2str(sg_frame) ')']);
xlabel('Wavenumber'); axis tight;

% 子图3: MSC校正后
subplot(2,2,3);
plot(wavenumbers, spectra_msc);
title('3. MSC 校正后');
xlabel('Wavenumber'); axis tight;

% 子图4: 最终 SNV (输入PCA的数据)
subplot(2,2,4);
plot(wavenumbers, spectra_final);
title('4. 最终 SNV 处理结果');
xlabel('Wavenumber'); axis tight;

%% 6. 保存最终的得分数据
% 保存最终处理后的光谱数据 (SG+MSC+SNV)
% 将波数和处理后的光谱拼合: [波数列, 光谱矩阵]
processed_data = [wavenumbers, spectra_final];
[~, name, ext] = fileparts(file);
spectra_filename = fullfile(path, [name, '_Processed_Spectra.csv']);
writematrix(processed_data, spectra_filename);
disp(['最终处理光谱已保存: ', spectra_filename]);


disp('所有任务执行完毕！');
