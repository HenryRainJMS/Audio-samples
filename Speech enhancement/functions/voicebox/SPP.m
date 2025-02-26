function PH1=SPP(noisy,frame_len, nfft,step, windowshape,SNR)
Spec_noisy=stft(noisy,frame_len,step,nfft,windowshape);
speech_power=abs(Spec_noisy).^2;
%The computes an initial noise psd estimate it is assumed that the first 5 time-frame are   absence  of speech
speechPow=init_noise_tracker_ideal_vad(noisy,frame_len,nfft,step,windowshape);
%初始化局部信噪比
snrpost(:,1)=speech_power(:,1)./speechPow;
for k=2:size(Spec_noisy,2)
    snrpost(:,k)=speech_power(:,k)./speech_power(:,k-1);
end
%
PH1mean  = 0.5; % the initial of spp
alphaPH1mean = 0.9;%the smooth of the possibility

%constants for a posteriori SPP
q= 0.5; % a priori probability of speech presence:
priorFact  = q./(1-q);
xiOptDb= SNR; % optimal fixed a priori SNR for SPP estimation ，This is 15dB
xiOpt= 10.^(xiOptDb./10);
logGLRFact = log(1./(1+xiOpt));
GLRexp     = xiOpt./(1+xiOpt);

%solve the problem of the spp
GLR     = priorFact .* exp(min(logGLRFact + GLRexp.*snrpost,200));
PH1     = GLR./(1+GLR); % a posteriori speech presence probability
%To avoid a stagnation of the speech power update due to an underestimated noise power
%by using the recursively smooth the possiblily
PH1mean  = alphaPH1mean * PH1mean + (1-alphaPH1mean) * PH1;
stuckInd = PH1mean > 0.99;
PH1(stuckInd) = min(PH1(stuckInd),0.99);


function   noise_psd_init =init_noise_tracker_ideal_vad(noisy,fr_size,fft_size,hop,window_case)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%This m-file computes an initial noise PSD estimate by means of a
%%%%Bartlett estimate.
%%%%Input parameters:   noisy:          noisy signal
%%%%                    fr_size:        frame size
%%%%                    fft_size:       fft size
%%%%                    hop:            hop size of frame
%%%%                    sq_hann_window: analysis window
%%%%Output parameters:  noise_psd_init: initial noise PSD estimate
%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%Author: Richard C. Hendriks, 15/4/2010
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%
 if strcmp(window_case,'hamming')
    window_type=hamming(fft_size);
elseif strcmp(window_case,'hann')
    window_type=hann(fft_size);    
elseif strcmp(window_case,'kaiser')
    window_type=kaiser(fft_size,1.8);        
elseif strcmp(window_case,'blackman')
        window_type=blackman(fft_size);
elseif strcmp(window_case,'rect')
    window_type=ones(1,fft_size)';
elseif strcmp(window_case,'chebwin')
    window_type=chebwin(fft_size,40);
end
for I=1:5
    noisy_frame=window_type.*noisy((I-1)*hop+1:(I-1)*hop+fr_size);
    noisy_dft_frame_matrix(:,I)=fft(noisy_frame,fft_size);
end
noise_psd_init=mean(abs(noisy_dft_frame_matrix(1:fr_size/2+1,1:end)).^2,2);%%%compute the initialisation of the noise tracking algorithms.
return
