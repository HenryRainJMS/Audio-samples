function [ResMag,errs]=standard_training_H(W,Rank,Spec,beta,niter)
Mag.noisy=abs(Spec.noisy);%带噪幅度谱
V=Mag.noisy;
n=size(V,2);
%初始化
H=abs(rand(Rank.noisy,n))+ones(Rank.noisy,n);
%设置收敛参数
myeps=1e-20;
thresh=[];
%计算矩阵值
B=sum(V(:));
for t=1:niter
    % update reconstruction
    R = W*H;
    % update H
    H = H .* ( (W'*(R.^(beta-2) .* V)) ./ max(W'*R.^(beta-1), myeps) );
    % update reconstruction
    R = W*H;
        % compute beta-divergence
    switch beta
        case 0
            errs(t) = sum(V(:)./R(:) - log(V(:)./R(:)) - 1)/B;     
            fprintf('Enhanced Standard NMF IS: iteration %d of %d, approximation error = %f\n',t, niter, errs(t));
        case 1
            errs(t) = sum(V(:).*log(V(:)./R(:)) - V(:) + R(:))/B;
            fprintf('Enhanced Standard NMF KL: iteration %d of %d, approximation error = %f\n',t, niter, errs(t));
        case 2
            errs(t) = sum(sum((V-W*H).^2))/B;
            fprintf('Enhanced Standard NMF EUC: iteration %d of %d, approximation error = %f\n',t, niter, errs(t));
        otherwise
            errs(t) = (sum(V(:).^beta + (beta-1)*R(:).^beta - beta*V(:).*R(:).^(beta-1)) / ...
                      (beta*(beta-1)))/B;
            fprintf('Enhanced Standard NMF beta=%f: iteration %d of %d, approximation error = %f\n',beta,t, niter, errs(t));
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
%% 维纳滤波
Vs=W(:,1:Rank.speech)*H(1:Rank.speech,:);
Vn=W(:,Rank.speech+1:end)*H(Rank.speech+1:end,:);
ResMag.noisy=W*H;
%增益
Gs=Vs./ResMag.noisy;
Gn=Vn./ResMag.noisy;
%output 
ResMag.speech=(Gs.*V);
ResMag.noise=(Gn.*V);
