clc
clear
close all

%Coded by CloudsYu87 王天宇--Wang Tianyu
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
wavenumbers = raw_data(:, 1);      % 第一列：波数
spectra = raw_data(:, 2:end);      % 第二列至最后：吸光度矩阵

% 4. Savitzky-Golay 一阶导数处理
% 参数设置 (根据文献常用的经验值)
order = 2;          % 多项式阶数 (2或3最常见)
framelen = 11;      % 窗口长度 (必须是奇数)

% sgolayfilt 对矩阵默认是按列处理的，完全符合数据结构
spectra_deriv = sgolayfilt(spectra, order, framelen, [], 1);

% 5. 可视化对比
figure('Name', '处理结果预览');
subplot(2,1,1);
plot(wavenumbers, spectra);
title('原始光谱 (Original Spectra)');
xlabel('Wavenumber (cm^{-1})'); ylabel('Absorbance');
axis tight;

subplot(2,1,2);
plot(wavenumbers, spectra_deriv);
title(['S-G 一阶导数 (Order: ', num2str(order), ', Window: ', num2str(framelen), ')']);
xlabel('Wavenumber (cm^{-1})'); ylabel('1st Derivative');
axis tight;

% 6. 保存结果
% 将波数和处理后的数据重新拼合
output_data = [wavenumbers, spectra_deriv];

% 自动生成输出文件名
[~, name, ext] = fileparts(file);
output_filename = fullfile(path, [name, '_1stDeriv', ext]);

writematrix(output_data, output_filename);
disp(['处理完成！结果已保存为: ', output_filename]);
