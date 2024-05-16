% ��ȡԭ�ź�
[audio,Fs] = audioread("C:\Users\Venrio\Desktop\310_55.wav");
[len,~] = size(audio);

% ����ԭʼ�źŵĹ���
P_signal = rms(audio)^2;

% ����Ŀ����������
target_SNR = 20; % Ŀ��SNRΪ20dB
P_noise = P_signal / (10^(target_SNR/10));

% ��������
n = sqrt(P_noise) * randn(len, 1); % ʹ��randn�������ɸ�˹������

% ������
noisy_audio = audio + n;

% ����ʵ�ʵ�SNR
actual_SNR = snr(audio, noisy_audio - audio);

% ��ͼ
subplot(211);
plot(audio);
title('ԭ�ź�');

subplot(212);
plot(noisy_audio);
title(['���źţ�ʵ�������=', num2str(actual_SNR), 'dB']);
