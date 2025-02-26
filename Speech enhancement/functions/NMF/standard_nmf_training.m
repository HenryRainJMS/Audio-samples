function [W]=standard_nmf_training(Rank,Spec,beta,iter_num)
%% NMF
%��������ѵ��%����ѵ��
Mag.speech=abs(Spec.speech);
Mag.noise=abs(Spec.noise);

%%
[Ws,Hs]=nmf_spp(Mag.speech,Rank.speech,'beta',beta,'niter',iter_num);
[Wn,Hn]=nmf_spp0(Mag.noise,Rank.noise,'beta',beta,'niter',iter_num);
%%�������������Ͼ���
W=[Ws Wn];