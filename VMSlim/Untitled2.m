clear
setPath
currentDirectory = pwd;

% ������Ƶ���ݣ�������Ƶ�ļ���Ϊ'audio_data.wav'
[audio_data, Fs] = audioread('C:\Users\Venrio\Desktop\481_295.wav');

% ������������
S = struct();
S.x = audio_data; % ʱ���ź�
S.samplingRate = Fs; % ������
S.fileName = '481_295'; % �ļ��������Զ��壩

% ��������ʱ��ͼ��Ƶ��ͼ
wndw = 80;
olap = 40;
nc = 3; % �޸�Ϊ3��
nr = 2;
pn = 1;
figure;

% ���ƻָ���ʱ���ź�
subplot(nc, nr, pn);
plot(S.x);
title('Recovered time signal');
pn = pn + 1;

% ���ƻָ���ʱ��Ƶ��ͼ
subplot(nc, nr, pn);
spectrogram(S.x, wndw, olap);
title('Recovered spectrogram');
pn = pn + 1;

% ���Ƹ�ͨ�˲����ʱ���ź�
highpass_filtered = highpass(S.x, 100, Fs); % ��ͨ�˲�
subplot(nc, nr, pn);
plot(highpass_filtered);
title('Highpass filtered time signal');
pn = pn + 1;

% ���Ƹ�ͨ�˲����ʱ��Ƶ��ͼ
subplot(nc, nr, pn);
spectrogram(highpass_filtered, wndw, olap);
title('Highpass filtered spectrogram');
pn = pn + 1;

% ����׼��������ͼ
% �׼�������
noise_floor = 0.05; % ��������
cleaned_signal = spectral_subtraction(highpass_filtered, wndw, olap, noise_floor);

% �����׼���������ʱ���ź�
subplot(nc, nr, pn);
plot(cleaned_signal);
title('Spectral subtraction cleaned signal');
pn = pn + 1;

% �����׼���������ʱ��Ƶ��ͼ
subplot(nc, nr, pn);
spectrogram(cleaned_signal, wndw, olap);
title('Spectral subtraction cleaned spectrogram');
pn = pn + 1;

function cleaned_signal = spectral_subtraction(signal, wndw, olap, noise_floor)
    % �����ʱ����Ҷ�任
    [~, F, T, P] = spectrogram(signal, wndw, olap);
    
    % ������������
    noise_power = mean(P(:, F < noise_floor), 2);
    
    % �׼�������
    P_cleaned = max(P - noise_power, 0);
    
    % ���任�õ��������ź�
    cleaned_signal = istft(P_cleaned, wndw, olap);
end