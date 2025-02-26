clc;clear all;close all;
%读取数据
%% Factory1
PESQ=[1.2398	1.2751	1.5625	1.9223;
1.7574	2.1621	2.4326	2.6268;
1.7947	2.2372	2.4849	2.6780;
1.8705	2.2703	2.5857	2.9224;
1.9561	2.3543	2.5143	2.7015;
2.1042	2.5418	2.7695	2.9941]; 
          
STOI=[0.4921	0.6305	0.7758	0.8857;
0.7176	0.8501	0.9145	0.9541;
0.7530	0.8573	0.9185	0.9535;
0.6949	0.8137	0.8865	0.9356;
0.7271	0.8547	0.9208	0.9536;
0.8004	0.8955	0.9447	0.9687]; 
        
SDR=[-8.3715	-4.2561	0.3880	5.2493;
1.4293	5.3992	8.8474	12.2281;
2.5061	5.8600	9.2191	12.2777;
0.5557	3.9541	7.7957	11.3849;
3.4374	6.7331	9.8787	12.7097;
6.7649	10.4847	13.5420	16.3946];
        
SSNR=[-8.7994	-6.2761	-2.9760	0.6774;
-1.4660	0.1658	1.9333	2.8925;
0.1411	0.9678	2.5554	3.5541;
0.1944	1.4880	3.2977	4.3496;
1.4548	2.9982	4.1707	4.5387;
3.3536	4.7006	5.6541	5.8034];
%%  White
% PESQ=[1.2356	1.3468	1.5123	1.7226;
% 1.9106	2.2675	2.4755	2.5820;
% 2.0404	2.3405	2.5560	2.6094;
% 2.1151	2.3924	2.6943	2.8787;
% 2.2617	2.5358	2.7782	2.8252;
% 2.3323 2.6578 2.8835 2.9334];
% 
% STOI=[0.5240	0.6375	0.7557	0.8632;
% 0.8315	0.8945	0.9355	0.9601;
% 0.8185	0.9019	0.9399	0.9619;
% 0.7846	0.8703	0.9213	0.9518;
% 0.8070	0.9022	0.9427	0.9648;
% 0.8706 0.9422 0.9670	0.9788];
% 
% SDR=[-8.6255	-4.4676	 0.2532	 5.1755;
% 4.1022	 7.2813	10.1625	12.8924;
% 4.7011	 7.7071	10.3782	13.0317;
% 3.4441	 6.6494	 9.6339	12.5659;
% 5.4895	 8.5769	11.2060	13.7420;
% 8.7523 12.5254 15.2349 17.9198];
% 
% SSNR=[-8.7675	-6.2563	-3.0508	0.5020;
% -0.0615	 1.3066	 2.3475	2.9414;
% 0.8682	 1.9343	 2.9271	3.6192;
% 1.0596	 2.5832	 3.6840	4.0914;
% 2.3942	 3.6537	 4.3042	4.3368;
% 3.9881 5.4093 5.6448 5.5374];
%% 变化率
E=ones(5,1);
PESQ1=PESQ(2:end,:)-E*PESQ(1,:);
STOI1=STOI(2:end,:)-E*STOI(1,:);
SDR1=SDR(2:end,:)-E*SDR(1,:);    
SSNR1=SSNR(2:end,:)-E*SSNR(1,:);



% PESQ1=(PESQ(2:end,:)-E*PESQ(1,:))./(E*PESQ(1,:));
% STOI1=(STOI(2:end,:)-E*STOI(1,:))./(E*STOI(1,:));
% SDR1=(SDR(2:end,:)-E*SDR(1,:))./abs(E*SDR(1,:));    
% SSNR1=(SSNR(2:end,:)-E*SSNR(1,:))./abs(E*SSNR(1,:));
%% 绘图
%% 图片尺寸设置（单位：厘米）
figureUnits = 'centimeters';
figureWidth = 27;
figureHeight = 15;
%绘图
figureHandle = figure;
set(gcf, 'Units', figureUnits, 'Position', [0 0 figureWidth figureHeight]);
%%
subplot(221)
bar(PESQ1','hist');hold on
set(gca,'XTickLabel',{'-10','-5','0','5'}) ;
set(gca,'fontname','Times new roman','fontsize',10);
% ylabel(['\fontsize{10}\fontname{宋体}（a）']);
xlabel({'SNR/dB';['\fontsize{14}\fontname{Times new roman} (a)']},'FontSize',10,'FontWeight','normal');
ylabel('\Delta PESQ','FontSize',10,'FontWeight','normal');
axis([0.5 4.5 0 1.5]);
set(gca,'ygrid','on');


subplot(222)
bar(STOI1','hist');hold on
set(gca,'XTickLabel',{'-10','-5','0','5'}) ;
set(gca,'fontname','Times new roman','fontsize',10);
% xlabel({'SNR/dB';'(b)'},'FontSize',10,'FontWeight','normal');
xlabel({'SNR/dB';['\fontsize{14}\fontname{Times new roman} (b)']},'FontSize',10,'FontWeight','normal');
ylabel('\Delta STOI','FontSize',10,'FontWeight','normal');
axis([0.5 4.5 0 0.4]);
set(gca,'ygrid','on');


subplot(223)
bar(SDR1','hist');hold on
set(gca,'XTickLabel',{'-10','-5','0','5'}) ;
set(gca,'fontname','Times new roman','fontsize',10);
% xlabel({'SNR/dB';'(c)'},'FontSize',10,'FontWeight','normal');
xlabel({'SNR/dB';['\fontsize{14}\fontname{Times new roman} (c)']},'FontSize',10,'FontWeight','normal');
ylabel('\Delta SDR','FontSize',10,'FontWeight','normal');
axis([0.5 4.5 0 20]);
set(gca,'ygrid','on');


subplot(224)
bar(SSNR1','hist');hold on
set(gca,'XTickLabel',{'-10','-5','0','5'}) ;
set(gca,'fontname','Times new roman','fontsize',10);
% xlabel({'SNR/dB','(d)'},'FontSize',10,'FontWeight','normal');
xlabel({'SNR/dB';['\fontsize{14}\fontname{Times new roman} (d)']},'FontSize',10,'FontWeight','normal');
ylabel('\Delta SSNR','FontSize',10,'FontWeight','normal');
axis([0.5 4.5 0 15]);
set(gca,'ygrid','on');


legend('Standard NMF(noisy phase)','Proposed (noisy phase)','Proposed (PSC)','Proposed (PSF)','Proposed (clean phase)','location','best','orientation','horizontal');
set(gca,'fontname','Times new roman','fontsize',10);

colormap('jet')





           
           