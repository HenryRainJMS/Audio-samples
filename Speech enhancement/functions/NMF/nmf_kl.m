function [W,H,errs]=nmf_kl(V,r,vout,iter_num)
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