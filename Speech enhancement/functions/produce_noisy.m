function [Noisy Speech_proc Noise_proc ER]=produce_noisy(Speech,Noise,snr_pre,snr_method);
% Given clean speech and noise input, generate a noisy signal at specific
% input SNR (loizou/pejman)
Speech=Speech(:);  Noise=Noise(:,1);
if strcmp(snr_method,'pejman')
    if length(Speech)>length(Noise)
        length_diff=length(Speech)-length(Noise);
        Noise_tmp=[Noise ; zeros(length_diff,1)];
        Speech_tmp=Speech;
    elseif length(Speech)<length(Noise)
        length_diff=length(Noise)-length(Speech);
        Speech_tmp=[Speech ; zeros(length_diff,1)];
        Noise_tmp=Noise;
    else
        Speech_tmp=Speech;
        Noise_tmp=Noise;
    end
    Noise_proc=Noise_tmp;
    %     Lmin=min(length(Speech),length(Noise));
    %     Speech=Speech(1:Lmin);
    %     Noise=Noise(1:Lmin);
    
    % produce noisy signal
    Speech_proc=Speech_tmp;
    %     Noise_proc=Noise_tmp/sum(Noise_tmp.^2);
    E1=sum(Speech.^2); E2=sum(Noise_proc.^2);
    ER=(E2/E1); ER=ER*(10^(snr_pre/20));
    Noisy = Speech_proc+Noise_proc/ER;                         % Create noisy file
    
elseif strcmp(snr_method,'loizou')
    Lmin=min(length(Speech),length(Noise));
    Speech=Speech(1:Lmin);
    Noise=Noise(1:Lmin);
    cl=Speech; n0=Noise; nsnr=snr_pre;
    n = n0(1:length(cl));
    n = n - mean(n);
    se=norm(cl,2)^2; %... signal energy
    nsc=se/(10^(nsnr/10));
    ne=norm(n,2)^2;  % noise energy
    n=sqrt(nsc/ne)*n; % scale noise energy to get required SNR
    ne=norm(n,2)^2;
    %     fprintf('Estimated SNR=%f\n',10*log10(se/ne));
    Noisy = cl + n;    % the noisy signal
    ER=1/sqrt(nsc/ne);
    Speech_proc=cl;
    Noise_proc=n;
end
