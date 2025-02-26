
load('M.mat');
load('N.mat');
load('L.mat');
figure,
subplot(131),
bar(M,'hist');
set(gca,'XTickLabel',{'-10dB','-5dB','0dB','5dB'});
set(gca,'YTick');
xlabel('SNR(dB)');
ylabel('PEAQ');
title('PESQ','fontsize',12);
subplot(132),
bar(N,'hist');
set(gca,'XTickLabel',{'-10dB','-5dB','0dB','5dB'});
set(gca,'YTick');
xlabel('SNR(dB)');
ylabel('STOI');
title('STOI','fontsize',12);
subplot(133),
bar(L,'hist');axis([0 5 -0.5 18])
set(gca,'XTickLabel',{'-10dB','-5dB','0dB','5dB'});
set(gca,'YTick');
xlabel('SNR(dB)');
ylabel('SDR');
title('SDR','fontsize',12);