% 清空工作区、关闭所有图形窗口和清除命令窗口
clear all; 
close all;

% 读取音频文件
[x, fs] = audioread('D:/学习/毕设/音频/信号/flag1/flag1_2_5000HZ.wav');

% 计算信号长度和时间
len = length(x);
t = (0:len-1) / fs;

% 设计带通滤波器
fc = 300; % 设定带通滤波器中心频率为300Hz
bw = 200;  % 设定带宽为200Hz
f1 = fc - bw/2; % 计算通带下限频率
f2 = fc + bw/2; % 计算通带上限频率
N = 100; % 滤波器阶数

h = fir1(N, [f1/(fs/2) f2/(fs/2)], 'bandpass');

% 将信号通过滤波器
filtered_signal = filter(h, 1, x);

% 绘制原始信号和滤波后的信号
figure;
subplot(2,1,1);
plot(t, x);
title('原始信号');
xlabel('时间 (s)');
ylabel('振幅');

subplot(2,1,2);
plot(t, filtered_signal);
title('滤波后的信号');
xlabel('时间 (s)');
ylabel('振幅');

