clear
setPath
currentDirectory = pwd;

% 导入音频数据，假设音频文件名为'audio_data.wav'
[audio_data, Fs] = audioread('D:\学习\毕设\音频\信号\flag1\flag1_1_5000HZ.wav');

% 构造声音对象
S = struct();
S.x = audio_data; % 时间信号
S.samplingRate = Fs; % 采样率
S.fileName = 'flag1_1_5000HZ'; % 文件名（可自定义）

% 绘制声音时域图和频谱图
wndw = 80;
olap = 40;
nc = 2;
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
