clear
setPath
currentDirectory = pwd;

% 导入音频数据，假设音频文件名为'audio_data.wav'
[audio_data, Fs] = audioread('C:\Users\Venrio\Desktop\481_295.wav');

% 构造声音对象
S = struct();
S.x = audio_data; % 时间信号
S.samplingRate = Fs; % 采样率
S.fileName = '481_295'; % 文件名（可自定义）

% 绘制声音时域图和频谱图
wndw = 80;
olap = 40;
nc = 3; % 修改为3列
nr = 2;
pn = 1;
figure;

% 绘制恢复的时间信号
subplot(nc, nr, pn);
plot(S.x);
title('Recovered time signal');
pn = pn + 1;

% 绘制恢复的时域频谱图
subplot(nc, nr, pn);
spectrogram(S.x, wndw, olap);
title('Recovered spectrogram');
pn = pn + 1;

% 绘制高通滤波后的时间信号
highpass_filtered = highpass(S.x, 100, Fs); % 高通滤波
subplot(nc, nr, pn);
plot(highpass_filtered);
title('Highpass filtered time signal');
pn = pn + 1;

% 绘制高通滤波后的时域频谱图
subplot(nc, nr, pn);
spectrogram(highpass_filtered, wndw, olap);
title('Highpass filtered spectrogram');
pn = pn + 1;

% 添加谱减法处理的图
% 谱减法处理
noise_floor = 0.05; % 噪声门限
cleaned_signal = spectral_subtraction(highpass_filtered, wndw, olap, noise_floor);

% 绘制谱减法处理后的时间信号
subplot(nc, nr, pn);
plot(cleaned_signal);
title('Spectral subtraction cleaned signal');
pn = pn + 1;

% 绘制谱减法处理后的时域频谱图
subplot(nc, nr, pn);
spectrogram(cleaned_signal, wndw, olap);
title('Spectral subtraction cleaned spectrogram');
pn = pn + 1;

function cleaned_signal = spectral_subtraction(signal, wndw, olap, noise_floor)
    % 计算短时傅里叶变换
    [~, F, T, P] = spectrogram(signal, wndw, olap);
    
    % 估计噪声能量
    noise_power = mean(P(:, F < noise_floor), 2);
    
    % 谱减法处理
    P_cleaned = max(P - noise_power, 0);
    
    % 反变换得到处理后的信号
    cleaned_signal = istft(P_cleaned, wndw, olap);
end