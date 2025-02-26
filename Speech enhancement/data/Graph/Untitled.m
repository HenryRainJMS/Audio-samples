figure,
subplot(121),spectrogram(waves.speech,256,250,256,param.fs,'yaxis');
set(gca,'fontname','Times new roman','fontsize',10);
xlabel({'(a)'},'FontWeight','normal')
ylabel('Frequency (Hz) ','FontWeight','normal')


subplot(122),spectrogram(waves.noisy,256,250,256,param.fs,'yaxis');
set(gca,'fontname','Times new roman','fontsize',10);
xlabel({'(b)'},'FontWeight','normal')
ylabel({})
title({['PESQ = ',num2str(PESQ.noisy,'%.2f'),'  SDR = ',num2str(SDR.noisy,'%.2f')];[' STOI = ',num2str(STOI.noisy,'%.2f'),'  SSNR = ',num2str(SSNR.noisy,'%.2f')]},'FontWeight','normal');
