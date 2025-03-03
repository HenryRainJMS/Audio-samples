function [W,H,errs]=nmf_ed(V,r,vout,iter_num)
%标准KL散度下的NMF
%r是迭代次数也是矩阵分解W的列数
%计算矩阵V行数和列数
%kk为最大迭代次数
[m,n]=size(V);
%限定迭代次数或叫降维要r需要小于m和n
if r>=ceil((m*n)/(m+n))
    error(message('please enter the correct of r'));
end
%初始化W,H
W=abs(rand(m,r));
H=abs(rand(r,n));
%设置收敛参数
myeps=1e-20;
thresh=[];
%计算矩阵值
B=sum(V(:));
%定义误差矩阵
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