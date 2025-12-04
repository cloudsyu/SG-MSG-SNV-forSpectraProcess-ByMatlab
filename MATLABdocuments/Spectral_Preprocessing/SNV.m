clc
clear
close all

%Coded by CloudsYu87 王天宇-Wang Tianyu
%School of Civil Engineering, Southwest Jiaotong University (SWJTU)  
%+86-19173163751 
%cloudsyu87@qq.com ; cloudsyu87@swjtu.edu.cn

% 1. 交互式选择文件;Interactive File Selection
[file, path] = uigetfile('*.csv', '请选择你的红外光谱CSV数据文件');
if isequal(file, 0)
    disp('用户取消了操作');
    return;
else
    fullpath = fullfile(path, file);
    disp(['正在处理文件: ', file, ' ...']);
end

% 2. 读取数据;Read Data
raw_data = readmatrix(fullpath);
if any(isnan(raw_data(1,:)))
    raw_data(1,:) = [];
end

% 3. 数据拆分;Data Splitting
wavenumbers = raw_data(:, 1);      % 第一列：波数
spectra = raw_data(:, 2:end);      % 第二列至最后：吸光度矩阵

% 4. SNV 标准正态变量变换处理;Standard Normal Variate transformation
% 计算每个样本(每列)的平均值
mean_spectra = mean(spectra, 1);

% 计算每个样本(每列)的标准差
% std(数据, 权重, 维度)，0代表无偏估计，1代表沿列计算
std_spectra = std(spectra, 0, 1);

% 执行 SNV 公式: (x - mean) / std
% 利用 MATLAB 的隐式扩展功能，直接运算，无需循环
spectra_snv = (spectra - mean_spectra) ./ std_spectra;

% 5. 可视化对比;Visual Comparison
figure('Name', 'SNV 处理前后对比');
subplot(2,1,1);
plot(wavenumbers, spectra);
title('原始光谱 (Original)');
xlabel('Wavenumber (cm^{-1})'); ylabel('Absorbance');
axis tight;

subplot(2,1,2);
plot(wavenumbers, spectra_snv);
title('SNV 校正后光谱 (SNV Corrected)');
xlabel('Wavenumber (cm^{-1})'); ylabel('Standardized Intensity'); % 注意单位变化
axis tight;

% 6. 保存结果;Saving Results
output_data = [wavenumbers, spectra_snv];
[~, name, ext] = fileparts(file);
output_filename = fullfile(path, [name, '_SNV', ext]);

writematrix(output_data, output_filename);

disp(['处理完成！结果已保存为: ', output_filename]);

