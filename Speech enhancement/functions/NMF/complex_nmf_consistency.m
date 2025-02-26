%  Implementation of the "Complex NMF" algorithm with consistency
%  constraints as defined in [Le Roux et al. 2009]
%  Paul Magron, Feb. 2014.
% 
% Inputs :
%     Y : observed complex matrix F*T
%     W_ini : initial feature matrix F*R
%     H_ini : initial activation matrix R*T
%     phase_ini : initial phase
%     n_iter : number of iterations
%     w : STFT window
%     hop : hop size
%     gamma : inconsistency weight (0: no inconsistency influence)
% 
% Outputs :
%     W : feature matrix
%     H : activation matrix
%     phi : K phase fields
%     C : complex components
%     cost : cost vector

function [W,H,phi,C,cost] = complex_nmf_consistency(Y,W_ini,H_ini,phase_ini,n_iter,w,hop,gamma)

K = size(W_ini,2);
p = 1.2;
lambda = (norm(Y)^2)/(K^(1-p/2))*10^-5;
[F,T] = size(Y);
Nfft = 2*(F-1);

%% initialization

W = W_ini;
H = H_ini;
C = zeros(F,T,K);
phi = zeros(F,T,K);
cost = zeros(3,n_iter+1);
cost_inc = 0;

for k=1:K
    phi(:,:,k) = phase_ini(:,:,k);
    C(:,:,k) = W(:,k)*H(k,:) .* exp(1i*phi(:,:,k));
    cost_inc = cost_inc + inconsistency_def(C(:,:,k),Nfft,w,hop)/norm(C(:,:,k))^2;
    scale = sum(W(:,k));
    W(:,k) = W(:,k) / scale;
    H(k,:) = H(k,:) * scale;
end

X = sum(C,3);
V = sum(abs(C),3);

cost(:,1) = [norm(Y-X)^2 ; 2*lambda*sum(sum(abs(H).^p)) ; gamma*cost_inc] ;

%% iteration

for iteration=1:n_iter
    
    for k=1:K
        
        % Wiener gain
        beta = (abs(C(:,:,k)) + eps) ./ (V + eps);
        
        % Auxiliary variable
        C_hat = C(:,:,k) + beta .* (Y-X);
        H_barr = H(k,:)+eps ;
        C_barr = STFT(iSTFT(C(:,:,k), Nfft, w, hop), Nfft, w, hop) ;
        
        C_aux = C_hat ./ beta + gamma* C_barr ;
        
        % compute phase
        phi(:,:,k) = angle(C_aux);
        
        % compute W
        W(:,k) = ( abs(C_aux) * H(k,:)' ) ./ ( (1./ beta + gamma) * (abs(H(k,:)').^2 ));

        % compute H
        H(k,:) = ( (W(:,k)') * abs(C_aux)) ./ ( (abs(W(:,k)').^2 ) * (1./ beta + gamma) + lambda*p* abs(H_barr).^(p-2));
    end
    
    cost_inc = 0;
    for k=1:K
        C(:,:,k) = W(:,k)*H(k,:) .* exp(1i*phi(:,:,k));
        cost_inc = cost_inc + inconsistency_def(C(:,:,k),Nfft,w,hop)/norm(C(:,:,k))^2;
    end    
    
    X = sum(C,3);
    V = sum(abs(C),3);
    
    cost(:,iteration+1) = [norm(Y-X)^2 ; 2*lambda*sum(sum(abs(H).^p)) ; gamma*cost_inc] ;
end

% normalize to avoid scaling problem
sumW = sum(W);
W = W * diag(1./sumW);
H = diag(sumW) * H;

end