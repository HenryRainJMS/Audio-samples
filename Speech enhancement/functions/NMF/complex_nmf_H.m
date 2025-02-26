%  Implementation of the "Complex NMF" algorithm  as defined in [Kameoka 2009]
%  Paul Magron, Feb. 2014.
% 
% Inputs :
%     Y : observed complex matrix F*T
%     W_ini : initial feature matrix F*R
%     H_ini : initial activation matrix R*T
%     phase_ini : initial phase
%     n_iter : number of iterations
% 
% Outputs :
%     W : feature matrix
%     H : activation matrix
%     phi : K phase fields
%     C : complex components
%     cost : cost function over iterations

function [ResMag,cost] = complex_nmf_H(Y,W_ini,H_ini,phase_ini,n_iter)

K = size(W_ini,2);
p = 1.2;
lambda = (norm(Y)^2)/(K^(1-p/2))*10^-5;
[F,T] = size(Y);

%% initialization

W = W_ini;
H = H_ini;
C = zeros(F,T,K);
phi = zeros(F,T,K);
cost = zeros(2,n_iter+1);

for k=1:K
    phi(:,:,k) = phase_ini(:,:,k);
    C(:,:,k) = W(:,k)*H(k,:) .* exp(1i*phi(:,:,k));
    scale = sum(W(:,k));
    W(:,k) = W(:,k) / scale;
    H(k,:) = H(k,:) * scale;
end

X = sum(C,3);
V = sum(abs(C),3);

cost(:,1) = [norm(Y-X)^2 ; 2*lambda*sum(sum(abs(H).^p))] ;

%% iteration

for iteration=1:n_iter
    
    for k=1:K
        
        % Wiener gain
        beta = (abs(C(:,:,k)) + eps) ./ (V + eps);
        
        % Auxiliary variable
        C_hat = C(:,:,k) + beta .* (Y-X);
        H_barr = H(k,:)+eps ;
        
        C_aux = C_hat ./ beta ;
        
        % compute phase
        phi(:,:,k) = angle(C_aux);
        
        % compute W
%         W(:,k) = ( abs(C_aux) * H(k,:)' ) ./ ( (1./ beta) * (abs(H(k,:)').^2 ));

        % compute H
        H(k,:) = ( (W(:,k)') * abs(C_aux)) ./ ( (abs(W(:,k)').^2 ) * (1./ beta) + lambda*p* abs(H_barr).^(p-2));
    end
    
    for k=1:K
        C(:,:,k) = W(:,k)*H(k,:) .* exp(1i*phi(:,:,k));
    end    
    
    X = sum(C,3);
    V = sum(abs(C),3);
    
    cost(:,iteration+1) = [norm(Y-X)^2 ; 2*lambda*sum(sum(abs(H).^p))] ;
    disp(iteration)
end

% normalize to avoid scaling problem
sumW = sum(W);
W = W * diag(1./sumW);
H = diag(sumW) * H;
%% Î¬ÄÉÂË²¨
Vs=W(:,1:30)*H(1:30,:);
Vn=W(:,31:end)*H(31:end,:);
ResMag.noisy=W*H;
%ÔöÒæ
Gs=Vs./ResMag.noisy;
Gn=Vn./ResMag.noisy;
%output 
ResMag.speech=(Gs.*abs(Y));
ResMag.noise=(Gn.*abs(Y));
end


