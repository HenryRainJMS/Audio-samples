function [W,H,errs]=nmf_spp0(V,r,varargin)
[m,n]=size(V);
% process arguments
[beta,niter,thresh,myeps]=parse_opt(varargin, 'beta', [], 'niter', 2000, 'thresh', [],'myeps', 1e-20);
%限定迭代次数或叫降维要r需要小于m和n
if r>=ceil((m*n)/(m+n))
    error(message('please enter the correct of r'));
end
%初始化W,H
W0=abs(rand(m,r))+rand(m,r);
H=abs(rand(r,n))+rand(r,n);
load('data/PH1.mat');
%计算矩阵值
B=sum(V(:));
% initial reconstruction
R = W0*H;
%定义误差矩阵
p=1.2;
lambda=(norm(V)^2)/(r^(1-p/2))*10^-5;
errs= zeros(niter,1);
for t=1:niter
    %update W
    W = W0 .* ( ((R.^(beta-2) .* V)*H') ./ max(R.^(beta-1)*H', myeps) );
   
%     if beta==1
%          W = W0 .* ( ((R.^(beta-2) .* V)*H'++lambda*W0*(ones(r,r)./(W0'*W0))) ./ max(R.^(beta-1)*H'+lambda*W0*ones(r,r), myeps) );
%     else
%         W = W0 .* ( ((R.^(beta-2) .* V)*H'+2*lambda*W0) ./ max(R.^(beta-1)*H'+2*lambda*W0*W0'*W0, myeps) );
%     end
    
    % update reconstruction
    R = W*H;
    % update H
    H = H .* ( (W'*(R.^(beta-2) .* V)) ./ max(W'*R.^(beta-1)+lambda*p*H.^(p-2), myeps) );
    %combining statistical model and NMF with update of speech and noise bases
    for k=1:n
        P=PH1(:,k)*ones(1,r);
        W0=(1-P).*W0+W;
    end
    % update reconstruction
    R = W0*H;
        % compute beta-divergence
    switch beta
        case 0
            errs(t) = sum(V(:)./R(:) - log(V(:)./R(:)) - 1)/B;     
            fprintf('NMF IS: iteration %d of %d, approximation error = %f\n',t, niter, errs(t));
        case 1
            errs(t) = sum(V(:).*log(V(:)./R(:)) - V(:) + R(:))/B;
            fprintf('NMF KL: iteration %d of %d, approximation error = %f\n',t, niter, errs(t));
        case 2
            errs(t) = sum(sum((V-R).^2))/B;
            fprintf('NMF EUC: iteration %d of %d, approximation error = %f\n',t, niter, errs(t));
        otherwise
            errs(t) = (sum(V(:).^beta + (beta-1)*R(:).^beta - beta*V(:).*R(:).^(beta-1)) / ...
                      (beta*(beta-1)))/B;
            fprintf('NMF beta=%f: iteration %d of %d, approximation error = %f\n',beta,t, niter, errs(t));
    end
    if ~isempty(thresh)
        if t > 2
            if (errs(t-1)-errs(t))/(errs(1)-errs(t-1)) < thresh
                break;
            end
        end
    end
end
errs = errs(1:t);