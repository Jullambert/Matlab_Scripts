%% Script for discussion with David from precision acoustics
cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Analyse_Sessions_AvecProto_1mm\Mesures_NewCalibrationHydrophone\1Vpp_200Cycles_300kHz_85\data
load('Resultats_Analyse_200Cyc_1Vpp_300kHz_85_WithoutImpNetw_withoutCorr', 'BurstHydrophone_1Vpp_200C_300kHz','Isppa_1Vpp_200C_300kHz','Tension_Hydrophone_1Vpp_200C_300kHz_Rect')
BurstHydrophone_November = BurstHydrophone_1Vpp_200C_300kHz;
Isppa_November = Isppa_1Vpp_200C_300kHz;
TensionHydrophone_November = Tension_Hydrophone_1Vpp_200C_300kHz_Rect;

cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Analyse_Sessions_AvecProto_1mm\Mesures_NewCalibrationHydrophone_WithoutMatchingImpedance\600mVpp_300kHz_200C_85\data
load('Resultats_Analyse_200Cyc_06Vpp_300kHz_85_WithoutImpNetw_withoutCorr', 'BurstHydrophone_06Vpp_200C_300kHz','Isppa_06Vpp_200C_300kHz','Tension_Hydrophone_06Vpp_200C_300kHz_Rect')
BurstHydrophone_November06 = BurstHydrophone_06Vpp_200C_300kHz;
Isppa_November06 = Isppa_06Vpp_200C_300kHz;
TensionHydrophone_November06 = Tension_Hydrophone_06Vpp_200C_300kHz_Rect;

cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Matlab\SessionValidationCalibratorAndStimulator\Transducteur_Zero
load('Resultats_Air_85_300kHz')
BurstHydrophone_Calib_June = BurstHydrophone;
Isppa_Calib_June = Isppa;
TensionHydrophone_June = Tension_Hydrophone_Corr_Filtre;

cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Matlab\SessionAttenuation\1Vpp_200Cycles_Session1\SansCrane
load('UltrasoundParameters_SessionAttenuation_SansCrane_1Vpp_200Cycles_6Freq_Sans_1_300kHz')
BurstHydrophone_March = BurstHydrophone;

cd D:\data\jlambert\TFUS_Mesures_Welcome\SessionJuillet_Rotations\ZeroDeg_Ref\250kHz
load('UltrasoundParameters_SessionJuillet_Rotations_ZeroDeg_Ref_1Vpp_250kHz')
BurstHydrophone_July = BurstHydrophone;

cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Analyse_Sessions_AvecProto_1mm\Mesures_Verification_Apres1erTestHumain\Data_September
load('Resultats_Analyse_200Cyc_1Vpp_300kHz')
BurstHydrophone_September = BurstHydrophone_1Vpp_200C_300kHz_Corr;
Isppa_September = Isppa_1Vpp_200C_300kHz;
TensionHydrophone_September = Tension_Hydrophone_1Vpp_200C_300kHz_Corr;

cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Analyse_Sessions_AvecProto_1mm\Mesures_Verification_Apres1erTestHumain\Data_September_2\data
load('Resultats_Analyse_200Cyc_1Vpp_300kHz_85_withoutCorr')
BurstHydrophone_September_2 = BurstHydrophone_1Vpp_200C_300kHz_Corr;
Isppa_September_2 = Isppa_1Vpp_200C_300kHz;
TensionHydrophone_September_2 = Tension_Hydrophone_1Vpp_200C_300kHz_Corr;

cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Analyse_Sessions_AvecProto_1mm\Mesures_Calibrator_February2018\85_Without\data
load('Resultats_Analyse_200Cyc_06Vpp_300kHz_85_withoutCorr')
BurstHydrophone_February06 = BurstHydrophone_06Vpp_200C_300kHz_Corr;
Isppa_February06 = Isppa_06Vpp_200C_300kHz;
TensionHydrophone_February06 = Tension_Hydrophone_06Vpp_200C_300kHz_Corr;

cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Analyse_Sessions_AvecProto_1mm\Measures_27_2_2018\February_1Vpp\data
load('Resultats_Analyse_200Cyc_1Vpp_300kHz_85_withoutCorr')
BurstHydrophone_February = BurstHydrophone_1Vpp_200C_300kHz_Corr;
Isppa_February = Isppa_1Vpp_200C_300kHz;
TensionHydrophone_February = Tension_Hydrophone_1Vpp_200C_300kHz_Corr;

cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Analyse_Sessions_AvecProto_1mm\Measures_27_2_2018\data
load('Resultats_Analyse_200Cyc_06Vpp_300kHz_85_withoutCorr')
BurstHydrophone_February06 = BurstHydrophone_06Vpp_200C_300kHz_Corr;
Isppa_February06 = Isppa_06Vpp_200C_300kHz;
TensionHydrophone_February06 = Tension_Hydrophone_06Vpp_200C_300kHz_Corr;

% figure;
% subplot(2,1,1)
% for i =1:size(BurstHydrophone_Calib_June,1)
% hold on
% plot(BurstHydrophone_Calib_June(i,:))
% end
% hold off
% title('Pressure waveforms calibrator -300kHz June')
% subplot(2,1,2)
% for j=1:size(BurstHydrophone_NewCalib_1Vpp_200C_300kHz_Corr,1)
% hold on
% plot(BurstHydrophone_NewCalib_1Vpp_200C_300kHz_Corr(j,:))
% end
% title('Pressure waveforms calibrator - 300kHz November')
% figure
% subplot(2,1,1)
% plot(squeeze(BurstHydrophone_March(26,83,:)))
% title('Pressure waveforms 300kHz - March')
% subplot(2,1,2)
% plot(squeeze(BurstHydrophone_July(26,86,:)))
% title('Pressure waveforms 300kHz - July')

figure
subplot(4,1,1)
for i =1:size(BurstHydrophone_Calib_June,1)
    PtP_Burst_June(i,:) = max(BurstHydrophone_Calib_June(i,:))-min(BurstHydrophone_Calib_June(i,:));
hold on
plot(BurstHydrophone_Calib_June(i,:))
end
hold off
title(strcat('Pressure waveforms calibrator -300kHz June - PtPPressure = ',num2str(mean(PtP_Burst_June)),'Pa'))
xlabel(strcat('Mean Isppa [W/cm²] = ', num2str(mean(Isppa_Calib_June)/10000)))
subplot(4,1,2)
for j=1:size(BurstHydrophone_September,1)
    PtP_Burst_September(j,:) = max(BurstHydrophone_September(j,:))-min(BurstHydrophone_September(j,:));

hold on
plot(BurstHydrophone_September(j,:))
end
title(strcat('Pressure waveforms calibrator - 300kHz September - PtPPressure = ',num2str(mean(PtP_Burst_September)),'Pa'))
xlabel(strcat('Mean Isppa [W/cm²] = ', num2str(mean(Isppa_September)/10000)))

subplot(4,1,3)
for k=1:size(BurstHydrophone_November,1)
    PtP_Burst_November(k,:) = max(BurstHydrophone_November(k,:))-min(BurstHydrophone_November(k,:));
hold on
plot(BurstHydrophone_November(k,:))
end
title(strcat('Pressure waveforms calibrator - 300kHz November - PtPPressure = ',num2str(mean(PtP_Burst_November)),'Pa'))
xlabel(strcat('Mean Isppa [W/cm²] = ', num2str(mean(Isppa_November)/10000)))
subplot(4,1,4)
for k=1:size(BurstHydrophone_February,1)
    PtP_Burst_February(k,:) = max(BurstHydrophone_February(k,:))-min(BurstHydrophone_February(k,:));
hold on
plot(BurstHydrophone_February(k,:))
end
title(strcat('Pressure waveforms calibrator - 300kHz February - PtPPressure = ',num2str(mean(PtP_Burst_February)),'Pa'))
xlabel(strcat('Mean Isppa [W/cm²] = ', num2str(mean(Isppa_February)/10000)))



figure
subplot(2,1,1)
for i =1:size(BurstHydrophone_Calib_June,1)
    PtP_Burst_June(i,:) = max(BurstHydrophone_Calib_June(i,:))-min(BurstHydrophone_Calib_June(i,:));
hold on
plot(BurstHydrophone_Calib_June(i,:))
end
hold off
title(strcat('Pressure waveforms calibrator -300kHz June - PtPPressure = ',num2str(mean(PtP_Burst_June)),'Pa'))
xlabel(strcat('Mean Isppa [W/cm²] = ', num2str(mean(Isppa_Calib_June)/10000)))

subplot(2,1,2)
for j=1:size(BurstHydrophone_September,1)
    PtP_Burst_September(j,:) = max(BurstHydrophone_September(j,:))-min(BurstHydrophone_September(j,:));
hold on
plot(BurstHydrophone_September(j,:))
end
title(strcat('Pressure waveforms calibrator - 300kHz September - PtPPressure = ',num2str(mean(PtP_Burst_September)),'Pa'))
hold off
xlabel(strcat('Mean Isppa [W/cm²] = ', num2str(mean(Isppa_September)/10000)))

figure
subplot(2,1,1)
for k=1:size(BurstHydrophone_November,1)
    PtP_Burst_November(k,:) = max(BurstHydrophone_November(k,:))-min(BurstHydrophone_November(k,:));
hold on
plot(BurstHydrophone_November(k,:))
end
title(strcat('Pressure waveforms calibrator - 300kHz November - PtPPressure = ',num2str(mean(PtP_Burst_November)),'Pa'))
xlabel(strcat('Mean Isppa [W/cm²] = ', num2str(mean(Isppa_November)/10000)))
subplot(2,1,2)
for l=1:size(BurstHydrophone_February,1)
    PtP_Burst_February(l,:) = max(BurstHydrophone_February(l,:))-min(BurstHydrophone_February(l,:));
hold on
plot(BurstHydrophone_February(l,:))
end
title(strcat('Pressure waveforms calibrator - 300kHz February 2018 - PtPPressure = ',num2str(mean(PtP_Burst_February)),'Pa'))
xlabel(strcat('Mean Isppa [W/cm²] = ', num2str(mean(Isppa_February)/10000)))

figure
subplot(2,1,1)
for j=1:size(BurstHydrophone_September,1)
    PtP_Burst_September(j,:) = max(BurstHydrophone_September(j,:))-min(BurstHydrophone_September(j,:));
hold on
plot(BurstHydrophone_September(j,:))
end
title(strcat('Pressure waveforms calibrator - 300kHz September - PtPPressure = ',num2str(mean(PtP_Burst_September)),'Pa'))
hold off
xlabel(strcat('Mean Isppa [W/cm²] = ', num2str(mean(Isppa_September)/10000)))
subplot(2,1,2)
for k=1:size(BurstHydrophone_November,1)
    PtP_Burst_November(k,:) = max(BurstHydrophone_November(k,:))-min(BurstHydrophone_November(k,:));
hold on
plot(BurstHydrophone_November(k,:))
end
title(strcat('Pressure waveforms calibrator - 300kHz November - PtPPressure = ',num2str(mean(PtP_Burst_November)),'Pa'))
xlabel(strcat('Mean Isppa [W/cm²] = ', num2str(mean(Isppa_November)/10000)))

figure
for w=1:size(TensionHydrophone_September,1)-1
    hold on 
    plot(TensionHydrophone_September(w,:))
end
title(strcat('TensionHydro September - PtPPressure = ',num2str(mean(PtP_Burst_September(1:end-1)))))

figure
for w=1:size(TensionHydrophone_September_2,1)-1
     PtP_Burst_September_2(w,:) = max(BurstHydrophone_September_2(w,:))-min(BurstHydrophone_September_2(w,:));
    hold on 
    plot(TensionHydrophone_September_2(w,:))
end
title(strcat('TensionHydro September 2 - PtPPressure = ',num2str(mean(PtP_Burst_September_2(1:end-1)))))


figure
for v=1:size(TensionHydrophone_November,1)
    hold on 
    plot(TensionHydrophone_November(v,:))
end
title(strcat('TensionHydro November - PtPPressure = ',num2str(mean(PtP_Burst_November))))

figure
for u=1:size(TensionHydrophone_June,1)
    hold on 
    plot(TensionHydrophone_June(u,:))
end
title(strcat('TensionHydro June PtPPressure = ',num2str(mean(PtP_Burst_June))))

figure
for x=1:size(TensionHydrophone_February,1)
    hold on 
    plot(TensionHydrophone_February(x,:))
end
title(strcat('TensionHydro February  PtPPressure = ',num2str(mean(PtP_Burst_February))))

figure
for x=1:size(TensionHydrophone_November06,1)
    PtP_Burst_November06(k,:) = max(BurstHydrophone_November06(k,:))-min(BurstHydrophone_November06(k,:));
    hold on 
    plot(TensionHydrophone_November06(x,:))
end
title(strcat('TensionHydro November 0.6Vpp  PtPPressure = ',num2str(mean(PtP_Burst_November06))))

figure
for x=1:size(TensionHydrophone_November06,1)
    PtP_Burst_February06(x,:) = max(BurstHydrophone_February06(x,:))-min(BurstHydrophone_February06(x,:));
    hold on 
    plot(TensionHydrophone_February06(x,:))
end
title(strcat('TensionHydro February 0.6Vpp  PtPPressure = ',num2str(mean(PtP_Burst_November06))))
