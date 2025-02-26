function x = istft(X,windowsize,shift,nfft)
[K L ] = size(X);% Get windowsize, number of frames, number of microphones and signals
% For each signal and microphone
X_tmp             = [ X ; conj(flipud(X(2:K-1,:)))];        % Complete complex conjugate part
tmp_framed        = real(ifft(X_tmp,nfft));% IDFT
x_framed = tmp_framed(1:windowsize,:);% zero padding

x_framed = x_framed .* repmat(hamming(windowsize), [1, size(x_framed,2)]);% Apply window function
x = iframing(x_framed,windowsize,shift);% Compute inverse framing
