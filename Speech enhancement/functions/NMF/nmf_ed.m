function [W,H,errs]=nmf_ed(V,r,vout,iter_num)
%��׼KLɢ���µ�NMF
%r�ǵ�������Ҳ�Ǿ���ֽ�W������
%�������V����������
%kkΪ����������
[m,n]=size(V);
%�޶�����������н�άҪr��ҪС��m��n
if r>=ceil((m*n)/(m+n))
    error(message('please enter the correct of r'));
end
%��ʼ��W,H
W=abs(rand(m,r));
H=abs(rand(r,n));
%������������
myeps=1e-20;
thresh=[];
%�������ֵ
B=sum(V(:));
%����������
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