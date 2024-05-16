% ��չ��������ر�����ͼ�δ��ں���������
clear all; 
close all;

% ��ȡ��Ƶ�ļ�
[x, fs] = audioread('D:/ѧϰ/����/��Ƶ/�ź�/flag1/flag1_2_5000HZ.wav');

% �����źų��Ⱥ�ʱ��
len = length(x);
t = (0:len-1) / fs;

% ��ƴ�ͨ�˲���
fc = 300; % �趨��ͨ�˲�������Ƶ��Ϊ300Hz
bw = 200;  % �趨����Ϊ200Hz
f1 = fc - bw/2; % ����ͨ������Ƶ��
f2 = fc + bw/2; % ����ͨ������Ƶ��
N = 100; % �˲�������

h = fir1(N, [f1/(fs/2) f2/(fs/2)], 'bandpass');

% ���ź�ͨ���˲���
filtered_signal = filter(h, 1, x);

% ����ԭʼ�źź��˲�����ź�
figure;
subplot(2,1,1);
plot(t, x);
title('ԭʼ�ź�');
xlabel('ʱ�� (s)');
ylabel('���');

subplot(2,1,2);
plot(t, filtered_signal);
title('�˲�����ź�');
xlabel('ʱ�� (s)');
ylabel('���');

