# SG-MSG-SNV-forSpectraProcess-ByMatlab
使用matlab语言实现光谱预处理中的Savitzky-Golay卷积平滑法、多元散射校正MSC、标准正态化校正SNV预处理方法消除光谱噪声（交互式）；

请注意待处理文件和matlab程序应在同一文件夹内；

	Savitzky-Golay卷积平滑法介绍:SG平滑在去除噪声的同时，能极好地保持信号的特征（如峰值的高度、宽度和形状），因此特别适合用于红外光谱（IR）、近红外光谱（NIR）和拉曼光谱等数据的降噪处理。其本质是基于最小二乘原理的多项式拟合。通俗来说，它并不是简单地计算窗口内数据的平均值，而是选取一个固定长度的窗口（通常为奇数，如 5, 7, 9...），该窗口在光谱数据上逐点滑动；然后进行多项式拟合：在当前窗口内，利用最小二乘法将窗口内的数据点拟合成一个低阶多项式（如2次或3次多项式）；再进行中心点替换：用拟合得到的多项式曲线在窗口中心点的值，替换原始数据点的值；在实际计算中，上述过程等效于对信号进行加权移动平均（卷积运算）。每一组权重要系数是固定的，取决于选定的窗口大小和多项式阶数。

SG 平滑最大的优势在于：
保留峰形;SG 算法不仅可以用于平滑（去噪），还可以直接用于计算光谱的一阶导数和二阶导数（即 SG 导数），这在光谱预处理中非常重要。

在 MATLAB 中，SG 平滑可以通过内置函数 sgolayfilt 非常方便地实现。

多元散射校正（Multivariate Scatter Correction, MSC）是专门为了消除由于样品物理性质（如颗粒大小分布、装填密度、表面粗糙度）导致的光散射影响而设计的。

在固体样品的漫反射光谱（如沥青、粉末、土壤等）采集过程中，光不仅会被样品吸收（化学信息），还会发生散射（物理信息）。散射会造成光谱出现两种主要的干扰：

加性效应（Additive Effect）：导致光谱基线的平移（整体向上或向下）。

乘性效应（Multiplicative Effect）：导致光谱的灵敏度变化（光程长度改变，光谱整体被拉伸或压缩）。

MSC 的目的就是将光谱中的“物理散射信息”和“化学吸收信息”分离，修正基线平移和线性倾斜，使光谱的差异主要来源于化学成分（如沥青中官能团的含量），而不是样品的物理状态。

SNV 的算法非常直观，它基于标准正态分布的统计学原理，对每一条光谱（即每一个样本）单独进行标准化处理。

它的处理过程包含两步：

中心化（Centering）：校正基线平移（加性误差）

缩放（Scaling）：校正光程差异或散射带来的强度变化（乘性误差）


Implementing spectral noise reduction techniques in MATLAB: Savitzky-Golay Smoothing Filter, multiple scattering correction (MSC), and standard normalizing vector (SNV) correction for spectral preprocessing.

Please note that the files to be processed and the MATLAB program should be located in the same folder.

	Brief introduction for Savitzky-Golay Smoothing Filter: SG smoothing effectively preserves signal characteristics—such as peak height, width, and shape—while removing noise, making it particularly suitable for denoising infrared (IR), near-infrared (NIR), and Raman spectroscopy data.Its essence lies in polynomial fitting based on the principle of least squares. In layman's terms, it does not simply calculate the average of data within a window. Instead, it selects a fixed-length window (typically an odd number, such as 5, 7, 9...) that slides point by point across the spectral data; Then, a polynomial fit is performed: within the current window, the data points are fitted to a low-order polynomial (e.g., quadratic or cubic) using the least squares method; followed by center point substitution: the value of the fitted polynomial curve at the window's center point replaces the original data point's value. In practice, this process is equivalent to applying a weighted moving average (convolution operation) to the signal. Each set of weight coefficients is fixed, determined by the selected window size and polynomial degree.
The primary advantage of SG smoothing lies in:
Preserving peak shapes; the SG algorithm can be used not only for smoothing (denoising) but also directly for calculating the first and second derivatives of the spectrum (i.e., SG derivatives), which is crucial in spectral preprocessing.

In MATLAB, SG smoothing can be conveniently implemented using the built-in function `sgolayfilt`.

Multivariate Scatter Correction (MSC) is specifically designed to eliminate the effects of light scattering caused by the physical properties of the sample, such as particle size distribution, packing density, and surface roughness.

During the collection of diffuse reflectance spectra from solid samples (e.g., asphalt, powders, soil), light is not only absorbed by the sample (chemical information) but also scattered (physical information). This scattering introduces two primary types of spectral distortion:

Additive Effect: Causes a shift in the spectral baseline (overall upward or downward displacement).

Multiplicative Effect: Causes changes in spectral sensitivity (altering optical path length, stretching or compressing the entire spectrum).

The purpose of MSC is to separate "physical scattering information" from "chemical absorption information" within the spectrum. It corrects baseline shifts and linear slopes, ensuring spectral differences primarily reflect chemical composition (e.g., functional group content in asphalt) rather than the physical state of the sample.

The SNV algorithm is highly intuitive, based on the statistical principles of the standard normal distribution. It performs individual normalization processing on each spectrum (i.e., each sample).

Its processing involves two steps:

Centering: Corrects baseline shifts (additive errors)

Scaling: Corrects intensity variations caused by path length differences or scattering (multiplicative errors)
