% ��չ��������ر�����ͼ�δ��ں���������
clear all; 
close all;

% ֱ�Ӷ�ȡ������Ƶ����
[x1, fs1] = audioread('D:/ѧϰ/����/��Ƶ/�ź�/flag2/flag2_1_2000HZ.wav');
[x2, fs2] = audioread('D:/ѧϰ/����/��Ƶ/�ź�/flag2/flag2_2_2000HZ.wav');

SNR = 25;
% ���������
Px = 0.5*(mean([x1(:); x2(:)].^2));
Pn = Px*10^(-SNR/10);

% �����˹����
rng('default')
x1 = x1 + sqrt(Pn)*randn(size(x1));
x2 = x2 + sqrt(Pn)*randn(size(x2));

% ����ÿ������֡��Ӧ��trueTDOAֵ
trueTDOA_values = [-145, -16]; % ÿ������֡��trueTDOAֵ

%% Short-Time Windowing
wlen = 2048;
hop = 512;
w = hann(wlen);

% ��ÿ����Ƶ�ļ����ж�ʱ���ڴ���
x1ef = enframe(x1, w, hop).';
x2ef = enframe(x2, w, hop).';

%% Compute FS-GCC for the speech frames
Nfft = 2048;
B = 128;
M = 32;

% ѡ����������֡
ntest = [3, 2];
Ntest = length(ntest);

for n = 1:Ntest
    trueTDOA = trueTDOA_values(n); % ���ݲ���֡ѡ����Ӧ��trueTDOAֵ
    %% Compute FS-GCC Matrix
    xinput = [x1ef(:,ntest(n)), x2ef(:,ntest(n))];
    [FSGCCmat,lags,tpwin] = msrpfsgcc(xinput,Nfft,B,M);
    
    % ���� FS-GCC ͼ
    figure(1), subplot(2,4,n);
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
    figure(1), subplot(2,4,n+2);
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
    figure(1), subplot(2,4,n+4);
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
    figure(1), subplot(2,4,n+6);
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