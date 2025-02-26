clc;clear all;close all;
addpath(fullfile('.','Eval'));
param.fs=8000;
%% ∂¡»°“Ù∆µŒƒº˛
waves.speech=wavread('speech.wav');
waves.noisy=wavread('noisy.wav');
enspeech.Stannoisyphase=wavread('Stannoisyphase.wav');
enspeech.noisyphase=wavread('noisyphase.wav');
enspeech.proposedPSC=wavread('proposedPSC.wav');
enspeech.proposedPSF=wavread('proposedPSF.wav');
enspeech.speechphase=wavread('speechphase.wav');
Len_speech=length(waves.speech);
%% ∆¿π¿
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

%% ªÊ÷∆ ±”ÚÕº
figure,
t = 0:1/param.fs:(length(waves.speech)-1)/param.fs;

subplot(331),plot(t,waves.speech);
xlabel({'Time (s)';'\fontsize{14}\fontname{Times new roman} (a) Clean'},'FontWeight','normal')
ylabel('Amplitude','FontWeight','normal')
set(gca,'Xlim',[0 (length(waves.speech)-1)/param.fs]);

subplot(332),plot(t,waves.noisy);
xlabel({'Time (s)';'\fontsize{14}\fontname{Times new roman} (b) Noisy'},'FontWeight','normal')
ylabel('Amplitude','FontWeight','normal')
title('SNR = ','FontWeight','normal')
set(gca,'Xlim',[0 (length(waves.speech)-1)/param.fs]);


t = 0:1/param.fs:(length(enspeech.Stannoisyphase)-1)/param.fs;

subplot(334),plot(t,enspeech.Stannoisyphase);
xlabel({'Time (s)';'\fontsize{14}\fontname{Times new roman} (c) NMF'},'FontWeight','normal')
ylabel('Amplitude','FontWeight','normal')
title('SNR = ','FontWeight','normal')
set(gca,'Xlim',[0 (length(enspeech.Stannoisyphase)-1)/param.fs]);

subplot(335),plot(t,enspeech.noisyphase);
xlabel({'Time (s)';'\fontsize{14}\fontname{Times new roman} (d) NMF(Proposed)'},'FontWeight','normal')
ylabel('Amplitude','FontWeight','normal')
title('SNR = ','FontWeight','normal')
set(gca,'Xlim',[0 (length(enspeech.Stannoisyphase)-1)/param.fs]);

subplot(337),plot(t,enspeech.noisyphase);
xlabel({'Time (s)';'\fontsize{14}\fontname{Times new roman} (e) NMF(Proposed)+PSC'},'FontWeight','normal')
ylabel('Amplitude','FontWeight','normal')
title('SNR = ','FontWeight','normal')
set(gca,'Xlim',[0 (length(enspeech.Stannoisyphase)-1)/param.fs]);

subplot(338),plot(t,enspeech.proposedPSF);
xlabel({'Time (s)';'\fontsize{14}\fontname{Times new roman} (f) NMF(Proposed)+PSF'},'FontWeight','normal')
ylabel('Amplitude','FontWeight','normal')
title('SNR = ','FontWeight','normal')
set(gca,'Xlim',[0 (length(enspeech.Stannoisyphase)-1)/param.fs]);

subplot(339),plot(t,enspeech.speechphase);
xlabel({'Time (s)';'\fontsize{14}\fontname{Times new roman} (g) NMF(Proposed)+Clean Phase'},'FontWeight','normal')
ylabel('Amplitude','FontWeight','normal')
title('SNR = ','FontWeight','normal')
set(gca,'Xlim',[0 (length(enspeech.Stannoisyphase)-1)/param.fs]);




