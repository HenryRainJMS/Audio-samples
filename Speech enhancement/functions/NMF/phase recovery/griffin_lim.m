%  Phase reconstruction algorithm based on [Griffin and Lim 1984]
%  Paul Magron, december 2013.
% 
% Inputs :
%     X : complex matrix data to be modified
%     w : analysis and synthesis window
%     hop : temporal shift between 2 frames (number of samples)
%     n_iter : number of iterations
%     P_cons : number of frequency bins for consistency is 2*P_cons-1
% 
% Output :
%     x : estimated temporal signal
%     err : square error between V and |X| at iteration i
%     icons : inconsistency criterion

function [x,err,icons] = griffin_lim(X,w,hop,n_iter,P_cons)

if nargin<5
    P_cons = -1;
end

Nfft = (size(X,1)-1)*2;
V = abs(X);
err = zeros(1,n_iter);

if P_cons>0
    icons = zeros(1,n_iter+1);
    icons(1) = inconsistency(X,w,hop,P_cons);
end

% Initialization
x = iSTFT(X, Nfft, w, hop)';

% G&L algorithm
for it=1:n_iter
    X = STFT(x, Nfft, w, hop);
    modX = abs(X)+eps;
    X = V.*X./modX;
    x = iSTFT(X, Nfft, w, hop)';
    err(it) = norm(V-modX);
    
    if P_cons>0
        icons(it+1) = inconsistency(X,w,hop,P_cons);
    end
end

end