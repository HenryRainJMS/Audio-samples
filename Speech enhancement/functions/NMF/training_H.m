function [ResMag,errs]=training_H(W,Rank,Spec,beta,niter)
Mag.noisy=abs(Spec.noisy);%´øÔë·ù¶ÈÆ×
V=Mag.noisy;
n=size(V,2);
%³õÊ¼»¯
H=abs(rand(Rank.noisy,n))+rand(Rank.noisy,n);
%ÉèÖÃÊÕÁ²²ÎÊı
myeps=1e-20;
thresh=[];
%¼ÆËã¾ØÕóÖµ
B=sum(V(:));
%¶¨ÒåÎó²î¾ØÕó
r=Rank.noisy;
p=1.2;
alpha=(norm(V)^2)/(r^(1-p/2))*10^-5;
errs= zeros(niter,1);
for t=1:niter
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
            fprintf('Enhanced NMF IS: iteration %d of %d, approximation error = %f\n',t, niter, errs(t));
        case 1
            errs(t) = sum(V(:).*log(V(:)./R(:)) - V(:) + R(:))/B;
            fprintf('Enhanced NMF KL: iteration %d of %d, approximation error = %f\n',t, niter, errs(t));
        case 2
            errs(t) = sum(sum((V-W*H).^2))/B;
            fprintf('Enhanced NMF EUC: iteration %d of %d, approximation error = %f\n',t, niter, errs(t));
        otherwise
            errs(t) = (sum(V(:).^beta + (beta-1)*R(:).^beta - beta*V(:).*R(:).^(beta-1)) / ...
                      (beta*(beta-1)))/B;
            fprintf('Enhanced NMF beta=%f: iteration %d of %d, approximation error = %f\n',beta,t, niter, errs(t));
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
%% Î¬ÄÉÂË²¨
Vs=W(:,1:Rank.speech)*H(1:Rank.speech,:);
Vn=W(:,Rank.speech+1:end)*H(Rank.speech+1:end,:);
ResMag.noisy=W*H;
%ÔöÒæ
Gs=Vs./ResMag.noisy;
Gn=Vn./ResMag.noisy;
%output 
ResMag.speech=(Gs.*V);
ResMag.noise=(Gn.*V);
