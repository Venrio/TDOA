clear all; 
set(0,'defaulttextinterpreter','latex')
close all;

% 加载三个音频文件
[x1, fs1] = audioread("C:/Users/Venrio/Desktop/583_247.wav");
[x2, fs2] = audioread("C:/Users/Venrio/Desktop/481_295.wav");
[x3, fs3] = audioread("C:/Users/Venrio/Desktop/310_55.wav");

% 选择参考音频数据和待测音频数据
ref_audio = x1;
test_audios = {x2, x3};

% 计算信噪比
SNR = 25;
Px_ref = 0.5 * mean(ref_audio.^2);
Pn_ref = Px_ref * 10^(-SNR/10);

% 加入高斯噪声
rng('default')
ref_audio_noisy = ref_audio + sqrt(Pn_ref) * randn(size(ref_audio));
test_audios_noisy = cell(size(test_audios));
for i = 1:numel(test_audios)
    test_audios_noisy{i} = test_audios{i} + sqrt(Pn_ref) * randn(size(test_audios{i}));
end

% 定义测试帧的位置
ntest = [30, 60, 90]; % 选择在音频文件中的特定时间点作为测试帧
Ntest = length(ntest);

% 定义每个测试帧对应的trueTDOA值
trueTDOA_values = [11, 117, 117]; % 每个测试帧的trueTDOA值

% Short-Time Windowing 参数
wlen = 2048;
hop = 512;
w = hann(wlen);

% 对参考音频数据和待测音频数据进行短时窗口处理
ref_audio_enframed = enframe(ref_audio_noisy, w, hop).';
test_audios_enframed = cell(size(test_audios));
for i = 1:numel(test_audios)
    test_audios_enframed{i} = enframe(test_audios_noisy{i}, w, hop).';
end

% Compute FS-GCC for each speech frame
Nfft = 2048;
B = 128;
M = 32;

for n = 1:Ntest
    trueTDOA = trueTDOA_values(n); % 根据测试帧选择相应的trueTDOA值
    
    % 选择参考帧和测试帧
    ref_frame = ref_audio_enframed(:, ntest(n));
    test_frames = cellfun(@(x) x(:, ntest(n)), test_audios_enframed, 'UniformOutput', false);
    
    % 计算 FS-GCC Matrix
    [FSGCCmat, lags, tpwin] = msrpfsgcc([ref_frame, test_frames{1}, test_frames{2}], Nfft, B, M);
    
    % 绘制 FS-GCC 图
    figure(1), subplot(3,4,(n-1)*4+1);
    imagesc(lags, [], abs(FSGCCmat.'));
    xticks([-200 -100 0 100 200])    
    pbaspect([1 1 1])
    xlim([-200 200])
    xlabel('$\tau$')
    ylabel('$l$');
    if n == 1 
        title({'FS-GCC','','$|\mathbf{R}|^{T}$'});
    else
        title('$|\mathbf{R}|^{T}$');
    end
    
    %% Compute PHAT FS-GCC
    % 计算 PHAT GCC
    R1 = fft(ref_frame, Nfft);
    R2 = fft(test_frames{1}, Nfft);
    R3 = fft(test_frames{2}, Nfft);
    PHAT_GCC = real(ifft((R1 .* conj(R2)) ./ abs(R1 .* conj(R2)))) - real(ifft((R1 .* conj(R3)) ./ abs(R1 .* conj(R3))));
    % 绘制 PHAT 结果图
    figure(1), subplot(3,4,(n-1)*4+2);
    PHAT_GCC_normalized = PHAT_GCC / max(abs(PHAT_GCC));
    plot(lags, PHAT_GCC_normalized);
    hold on, line([trueTDOA trueTDOA],[min(PHAT_GCC_normalized) 1],'color','red');
    axis tight;    
    xlim([-200 200])
    xticks([-200 -100 0 100 200])    
    pbaspect([1 1 1])
    xlabel('$\tau$')
    if n == 1
        title({'PHAT FS-GCC','',''});
    end
    
    %% Compute SVD FS-GCC
    [GCCsvd,lags] = getsvdfsgcc(FSGCCmat,200);
    figure(1), subplot(3,4,(n-1)*4+3);
    GCCsvdn = GCCsvd/max(GCCsvd);
    plot(lags,GCCsvdn);
    hold on, line([trueTDOA trueTDOA],[min(GCCsvdn) 1],'color','red');
    axis tight;
    pbaspect([1 1 1])
    xlabel('$\tau$')
    if n == 1
        title({'SVD FS-GCC','',''});
    end
    
    %% Compute WSVD FS-GCC
    [GCCwsvd,lags] = getwsvdfsgcc(FSGCCmat,tpwin,200);
    figure(1), subplot(3,4,(n-1)*4+4);
    GCCwsvdn = GCCwsvd/max(GCCwsvd);
    plot(lags,GCCwsvdn);
    hold on, line([trueTDOA trueTDOA],[min(GCCwsvdn) 1],'color','red');
    axis tight;
    pbaspect([1 1 1])
    xlabel('$\tau$')
    if n == 1
        title({'WSVD FS-GCC','',''});
    end
    
end
