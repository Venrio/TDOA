clear all; 
set(0,'defaulttextinterpreter','latex')
close all;

% 加载三个音频文件
[x1, fs1] = audioread("C:/Users/Venrio/Desktop/583_247.wav");
[x2, fs2] = audioread("C:/Users/Venrio/Desktop/481_295.wav");
[x3, fs3] = audioread("C:/Users/Venrio/Desktop/310_55.wav");

SNR = 25;
% 计算信噪比
Px = 0.5*(mean([x1(:); x2(:); x3(:)].^2));
Pn = Px*10^(-SNR/10);

% 加入高斯噪声
rng('default')
x1 = x1 + sqrt(Pn)*randn(size(x1));
x2 = x2 + sqrt(Pn)*randn(size(x2));
x3 = x3 + sqrt(Pn)*randn(size(x3));

% 定义每个测试帧对应的trueTDOA值
trueTDOA_values = [69, 117, 148]; % 每个测试帧的trueTDOA值

%% Short-Time Windowing
wlen = 2048;
hop = 512;
w = hann(wlen);

% 对每个音频文件进行短时窗口处理
x1ef = enframe(x1, w, hop).';
x2ef = enframe(x2, w, hop).';
x3ef = enframe(x3, w, hop).';

%% Compute FS-GCC for three speech frames (39, 35 and 55)
Nfft = 2048;
B = 128;
M = 32;

% 选择三个测试帧
%ntest = [30, 60, 35];
ntest = [59, 60, 35];
Ntest = length(ntest);

for n = 1:Ntest
    trueTDOA = trueTDOA_values(n); % 根据测试帧选择相应的trueTDOA值
    %% Compute FS-GCC Matrix
    xinput = [x1ef(:,ntest(n)), x2ef(:,ntest(n)), x3ef(:,ntest(n))];
    [FSGCCmat,lags,tpwin] = msrpfsgcc(xinput,Nfft,B,M);
    
    % 绘制 FS-GCC 图
    figure(1), subplot(3,4,(n-1)*4+1);
    imagesc(lags,[],abs(FSGCCmat.'));
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
    
    %% Compute Conventional GCC-PHAT
    GCC = fftshift(real(ifft(exp(1i*angle(fft(xinput(:,1),Nfft).*conj(fft(xinput(:,2),Nfft)))))));    
    figure(1), subplot(3,4,(n-1)*4+2);
    GCCn = GCC/max(GCC);
    plot(lags,GCCn);
    hold on, line([trueTDOA trueTDOA],[min(GCCn) 1],'color','red');
    axis tight;    
    xlim([-200 200])
    xticks([-200 -100 0 100 200])    
    pbaspect([1 1 1])
    xlabel('$\tau$')
    if n == 1
        title({'Conventional GCC-PHAT','',''});
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
