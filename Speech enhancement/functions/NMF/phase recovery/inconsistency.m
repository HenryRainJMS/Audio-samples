%% Inconsistency function as defined in [Le Roux, 2008]
%  Paul Magron, march 2014.
% 
% Inputs :
%     X : set of complex numbers
%     w : analysis/syntesis window
%     hop : temporal shift between 2 frames (number of samples)
%     P : number of frequency bins is 2*P-1
% 
% Output :
%     inc : inconsistency criterion
%     I : inconsistency maxtrix

function [inc,I] = inconsistency(X,w,hop,P)

Nw = length(w);
[F,T] = size(X);
I = zeros(F,T);
Q=Nw/hop;

% Consistency kernel
alpha = consistency_kernel(P,Q,w);

% Auxiliary set of complex number: avoid modulo wrp. frequency and side
% effect due to the time frames
z = zeros(F,Q-1);
X_aux =[ z X z];
X_aux = [ conj(X_aux(P:-1:2,:)) ; X_aux ; conj(X_aux((end-1):-1:(end-(P-1)),:)) ];

for q=-(Q-1):(Q-1)
    Iq = conv2(circshift(X_aux,[0 q]),alpha(:,q+Q),'same');
    Iq = Iq(P:(end-(P-1)),Q:(end-(Q-1)));
    
    expo = repmat(exp(1i*2*pi*(0:(F-1))'*q/Q),1,T);
    I = I + Iq .* expo;
end

% Inconsistency criterion
inc = norm(I)^2;

end