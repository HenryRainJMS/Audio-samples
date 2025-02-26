clc;clear all;close all;
%�������������
addpath(fullfile('.','functions'));
addpath(fullfile('.','functions','waves'));
addpath(fullfile('.','functions','Eval'));
addpath(fullfile('.','functions','voicebox'));
addpath(fullfile('.','functions','NMF'));
addpath(fullfile('.','functions','NMF','phase recovery'));
addpath(fullfile('.','functions','Database','noise2013'));
%���ò���
param.fs=8000;                                               %ʵ��Ƶ��
noiseFileName='factory1.wav';                        %����

param.snr_pre=0;                                              %���������

% m=length(param.snr_pre);
%��ȡ����
[noise0,fnn_orig]=audioread(noiseFileName);
Noise=resample(noise0,param.fs,fnn_orig);
%��ȡ����
[speech0,fss_orig]=audioread('bbal4s.wav');
waves.speech=resample(speech0,param.fs,fss_orig);
%����ָ������ȵ������ź�
[waves.noisy,waves.speech,noise]=produce_noisy(waves.speech,Noise,param.snr_pre,'loizou');
%% ����֡����֡�ơ�����
frame_len=512;                                                
step=frame_len/2;                                                            
nfft=512;
windowshape='hamming';
%% STFT
Spec.speech=stft(waves.speech,frame_len,step,nfft,windowshape);%��������Ƶ��
Spec.noise=stft(noise,frame_len,step,nfft,windowshape);                   %����Ƶ��
Spec.noisy=stft(waves.noisy,frame_len,step,nfft,windowshape);     %��������Ƶ��
%�����
Phase.speech=angle(Spec.speech);             %�����������
Phase.noisy=angle(Spec.noisy);                     %�����������
Phase.noise=angle(Spec.noise); 
%��������
iter_num=200;
%% �ֽ�������
Rank.speech=30;
Rank.noise=30;
beta=2;
Rank.noisy=Rank.speech+Rank.noise;
%% a posteriori speech presence probability
PH1=SPP(waves.noisy,frame_len, nfft,step, windowshape,param.snr_pre);
save('data\\PH1.mat','PH1');
%% ѵ������������
disp('Training the joint dictionary matrices>>>>>>>>>>>>>')
W=nmf_training(Rank,Spec,beta,iter_num);
% load('data/W.mat')
%% ������Ʒ���
disp('Enhancement stage>>>>>>>>>>>>>>>>>>>>>>>>>')
tic
[ResMag,errs]=training_H(W,Rank,Spec,beta,50);
toc
%% Standard NMF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Standard NMF >>>>>');
%ѵ�������ֵ�
T=standard_nmf_training(Rank,Spec,beta,iter_num);
% load('data/T.mat')
%�������
tic
[StanResMag,errs0]=standard_training_H(T,Rank,Spec,beta,50);
toc
StanMagout=StanResMag.speech;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PSC��λ����
Magout=ResMag.speech;
%���þ��鳣��
lambda=3.74;
A=psc(Magout,lambda);%��������
%��������
Mag.noise=abs(Spec.noise);
Mag.speech=abs(Spec.speech);
Mag.noisy=abs(Spec.noisy);
Spec.proposedPSC=Spec.noisy+A.*ResMag.noise;%��������
Phase.proposedPSC=angle(Spec.proposedPSC);
%%PSF��λ����
theta=pi/2;%���н�
dtheta=atan((ResMag.noise*sin(theta))./(ResMag.speech+ResMag.speech*cos(theta)));
% dtheta=acos(ResMag.speech./Mag.noisy);
Phase.proposedPSF=dtheta+Phase.noisy;
%% �ع�
ResSpec.Stannoisyphase=StanMagout.*exp(1j*Phase.noisy);%����������λ����
ResSpec.noisyphase=Magout.*exp(1j*Phase.noisy);%����������λ
ResSpec.proposedPSC=Magout.*exp(1j*Phase.proposedPSC);%PSC ������λ
ResSpec.speechphase=Magout.*exp(1j*Phase.speech);%����������λ
ResSpec.proposedPSF=Magout.*(cos(Phase.noisy-Phase.proposedPSF)).*exp(1j*Phase.noisy);%PSF����
%ISTFT
enspeech.Stannoisyphase=istft(ResSpec.Stannoisyphase,frame_len,step,nfft);
enspeech.noisyphase=istft(ResSpec.noisyphase,frame_len,step,nfft);
enspeech.proposedPSC=istft(ResSpec.proposedPSC,frame_len,step,nfft);
enspeech.speechphase=istft(ResSpec.speechphase,frame_len,step,nfft);
enspeech.proposedPSF=istft(ResSpec.proposedPSF,frame_len,step,nfft);
Len_speech=length(waves.speech);
%% ����
%PESQ
PESQ.noisy=pesq2(waves.speech,waves.noisy,param.fs);
PESQ.Stannoisyphase=pesq2(waves.speech,enspeech.Stannoisyphase,param.fs);
PESQ.noisyphase=pesq2(waves.speech,enspeech.noisyphase,param.fs);
PESQ.proposedPSC=pesq2(waves.speech,enspeech.proposedPSC,param.fs);
PESQ.proposedPSF=pesq2(waves.speech,enspeech.proposedPSF,param.fs);
PESQ.speechphase=pesq2(waves.speech,enspeech.speechphase,param.fs);
fprintf('\n PESQ \n');
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

%% ��ϳɾ���
PE0=struct2cell(PESQ);
ST0=struct2cell(STOI);
SD0=struct2cell(SDR);
SS0=struct2cell(SSNR);
%ת���ɾ���
PE=num2str(cell2mat(PE0(:)),'%.4f');
ST=num2str(cell2mat(ST0(:)),'%.4f');
SD=num2str(cell2mat(SD0(:)),'%.4f');
SS=num2str(cell2mat(SS0(:)),'%.4f');
%% ��������ֵ

figure,
subplot(331),spectrogram(waves.speech,256,250,256,param.fs,'yaxis');
set(gca,'fontname','Times new roman','fontsize',10);
xlabel({'(a)'},'FontWeight','normal')
ylabel('Frequency (Hz) ','FontWeight','normal')


subplot(332),spectrogram(waves.noisy,256,250,256,param.fs,'yaxis');
set(gca,'fontname','Times new roman','fontsize',10);
xlabel({'(b)'},'FontWeight','normal')
ylabel({})
title({['PESQ = ',num2str(PESQ.noisy,'%.2f'),'  SDR = ',num2str(SDR.noisy,'%.2f')];[' STOI = ',num2str(STOI.noisy,'%.2f'),'  SSNR = ',num2str(SSNR.noisy,'%.2f')]},'FontWeight','normal');



subplot(334),spectrogram(enspeech.Stannoisyphase,256,250,256,param.fs,'yaxis');
set(gca,'fontname','Times new roman','fontsize',10);
xlabel({'(c)'},'FontWeight','normal')
ylabel('Frequency (Hz) ','FontWeight','normal')
title({['PESQ = ',num2str(PESQ.Stannoisyphase,'%.2f'),'  SDR = ',num2str(SDR.Stannoisyphase,'%.2f')];['STOI = ',num2str(STOI.Stannoisyphase,'%.2f'),'  SSNR = ',num2str(SSNR.Stannoisyphase,'%.2f')]},'FontWeight','normal');


subplot(335),spectrogram(enspeech.noisyphase,256,250,256,param.fs,'yaxis');
set(gca,'fontname','Times new roman','fontsize',10);
xlabel({'(d)'},'FontWeight','normal')
ylabel({})
title({['PESQ = ',num2str(PESQ.noisyphase,'%.2f'),'  SDR = ',num2str(SDR.noisyphase,'%.2f')];['STOI = ',num2str(STOI.noisyphase,'%.2f'),'  SSNR = ',num2str(SSNR.noisyphase,'%.2f')]},'FontWeight','normal');



subplot(337),spectrogram(enspeech.noisyphase,256,250,256,param.fs,'yaxis');
set(gca,'fontname','Times new roman','fontsize',10);
xlabel({'Time (s)';'(e)'},'FontWeight','normal')
ylabel('Frequency (Hz) ','FontWeight','normal')
title({['PESQ = ',num2str(PESQ.proposedPSC,'%.2f'),'  SDR = ',num2str(SDR.proposedPSC,'%.2f')];['STOI = ',num2str(STOI.proposedPSC,'%.2f'),'  SSNR = ',num2str(SSNR.proposedPSC,'%.2f')]},'FontWeight','normal');


subplot(338),spectrogram(enspeech.proposedPSF,256,250,256,param.fs,'yaxis');
set(gca,'fontname','Times new roman','fontsize',10);
xlabel({'Time (s)';'(f)'},'FontWeight','normal')
ylabel({})
title({['PESQ = ',num2str(PESQ.proposedPSF,'%.2f'),'  SDR = ',num2str(SDR.proposedPSF,'%.2f')];['STOI = ',num2str(STOI.proposedPSF,'%.2f'),'  SSNR = ',num2str(SSNR.proposedPSF,'%.2f')]},'FontWeight','normal');


subplot(339),spectrogram(enspeech.speechphase,256,250,256,param.fs,'yaxis');
set(gca,'fontname','Times new roman','fontsize',10);
xlabel({'Time (s)';'(g)'},'FontWeight','normal')
ylabel({})
title({['PESQ = ',num2str(PESQ.speechphase,'%.2f'),'  SDR = ',num2str(SDR.speechphase,'%.2f')];['STOI = ',num2str(STOI.speechphase,'%.2f'),'  SSNR = ',num2str(SSNR.speechphase,'%.2f')]},'FontWeight','normal');

% % %%
% % sound(waves.speech,param.fs)
% % sound(waves.noisy,param.fs)
% % sound(enspeech.Stannoisyphase,param.fs)
% % sound(enspeech.noisyphase,param.fs)
% % sound(enspeech.proposedPSC,param.fs)
% % sound(enspeech.proposedPSF,param.fs)
% % sound(enspeech.speechphase,param.fs)
% %% ������Ƶ
% if param.snr_pre==0 && strcmp(windowshape,'factory1.wav')
% disp('Save file');
% wavwrite(waves.speech,param.fs,16,'data\\Graph\\speech.wav');
% wavwrite(waves.noisy,param.fs,16,'data\\Graph\\noisy.wav');
% wavwrite(enspeech.Stannoisyphase,param.fs,16,'data\\Graph\\Stannoisyphase.wav');
% wavwrite(enspeech.noisyphase,param.fs,16,'data\\Graph\\noisyphase.wav');
% wavwrite(enspeech.proposedPSC,param.fs,16,'data\\Graph\\proposedPSC.wav');
% wavwrite(enspeech.proposedPSF,param.fs,16,'data\\Graph\\proposedPSF.wav');
% wavwrite(enspeech.speechphase,param.fs,16,'data\\Graph\\speechphase.wav');
% else 
%     break;
% end
% 

%% ������Ƶ
if param.snr_pre==0 && strcmp(windowshape,'hamming')
disp('Save file');
wavwrite(waves.speech,param.fs,16,'data\\Audio\\Clean.wav');
wavwrite(waves.noisy,param.fs,16,'data\\Audio\\Noisy.wav');
wavwrite(enspeech.Stannoisyphase,param.fs,16,'data\\Audio\\NMF.wav');
wavwrite(enspeech.noisyphase,param.fs,16,'data\\Audio\\NMF(Proposed).wav');
wavwrite(enspeech.proposedPSC,param.fs,16,'data\\Audio\\NMF(Proposed)+PSC.wav');
wavwrite(enspeech.proposedPSF,param.fs,16,'data\\Audio\\NMF(Proposed)+PSF.wav');
wavwrite(enspeech.speechphase,param.fs,16,'data\\Audio\\NMF(Proposed)+Clean Phase.wav');
else 
    break;
end