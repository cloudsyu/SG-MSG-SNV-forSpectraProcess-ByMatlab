clc
clear
close all

%Coded by CloudsYu87 王天宇-Wang Tianyu
%School of Civil Engineering, Southwest Jiaotong University (SWJTU)  
%+86-19173163751 
%cloudsyu87@qq.com ; cloudsyu87@swjtu.edu.cn

% 1. 交互式选择文件
[file, path] = uigetfile('*.csv', '请选择你的红外光谱CSV数据文件');
if isequal(file, 0)
    disp('用户取消了操作');
    return;
else
    fullpath = fullfile(path, file);
    disp(['正在处理文件: ', file, ' ...']);
end

% 2. 读取数据
% 假设第一行没有表头，如果有表头，readmatrix 会自动处理或变成 NaN
raw_data = readmatrix(fullpath); 

% 检查是否有 NaN (通常因为表头导致)，如果有则去除第一行
if any(isnan(raw_data(1,:)))
    raw_data(1,:) = [];
end
% 3. 数据拆分
wavenumbers = raw_data(:, 1);      % 波数
spectra = raw_data(:, 2:end);      % 吸光度矩阵 (行=波数点, 列=样本)

% 4. MSC 多元散射校正处理
% 4.1 计算平均光谱 (作为参考标准)
mean_spectrum = mean(spectra, 2); 

% 4.2 初始化一个空矩阵存放校正后的数据
[n_points, n_samples] = size(spectra);
spectra_msc = zeros(n_points, n_samples);

% 4.3 循环处理每一个样本
for i = 1:n_samples
    sample = spectra(:, i); % 取出第 i 个样本
    
    % 线性拟合: 样本 = p(1)*平均光谱 + p(2)
    p = polyfit(mean_spectrum, sample, 1); 
    slope = p(1);     % 斜率
    intercept = p(2); % 截距
    
    % 进行校正: (样本 - 截距) / 斜率
    spectra_msc(:, i) = (sample - intercept) / slope;
end

% 5. 可视化对比
figure('Name', 'MSC 处理前后对比');
subplot(2,1,1);
plot(wavenumbers, spectra);
title('原始光谱 (Original)');
xlabel('Wavenumber (cm^{-1})'); ylabel('Absorbance');
axis tight;

subplot(2,1,2);
plot(wavenumbers, spectra_msc);
title('MSC 校正后光谱 (MSC Corrected)');
xlabel('Wavenumber (cm^{-1})'); ylabel('Absorbance');
axis tight;

