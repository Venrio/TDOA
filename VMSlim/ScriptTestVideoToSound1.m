clear
setPath
currentDirectory = pwd;

% ������Ƶ���ݣ�������Ƶ�ļ���Ϊ'audio_data.wav'
[audio_data, Fs] = audioread('D:\ѧϰ\����\��Ƶ\�ź�\flag1\flag1_1_5000HZ.wav');

% ������������
S = struct();
S.x = audio_data; % ʱ���ź�
S.samplingRate = Fs; % ������
S.fileName = 'flag1_1_5000HZ'; % �ļ��������Զ��壩

% ��������ʱ��ͼ��Ƶ��ͼ
wndw = 80;
olap = 40;
nc = 2;
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
