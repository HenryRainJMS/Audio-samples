%% Consistency kernel alpha as defined in [Le Roux, 2009]
%  Paul Magron, march 2014.
% 
% Inputs :
%     P : number of frequency bins is 2*P-1
%     Q : number of time frames is 2*Q-1
%     w : analysis and synthesis window
% 
% Output :
%     alpha : consistency kernel alpha (2*P-1)*(2*Q-1) matrix

function [alpha] = consistency_kernel(P,Q,w)

Nw = length(w);
shift = Nw/Q;
Nfft = Nw;

p = (1-P):(P-1);
q = (1-Q):(Q-1);

% Basis matrix
U = zeros(Nfft/2+1,2*Q-1);
U(1,Q) = 1;

V = STFT(iSTFT(U,Nfft,w,shift),Nfft,w,shift)-U;
V = [ conj(V(P:-1:2,:)) ; V(1:P,:)];

alpha = V .* exp(-1i*2*pi*shift*p'*q/Nw) ;

% Plot the kernel
% cmp = colormap('Gray');
% cmp = cmp(end:-1:1,:);
% colormap(cmp);
% imagesc(q,p,abs(alpha)); axis xy; colorbar;
% title('Consistency kernel amplitude') ; xlabel('frame'); ylabel('frequency bin');

end