clc;clear all;close all;
addpath(fullfile('.','Eval'));
param.fs=8000;
%% 读取音频文件
waves.speech=wavread('speech.wav');
waves.noisy=wavread('noisy.wav');
enspeech.Stannoisyphase=wavread('Stannoisyphase.wav');
enspeech.noisyphase=wavread('noisyphase.wav');
enspeech.proposedPSC=wavread('proposedPSC.wav');
enspeech.proposedPSF=wavread('proposedPSF.wav');
enspeech.speechphase=wavread('speechphase.wav');
Len_speech=length(waves.speech);
%% 评估
%PESQ
PESQ.noisy=pesq2(waves.speech,waves.noisy,param.fs);
PESQ.Stannoisyphase=pesq2(waves.speech,enspeech.Stannoisyphase,param.fs);
PESQ.noisyphase=pesq2(waves.speech,enspeech.noisyphase,param.fs);
PESQ.proposedPSC=pesq2(waves.speech,enspeech.proposedPSC,param.fs);
PESQ.proposedPSF=pesq2(waves.speech,enspeech.proposedPSF,param.fs);
PESQ.speechphase=pesq2(waves.speech,enspeech.speechphase,param.fs);
fprintf('\n PESQ2 \n');
disp(PESQ);
%STOI
STOI.noisy=stoi(waves.speech,waves.noisy,param.fs);
STOI.Stannoisyphase=stoi(waves.speech,enspeech.Stannoisyphase(1:Len_speech),param.fs);
STOI.noisyphase=stoi(waves.speech,enspeech.noisyphase(1:Len_speech),param.fs);
STOI.proposedPSC=stoi(waves.speech,enspeech.proposedPSC(1:Len_speech),param.fs);
STOI.proposedPSF=stoi(waves.speech,enspeech.proposedPSF(1:Len_speech),param.fs);
STOI.speechphase=stoi(waves.speech,enspeech.speechphase(1:Len_speech),param.fs);
fprintf('\n STOI \n');
disp(STOI);
%SDR
fprintf('\n SDR \n');
[SDR.noisy,SIR.noisy,SAR.noisy,perm.noisy]=bss_eval_sources(waves.noisy',waves.speech');
[SDR.Stannoisyphase,SIR.Stannoisyphase,SAR.Stannoisyphase,perm.Stannoisyphase]=bss_eval_sources(enspeech.Stannoisyphase(1:Len_speech)',waves.speech');
[SDR.noisyphase,SIR.noisyphase,SAR.noisyphase,perm.noisyphase]=bss_eval_sources(enspeech.noisyphase(1:Len_speech)',waves.speech');
[SDR.proposedPSC,SIR.proposedPSC,SAR.proposedPSC,perm.proposedPSC]=bss_eval_sources(enspeech.proposedPSC(1:Len_speech)',waves.speech');
[SDR.proposedPSF,SIR.proposedPSF,SAR.proposedPSF,perm.proposedPSF]=bss_eval_sources(enspeech.proposedPSF(1:Len_speech)',waves.speech');
[SDR.speechphase,SIR.speechphase,SAR.speechphase,perm.speechphase]=bss_eval_sources(enspeech.speechphase(1:Len_speech)',waves.speech');
disp(SDR);
%SSNR
SSNR.noisy=segsnr(waves.speech,waves.noisy,param.fs);
SSNR.Stannoisyphase=segsnr(waves.speech,enspeech.Stannoisyphase(1:Len_speech),param.fs);
SSNR.noisyphase=segsnr(waves.speech,enspeech.noisyphase(1:Len_speech),param.fs);
SSNR.proposedPSC=segsnr(waves.speech,enspeech.proposedPSC(1:Len_speech),param.fs);
SSNR.proposedPSF=segsnr(waves.speech,enspeech.proposedPSF(1:Len_speech),param.fs);
SSNR.speechphase=segsnr(waves.speech,enspeech.speechphase(1:Len_speech),param.fs);
fprintf('\n SSNR \n');
disp(SSNR);
%%
figure,

subplot(331),spectrogram(waves.speech,512,500,512,param.fs,'yaxis');
set(gca,'YTickLabel',{'0','1','2','3','4'}) ;
set(gca,'fontname','Times new roman','fontsize',10);
xlabel({['\fontsize{14}\fontname{Times new roman} (a) Clean']},'FontWeight','normal')
% ylabel(['\fontsize{10}\fontname{宋体}频率\fontname{Times new roman}/kHz']);
ylabel('Frequency (kHz) ','FontWeight','normal')
% position1=[0.267 0.72 0.04 0.18];
% Create(gcf,position1)
% position11=[0.376 0.72 0.05 0.1];
% Create(gcf,position11)
% set (gcf,'Position',[0,0,512,512])
% set(gca, 'LooseInset', [0,0,0,0])

subplot(332),spectrogram(waves.noisy,512,500,512,param.fs,'yaxis');
set(gca,'YTickLabel',{'0','1','2','3','4'}) ;
set(gca,'fontname','Times new roman','fontsize',10);
xlabel({['\fontsize{14}\fontname{Times new roman} (b) Noisy']},'FontWeight','normal')
% ylabel(['\fontsize{10}\fontname{宋体}频率\fontname{Times new roman}/kHz']);
ylabel('Frequency (kHz) ','FontWeight','normal')
title({['PESQ = ',num2str(PESQ.noisy,'%.2f'),'  SDR = ',num2str(SDR.noisy,'%.2f')];[' STOI = ',num2str(STOI.noisy,'%.2f'),'  SSNR = ',num2str(SSNR.noisy,'%.2f')]},'FontWeight','normal');



subplot(334),spectrogram(enspeech.Stannoisyphase,512,500,512,param.fs,'yaxis');
set(gca,'YTickLabel',{'0','1','2','3','4'}) ;
set(gca,'fontname','Times new roman','fontsize',10);
xlabel({['\fontsize{14}\fontname{Times new roman} (c) NMF']},'FontWeight','normal')
% ylabel(['\fontsize{10}\fontname{宋体}频率\fontname{Times new roman}/kHz']);
ylabel('Frequency (kHz) ','FontWeight','normal')
title({['PESQ = ',num2str(PESQ.Stannoisyphase,'%.2f'),'  SDR = ',num2str(SDR.Stannoisyphase,'%.2f')];['STOI = ',num2str(STOI.Stannoisyphase,'%.2f'),'  SSNR = ',num2str(SSNR.Stannoisyphase,'%.2f')]},'FontWeight','normal');


subplot(335),spectrogram(enspeech.noisyphase,512,500,512,param.fs,'yaxis');
set(gca,'YTickLabel',{'0','1','2','3','4'}) ;
set(gca,'fontname','Times new roman','fontsize',10);
xlabel({['\fontsize{14}\fontname{Times new roman} (d) NMF(Proposed)']},'FontWeight','normal')
% ylabel(['\fontsize{10}\fontname{宋体}频率\fontname{Times new roman}/kHz']);
ylabel('Frequency (kHz) ','FontWeight','normal')
title({['PESQ = ',num2str(PESQ.noisyphase,'%.2f'),'  SDR = ',num2str(SDR.noisyphase,'%.2f')];['STOI = ',num2str(STOI.noisyphase,'%.2f'),'  SSNR = ',num2str(SSNR.noisyphase,'%.2f')]},'FontWeight','normal');



subplot(337),spectrogram(enspeech.noisyphase,512,500,512,param.fs,'yaxis');
set(gca,'YTickLabel',{'0','1','2','3','4'}) ;
set(gca,'fontname','Times new roman','fontsize',10);
xlabel({['\fontsize{14}\fontname{Times new roman} (e) NMF(Proposed)+PSC']},'FontWeight','normal')
% ylabel(['\fontsize{10}\fontname{宋体}频率\fontname{Times new roman}/kHz']);
ylabel('Frequency (kHz) ','FontWeight','normal')
title({['PESQ = ',num2str(PESQ.proposedPSC,'%.2f'),'  SDR = ',num2str(SDR.proposedPSC,'%.2f')];['STOI = ',num2str(STOI.proposedPSC,'%.2f'),'  SSNR = ',num2str(SSNR.proposedPSC,'%.2f')]},'FontWeight','normal');


subplot(338),spectrogram(enspeech.proposedPSF,512,500,512,param.fs,'yaxis');
set(gca,'YTickLabel',{'0','1','2','3','4'}) ;
set(gca,'fontname','Times new roman','fontsize',10);
xlabel({['\fontsize{14}\fontname{Times new roman} (f) NMF(Proposed)+PSF']},'FontWeight','normal')
% ylabel(['\fontsize{10}\fontname{宋体}频率\fontname{Times new roman}/kHz']);
ylabel('Frequency (kHz) ','FontWeight','normal')
title({['PESQ = ',num2str(PESQ.proposedPSF,'%.2f'),'  SDR = ',num2str(SDR.proposedPSF,'%.2f')];['STOI = ',num2str(STOI.proposedPSF,'%.2f'),'  SSNR = ',num2str(SSNR.proposedPSF,'%.2f')]},'FontWeight','normal');


subplot(339),spectrogram(enspeech.speechphase,512,500,512,param.fs,'yaxis');
set(gca,'YTickLabel',{'0','1','2','3','4'}) ;
set(gca,'fontname','Times new roman','fontsize',10);
xlabel({['\fontsize{14}\fontname{Times new roman} (g) NMF(Proposed)+Clean Phase']},'FontWeight','normal')
% ylabel(['\fontsize{10}\fontname{宋体}频率\fontname{Times new roman}/kHz']);
ylabel('Frequency (kHz) ','FontWeight','normal')
title({['PESQ = ',num2str(PESQ.speechphase,'%.2f'),'  SDR = ',num2str(SDR.speechphase,'%.2f')];['STOI = ',num2str(STOI.speechphase,'%.2f'),'  SSNR = ',num2str(SSNR.speechphase,'%.2f')]},'FontWeight','normal');
colormap('jet')
% set(gca,'looseInset', [0 0 0 0])
% set(gca,'LooseInset',get(gca,'TightInset'))

%%
% sound(waves.speech)
% sound(waves.noisy)
% sound(enspeech.Stannoisyphase)
% sound(enspeech.noisyphase)
% sound(enspeech.proposedPSC)
% sound(enspeech.proposedPSF)
% sound(enspeech.speechphase)



