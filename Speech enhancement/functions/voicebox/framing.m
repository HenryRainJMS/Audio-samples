function x_framed = framing(x,windowsize,shift)
% Get length of file, number of microphones and signals
T = length(x);
% Compute corresponding number of frames
L = fix((T-windowsize)/shift) + 1;           % Number of frames. Must satisfy (L-1)*(shift) + windowsize &lt; T
% Alternative T/shift - 1
% Now we create index for each window by cloning the index for the first
% window N times and adding the offset for each window.
Index    = (repmat(1:windowsize,L,1) + repmat((0:(L-1))'*(shift),1,windowsize))';
% COMPUTE FRAMES
% For all microphone signals
dummy_var  = x;
tmp_framed = dummy_var(Index);        % FRAMING MATRIX
x_framed = tmp_framed;                %WINDOWING
x_framed = squeeze(x_framed);