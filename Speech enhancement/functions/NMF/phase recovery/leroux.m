%  Phase reconstruction algorithm based on [Le Roux, 2004]
%  Paul Magron, march 2014.
% 
% Inputs :
%     X : complex valued matrix to be modified
%     w : analysis and synthesis window
%     hop : temporal shift between 2 frames (number of samples)
%     P : number of frequency bins is 2*P-1
%     n_iter : number of iterations
% 
% Output :
%     x : estimated temporal signal
%     icons : inconsistency criterion

function [x,icons] = leroux(X,w,hop,P,n_iter)

%% Initialization

icons = zeros(1,n_iter+1);
V = abs(X);
[F,T] = size(V);

%% Consistency kernel

Nfft = (F-1)*2;
Nw = length(w);
Q = Nw/hop;
alpha = consistency_kernel(P,Q,w);

%% Algo

z = zeros(F,Q-1);

for k=1:n_iter
    
    X_aux =[ z X z];
    X_aux = [ conj(X_aux(P:-1:2,:)) ; X_aux ; conj(X_aux((end-1):-1:(end-(P-1)),:)) ];
    I = zeros(F,T);
    
    % Calculate inconsistency
    for q=-(Q-1):(Q-1)
        Iq = conv2(circshift(X_aux,[0 q]),alpha(:,q+Q),'same');
        Iq = Iq(P:(end-(P-1)),Q:(end-(Q-1)));
    
        expo = repmat(exp(1i*2*pi*(0:(F-1))'*q/Q),1,T);
        I = I + Iq .* expo;
    end
    
    icons(k) = norm(I)^2;
    
    % Update phase
    phase = angle((1-1/Q)*X + I);
    X = V.* exp(1i*phase);
end

icons(end) = inconsistency(X,w,hop,P);

x = iSTFT(X, Nfft, w, hop);

end