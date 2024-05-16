% ��չ��������ر�����ͼ�δ��ں���������
clear all; 
close all;

% ֱ�Ӷ�ȡ������Ƶ����
[x1, fs1] = audioread('D:/ѧϰ/����/��Ƶ/�ź�/flag1/flag1_1_5000HZ.wav');
[x2, fs2] = audioread('D:/ѧϰ/����/��Ƶ/�ź�/flag1/flag1_2_5000HZ.wav');

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
    figure(1), subplot(2,2,n);
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
    
    %% Compute SVD FS-GCC
    [GCCsvd,lags] = getsvdfsgcc(FSGCCmat,200);
    figure(1), subplot(2,2,n+2);
    GCCsvdn = GCCsvd/max(GCCsvd);
    plot(lags,GCCsvdn);
    hold on, line([trueTDOA trueTDOA],[min(GCCsvdn) 1],'color','red');
    axis tight;
    pbaspect([1 1 1])
    xlabel('$\tau$')
    if n == 1
        title({'SVD FS-GCC','',''});
    end
    
end
