% 读取WAV文件
[x, fs] = audioread('C:/Users/Venrio/Desktop/481_295.wav');

% 保存为MAT文件
save('plant3.mat', 'x', 'fs');