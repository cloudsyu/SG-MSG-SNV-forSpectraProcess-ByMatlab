# SG-MSG-SNV-forSpectraProcess-ByMatlab
使用matlab语言实现光谱预处理中的Savitzky-Golay卷积平滑法、多元散射校正MSC、标准正态化校正SNV预处理方法消除光谱噪声；
Implementing spectral noise reduction techniques in MATLAB: Savitzky-Golay Smoothing Filter, multiple scattering correction (MSC), and standard normalizing vector (SNV) correction for spectral preprocessing.
请注意待处理文件和matlab程序应在同一文件夹内；
Please note that the files to be processed and the MATLAB program should be located in the same folder.

Savitzky-Golay卷积平滑法介绍。
Brief introduction for Savitzky-Golay Smoothing Filter.
SG平滑在去除噪声的同时，能极好地保持信号的特征（如峰值的高度、宽度和形状），因此特别适合用于红外光谱（IR）、近红外光谱（NIR）和拉曼光谱等数据的降噪处理。其本质是基于最小二乘原理的多项式拟合。通俗来说，它并不是简单地计算窗口内数据的平均值，而是选取一个固定长度的窗口（通常为奇数，如 5, 7, 9...），该窗口在光谱数据上逐点滑动；然后进行多项式拟合：在当前窗口内，利用最小二乘法将窗口内的数据点拟合成一个低阶多项式（如2次或3次多项式）；再进行中心点替换：用拟合得到的多项式曲线在窗口中心点的值，替换原始数据点的值；在实际计算中，上述过程等效于对信号进行加权移动平均（卷积运算）。每一组权重要系数是固定的，取决于选定的窗口大小和多项式阶数。
SG smoothing effectively preserves signal characteristics—such as peak height, width, and shape—while removing noise, making it particularly suitable for denoising infrared (IR), near-infrared (NIR), and Raman spectroscopy data.Its essence lies in polynomial fitting based on the principle of least squares. In layman's terms, it does not simply calculate the average of data within a window. Instead, it selects a fixed-length window (typically an odd number, such as 5, 7, 9...) that slides point by point across the spectral data; Then, a polynomial fit is performed: within the current window, the data points are fitted to a low-order polynomial (e.g., quadratic or cubic) using the least squares method; followed by center point substitution: the value of the fitted polynomial curve at the window's center point replaces the original data point's value. In practice, this process is equivalent to applying a weighted moving average (convolution operation) to the signal. Each set of weight coefficients is fixed, determined by the selected window size and polynomial degree.
