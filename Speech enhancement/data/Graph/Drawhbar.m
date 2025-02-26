clc;clear all;close all;
%¶ÁÈ¡Êý¾Ý
%%Factory1
PESQ=[1.2398	1.2751	1.5625	1.9223;
              1.9144	2.5104	2.7522	2.9023;
              1.6233	2.1976	2.4980	2.6016;
              1.8071	2.2579	2.6048	2.7974;
              1.7587	2.3291	2.5616	2.6670]'; 
          
STOI=[0.4921	0.6305	0.7758	0.8857;
            0.7974	0.8969	0.9426	0.9716;
            0.7576	0.8584	0.9200	0.9567;
            0.7175	0.8140	0.8856	0.9385;
            0.7457	0.8557	0.9193	0.9566]'; 
        
SDR=[-8.3715	-4.2561	0.3880	5.2493;
             6.7019	10.5158	13.2710	16.5908;
             2.4608	6.0578	9.2994	12.5666;
             0.3180	3.9257	7.8781	11.5030;
            3.2326	6.8946	9.7796	12.9221]';
        
SSNR=[-8.7994	-6.2761	-2.9760	0.6774;
               2.9708	4.7405	5.6022	5.6443;
               0.0465	1.2630	2.8875	3.6826;
               0.2900	1.7077	3.4317	4.4193;
               1.5511	3.2225	4.2063	4.5133]';
           
%%Hfchannel 
% PESQ=[]';
% SDR=[]';
% SSNR=[]';
%%           
figure,
subplot(221)
bar(PESQ,'hist');hold on
set(gca,'XTickLabel',{'-10','-5','0','5'}) ;
set(gca,'fontname','Times new roman','fontsize',10);
xlabel({'SNR/dB';'(a)'},'FontSize',10,'FontWeight','normal');
ylabel('PESQ','FontSize',10,'FontWeight','normal');

axis([0.5 4.5 0 3]);
set(gca,'ygrid','on');

subplot(222)
bar(STOI,'hist');hold on
set(gca,'XTickLabel',{'-10','-5','0','5'}) ;
set(gca,'fontname','Times new roman','fontsize',10);
xlabel({'SNR/dB';'(b)'},'FontSize',10,'FontWeight','normal');
ylabel('STOI','FontSize',10,'FontWeight','normal');
axis([0.5 4.5 0 1]);
set(gca,'ygrid','on');

subplot(223)
bar(SDR,'hist');hold on
set(gca,'XTickLabel',{'-10','-5','0','5'}) ;
set(gca,'fontname','Times new roman','fontsize',10);
xlabel({'SNR/dB';'(c)'},'FontSize',10,'FontWeight','normal');
ylabel('SDR','FontSize',10,'FontWeight','normal');
axis([0.5 4.5 -10 18]);
set(gca,'ygrid','on');

subplot(224)
bar(SSNR,'hist');hold on
set(gca,'XTickLabel',{'-10','-5','0','5'}) ;
set(gca,'fontname','Times new roman','fontsize',10);
xlabel({'SNR/dB';'(d)'},'FontSize',10,'FontWeight','normal');
ylabel('SSNR','FontSize',10,'FontWeight','normal');
axis([0.5 4.5 -10 6]);
set(gca,'ygrid','on');
legend('Noisy','speechphase','noisyphase','proposedPSC','proposedPSF','orientation','horizotal','location','best');

