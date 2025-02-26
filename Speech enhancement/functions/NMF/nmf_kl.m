function [W,H,errs]=nmf_kl(V,r,vout,iter_num)
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
Onm=ones(m,n);
R=W*H;
for iter=1:iter_num
    %update W
    W = W .* ( ((V./R)*H') ./ max(Onm*H',myeps) );
    % update reconstruction
    R = W*H;
    %update H
    H = H .* ( (W'*(V./R)) ./ max(W'*Onm,myeps) );
    % update reconstruction
    R = W*H;
    % compute I-divergence
    errs(iter) = sum(V(:).*log(V(:)./R(:)) - V(:) + R(:))/B;
    %
    if vout==1
    fprintf('speech NMF_KL: iteration %d of %d, approximation error = %f\n', iter, iter_num, errs(iter));
    else
    fprintf('noise NMF_KL: iteration %d of %d, approximation error = %f\n', iter, iter_num, errs(iter));  
    end 
    % check for convergence if asked
    if ~isempty(thresh)
        if t > 2
            if (errs(t-1)-errs(t))/(errs(1)-errs(t-1)) < thresh
                break;
            end
        end
    end
end
errs = errs(1:iter);