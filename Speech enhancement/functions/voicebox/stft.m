function X = stft(x,windowsize,shift,nfft,window_case)
x_framed = framing(x,windowsize,shift);% Get windowsize, number of frames, number of microphones and signals
[N, L] = size(x_framed);% FRAMED TIME DOMAIN SIGNAL PROCESSING
if strcmp(window_case,'hamming')
    window_type=hamming(windowsize);
elseif strcmp(window_case,'hann')
    window_type=hann(windowsize);    
elseif strcmp(window_case,'kaiser')
    window_type=kaiser(windowsize,1.8);        
elseif strcmp(window_case,'blackman')
        window_type=blackman(windowsize);
elseif strcmp(window_case,'rect')
    window_type=ones(1,windowsize)';
elseif strcmp(window_case,'chebwin')
    window_type=chebwin(windowsize,40);
end

x_framed = x_framed .* repmat(window_type,[1 size(x_framed,2)]);% Apply window function
X     = zeros(nfft/2+1,L);% Initialize STFT
% For each signal and microphone
X_tmp      = fft(x_framed,nfft);        % Compute DFT
X = X_tmp(1:nfft/2+1,:);        % Get inferior part of the spectrum
