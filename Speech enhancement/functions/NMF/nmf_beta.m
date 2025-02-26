function [W,H,errs]=nmf_beta(V,r,varargin)
[m,n]=size(V);
% process arguments
[beta,niter,thresh,myeps]=parse_opt(varargin, 'beta', [], 'niter', 2000, 'thresh', [],'myeps', 1e-20);
%限定迭代次数或叫降维要r需要小于m和n
if r>=ceil((m*n)/(m+n))
    error(message('please enter the correct of r'));
end
%初始化W,H
W=abs(rand(m,r));
H=abs(rand(r,n));
%计算矩阵值
B=sum(V(:));
% initial reconstruction
R = W*H;
%定义误差矩阵
p=1.2;
alpha=(norm(V)^2)/(r^(1-p/2))*10^-5;
errs= zeros(niter,1);
for t=1:niter
    %update W
    W = W .* ( ((R.^(beta-2) .* V)*H') ./ max(R.^(beta-1)*H', myeps) );
    % update reconstruction
    R = W*H;
    % update H
    H = H .* ( (W'*(R.^(beta-2) .* V)) ./ max(W'*R.^(beta-1)+alpha*p*H.^(p-2), myeps) );
    % update reconstruction
    R = W*H;
        % compute beta-divergence
    switch beta
        case 0
            errs(t) = sum(V(:)./R(:) - log(V(:)./R(:)) - 1)/B;     
            fprintf('Standard NMF IS: iteration %d of %d, approximation error = %f\n',t, niter, errs(t));
        case 1
            errs(t) = sum(V(:).*log(V(:)./R(:)) - V(:) + R(:))/B;
            fprintf('Standard NMF KL: iteration %d of %d, approximation error = %f\n',t, niter, errs(t));
        case 2
            errs(t) = sum(sum((V-W*H).^2))/B;
            fprintf('Standard NMF EUC: iteration %d of %d, approximation error = %f\n',t, niter, errs(t));
        otherwise
            errs(t) = (sum(V(:).^beta + (beta-1)*R(:).^beta - beta*V(:).*R(:).^(beta-1)) / ...
                      (beta*(beta-1)))/B;
            fprintf('Standard NMF beta=%f: iteration %d of %d, approximation error = %f\n',beta,t, niter, errs(t));
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