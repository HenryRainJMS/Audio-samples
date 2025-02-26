function [W,H,errs]=nmf_ed(V,r,vout,iter_num)
%±ê×¼KLÉ¢¶ÈÏÂµÄNMF
%rÊÇµü´ú´ÎÊıÒ²ÊÇ¾ØÕó·Ö½âWµÄÁĞÊı
%¼ÆËã¾ØÕóVĞĞÊıºÍÁĞÊı
%kkÎª×î´óµü´ú´ÎÊı
[m,n]=size(V);
%ÏŞ¶¨µü´ú´ÎÊı»ò½Ğ½µÎ¬ÒªrĞèÒªĞ¡ÓÚmºÍn
if r>=ceil((m*n)/(m+n))
    error(message('please enter the correct of r'));
end
%³õÊ¼»¯W,H
W=abs(rand(m,r));
H=abs(rand(r,n));
%ÉèÖÃÊÕÁ²²ÎÊı
myeps=1e-20;
thresh=[];
%¼ÆËã¾ØÕóÖµ
B=sum(V(:));
%¶¨ÒåÎó²î¾ØÕó
errs= zeros(iter_num,1);
% lambda=0.5;
for iter=1:iter_num
    %update W
    W = W .* ( (V*H') ./ max(W*(H*H'), myeps) );
%     W = W .* ( (V*H'+2*lambda*W) ./ max(W*(H*H')+2*lambda*W*W'*W, myeps) );
    %update H
    H = H .* ( (W'*V) ./ max((W'*W)*H, myeps) );
    % compute squared error
    errs(iter) = sum(sum((V-W*H).^2))/B;
    %
    if vout==1
    fprintf('speech NMF_ED: iteration %d of %d, approximation error = %f\n', iter, iter_num, errs(iter));
    else
    fprintf('noise NMF_ED: iteration %d of %d, approximation error = %f\n', iter, iter_num, errs(iter));  
    end % check for convergence if asked
    if ~isempty(thresh)
        if iter > 2
            if (errs(iter-1)-errs(iter))/(errs(1)-errs(iter-1)) < thresh
                break;
            end
        end
    end  
end
errs = errs(1:iter);