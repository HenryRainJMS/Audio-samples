function A=psc(Magout,lambda)
%lambda经验常量lambda=3.74
[m,n]=size(Magout);
for k=1:m
    if k/m>0&&k/m<0.5
        Psi(k)=1;
    elseif k/m>0.5&&k/m<1
        Psi(k)=-1;
    else
        Psi(k)=0;
    end
end
for t=1:n
    A(:,t)=lambda*Psi;
end

