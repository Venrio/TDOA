% 读取原信号
[audio,Fs] = audioread("C:\Users\Venrio\Desktop\310_55.wav");
[len,~] = size(audio);

% 计算原始信号的功率
P_signal = rms(audio)^2;

% 计算目标噪声功率
target_SNR = 20; % 目标SNR为20dB
P_noise = P_signal / (10^(target_SNR/10));

% 生成噪声
n = sqrt(P_noise) * randn(len, 1); % 使用randn函数生成高斯白噪声

% 加噪声
noisy_audio = audio + n;

% 计算实际的SNR
actual_SNR = snr(audio, noisy_audio - audio);

% 画图
subplot(211);
plot(audio);
title('原信号');

subplot(212);
plot(noisy_audio);
title(['新信号，实际信噪比=', num2str(actual_SNR), 'dB']);
