clear all
close all
clc

%%
load('F:\JLambert_Stim1\TFUS_Mesures_Welcome\SessionAvril_Prob_Echo\1Vpp_6Freq_6NumCycles\500kHz\5Cycles\UltrasoundParameters_SessionAvril_Prob_Echo_1Vpp_6Freq_6NumCycles_5Cycles_500kHz')
[xindex, yindex] = find(Isppa == max(max(Isppa(:,1:91))))
load('F:\JLambert_Stim1\TFUS_Mesures_Welcome\SessionAvril_Prob_Echo\1Vpp_6Freq_6NumCycles\500kHz\5Cycles\RawData_SessionAvril_Prob_Echo_1Vpp_6Freq_6NumCycles_5Cycles_500kHz')

xmin = 14000;
xmax = 24000;
ymin = -0.6;
ymax=0.6;    
% xindex = 26;
xstep = 1;
% yindex = 99;
ystep = 1;
figure
subplot(5,1,1);
h1=plot(squeeze(Tension_Hydrophone(xindex,yindex+2*ystep,:)),'k');
xlim([xmin xmax]);
ylim([ymin ymax]);
legend(num2str(Isppa(xindex,yindex+2*ystep)))
title (['Evolution Hydrophone measures 5 cycles 500 kHz from ' num2str(yindex+2*ystep) ' to ' num2str(yindex-2*ystep) ])
subplot(5,1,2);
h2=plot(squeeze(Tension_Hydrophone(xindex,yindex+ystep,:)),'k');
xlim([xmin xmax]);
ylim([ymin ymax]);
legend(num2str(Isppa(xindex,yindex+ystep)))
subplot(5,1,3);
h3=plot(squeeze(Tension_Hydrophone(xindex,yindex,:)),'k');
xlim([xmin xmax]);
ylim([ymin ymax]);
legend(num2str(Isppa(xindex,yindex)))
subplot(5,1,4);
h4=plot(squeeze(Tension_Hydrophone(xindex,yindex-ystep,:)),'k');
xlim([xmin xmax]);
ylim([ymin ymax]);
legend(num2str(Isppa(xindex,yindex-ystep)))
subplot(5,1,5);
h5=plot(squeeze(Tension_Hydrophone(xindex,yindex-2*ystep,:)),'k');
xlim([xmin xmax]);
ylim([ymin ymax]);
legend(num2str(Isppa(xindex,yindex-2*ystep)))

%%
fignamecontrol = ['Evolution Hydrophone measures 5 cycles 500 kHz from ' num2str(yindex+2*ystep) ' to ' num2str(yindex-2*ystep)];
savefig(fignamecontrol)
saveas(gcf,fignamecontrol,'epsc')
