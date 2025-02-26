function x = iframing(x_framed,windowsize,shift)
[N,L] = size(x_framed);% Get length of file, number of microphones and signals
x = zeros(L*shift + windowsize,1); % Initialize time domain signal
for l=1:L % For each frame
    seg=(l-1)*shift + 1:(l-1)*shift + 1 + windowsize - 1;
    % Overlap and add
    x(seg) = x(seg) + x_framed(:,l);
end
% Squeeze empty dimensions
x = squeeze(x);
