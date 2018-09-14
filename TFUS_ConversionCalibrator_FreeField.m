% Modifs the 6th of March 2018 - JL : Taking into account the end of the
% Burst hydrophone to calculate the PtP amplitudes. This is needed because
% the beginning of the burst is affected by electromagnetic pickup !!
% It changes a lot the values calculated!! Almost dividing them by 2!!!

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% First Method : converting data from free field with 1 Vpp , 200 Cycles
% 300 KHz en données 0.6 Vpp,200 Cycles, 300 kHz avec reseau d'impédance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% coefficient 0.6Vpp to 1 Vpp - session August 
cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Matlab\SessionMultipleDrivingVoltageAmplitude
load('UltrasoundParameters_SessionAout_SansCrane_06Vpp_5Cycl_3Freq_1mm_250kHz','BurstHydrophone')
BurstHydophone_06Vpp_5Cyc_250kHz = BurstHydrophone;
clear BurstHydrophone
load('UltrasoundParameters_SessionAout_SansCrane_06Vpp_5Cycl_3Freq_1mm_350kHz','BurstHydrophone')
BurstHydophone_06Vpp_5Cyc_350kHz = BurstHydrophone;
clear Tension_Hydrophone

load('UltrasoundParameters_SessionAout_SansCrane_1Vpp_5Cycl_3Freq_1mm_250kHz','BurstHydrophone')
BurstHydophone_1Vpp_5Cyc_250kHz = BurstHydrophone;
clear BurstHydrophone
load('UltrasoundParameters_SessionAout_SansCrane_1Vpp_5Cycl_3Freq_1mm_350kHz','BurstHydrophone')
BurstHydophone_1Vpp_5Cyc_350kHz = BurstHydrophone;
clear Tension_Hydrophone

for x=1:size(BurstHydophone_06Vpp_5Cyc_250kHz,1)
    for y=1:size(BurstHydophone_06Vpp_5Cyc_250kHz,2)
        PtP_BurstHydophone_06Vpp_5Cyc_250kHz(x,y,:) = max(BurstHydophone_06Vpp_5Cyc_250kHz(x,y,end-200:end))-min(BurstHydophone_06Vpp_5Cyc_250kHz(x,y,end-200:end));
        PtP_BurstHydophone_06Vpp_5Cyc_350kHz(x,y,:) = max(BurstHydophone_06Vpp_5Cyc_250kHz(x,y,end-200:end))-min(BurstHydophone_06Vpp_5Cyc_250kHz(x,y,end-200:end));
        PtP_BurstHydophone_1Vpp_5Cyc_250kHz(x,y,:) = max(BurstHydophone_1Vpp_5Cyc_250kHz(x,y,end-200:end))-min(BurstHydophone_1Vpp_5Cyc_250kHz(x,y,end-200:end));
        PtP_BurstHydophone_1Vpp_5Cyc_350kHz(x,y,:) = max(BurstHydophone_1Vpp_5Cyc_350kHz(x,y,end-200:end))-min(BurstHydophone_1Vpp_5Cyc_350kHz(x,y,end-200:end));
        
        Variation_PtP_Burst_250kHz(x,y,:) = (PtP_BurstHydophone_1Vpp_5Cyc_250kHz(x,y,:)-PtP_BurstHydophone_06Vpp_5Cyc_250kHz(x,y,:))/PtP_BurstHydophone_06Vpp_5Cyc_250kHz(x,y,:);
        Variation_PtP_Burst_350kHz(x,y,:) = (PtP_BurstHydophone_1Vpp_5Cyc_350kHz(x,y,:)-PtP_BurstHydophone_06Vpp_5Cyc_250kHz(x,y,:))/PtP_BurstHydophone_06Vpp_5Cyc_350kHz(x,y,:);
        Variation_Burst_Moyenne(x,y) = mean([Variation_PtP_Burst_250kHz(x,y,:) Variation_PtP_Burst_350kHz(x,y,:)]);
    end
end

% Variation_PtP_Tension_250kHz(25,90,:) 
% PtP_Tension_Hydophone_1Vpp_5Cyc_250kHz(25,90,:)
% PtP_Tension_Hydophone_06Vpp_5Cyc_250kHz(25,90,:)
% 
% PtP_Tension_Hydophone_1Vpp_5Cyc_250kHz(25,90,:)/(1+Variation_PtP_Tension_250kHz(25,90,:)) 


figure
imagesc(PtP_BurstHydophone_06Vpp_5Cyc_250kHz)

figure
imagesc(Variation_PtP_Burst_250kHz)

figure
imagesc(Variation_Burst_Moyenne)

%% Coefficient impedance matching network
cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Analyse_Sessions_AvecProto_1mm\Mesures_NewCalibrationHydrophone_WithoutMatchingImpedance\600mVpp_300kHz_200C_80\data
load('Resultats_Analyse_200Cyc_06Vpp_300kHz_80_WithoutImpNetw_withoutCorr','BurstHydrophone_06Vpp_200C_300kHz')
BurstHydrophone_Calib_Without_06Vpp_200Cyc_80 = BurstHydrophone_06Vpp_200C_300kHz;

cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Analyse_Sessions_AvecProto_1mm\Mesures_NewCalibrationHydrophone_WithoutMatchingImpedance\600mVpp_300kHz_200C_81\data
load('Resultats_Analyse_200Cyc_06Vpp_300kHz_81_WithoutImpNetw_withoutCorr','BurstHydrophone_06Vpp_200C_300kHz')
BurstHydrophone_Calib_Without_06Vpp_200Cyc_81 = BurstHydrophone_06Vpp_200C_300kHz;

cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Analyse_Sessions_AvecProto_1mm\Mesures_NewCalibrationHydrophone_WithoutMatchingImpedance\600mVpp_300kHz_200C_82\data
load('Resultats_Analyse_200Cyc_06Vpp_300kHz_82_WithoutImpNetw_withoutCorr','BurstHydrophone_06Vpp_200C_300kHz')
BurstHydrophone_Calib_Without_06Vpp_200Cyc_82 = BurstHydrophone_06Vpp_200C_300kHz;

cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Analyse_Sessions_AvecProto_1mm\Mesures_NewCalibrationHydrophone_WithoutMatchingImpedance\600mVpp_300kHz_200C_83\data
load('Resultats_Analyse_200Cyc_06Vpp_300kHz_83_WithoutImpNetw_withoutCorr','BurstHydrophone_06Vpp_200C_300kHz')
BurstHydrophone_Calib_Without_06Vpp_200Cyc_83 = BurstHydrophone_06Vpp_200C_300kHz;

cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Analyse_Sessions_AvecProto_1mm\Mesures_NewCalibrationHydrophone_WithoutMatchingImpedance\600mVpp_300kHz_200C_84\data
load('Resultats_Analyse_200Cyc_06Vpp_300kHz_84_WithoutImpNetw_withoutCorr','BurstHydrophone_06Vpp_200C_300kHz')
BurstHydrophone_Calib_Without_06Vpp_200Cyc_84 = BurstHydrophone_06Vpp_200C_300kHz;

cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Analyse_Sessions_AvecProto_1mm\Mesures_NewCalibrationHydrophone_WithoutMatchingImpedance\600mVpp_300kHz_200C_85\data
load('Resultats_Analyse_200Cyc_06Vpp_300kHz_85_WithoutImpNetw_withoutCorr', 'BurstHydrophone_06Vpp_200C_300kHz')
BurstHydrophone_Calib_Without_06Vpp_200Cyc_85 = BurstHydrophone_06Vpp_200C_300kHz;

cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Analyse_Sessions_AvecProto_1mm\Mesures_NewCalibrationHydrophone_WithMatchingImpedance\600mVpp_300kHz_200C_80\data
load('Resultats_Analyse_200Cyc_06Vpp_300kHz_80_WithImpNetw_withoutCorr', 'BurstHydrophone_06Vpp_200C_300kHz')
BurstHydrophone_Calib_With_06Vpp_200Cyc_80 = BurstHydrophone_06Vpp_200C_300kHz;

cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Analyse_Sessions_AvecProto_1mm\Mesures_NewCalibrationHydrophone_WithMatchingImpedance\600mVpp_300kHz_200C_81\data
load('Resultats_Analyse_200Cyc_06Vpp_300kHz_81_WithImpNetw_withoutCorr', 'BurstHydrophone_06Vpp_200C_300kHz')
BurstHydrophone_Calib_With_06Vpp_200Cyc_81 = BurstHydrophone_06Vpp_200C_300kHz;

cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Analyse_Sessions_AvecProto_1mm\Mesures_NewCalibrationHydrophone_WithMatchingImpedance\600mVpp_300kHz_200C_82\data
load('Resultats_Analyse_200Cyc_06Vpp_300kHz_82_WithImpNetw_withoutCorr', 'BurstHydrophone_06Vpp_200C_300kHz')
BurstHydrophone_Calib_With_06Vpp_200Cyc_82 =  BurstHydrophone_06Vpp_200C_300kHz;

cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Analyse_Sessions_AvecProto_1mm\Mesures_NewCalibrationHydrophone_WithMatchingImpedance\600mVpp_300kHz_200C_83\data
load('Resultats_Analyse_200Cyc_06Vpp_300kHz_83_WithImpNetw_withoutCorr', 'BurstHydrophone_06Vpp_200C_300kHz')
BurstHydrophone_Calib_With_06Vpp_200Cyc_83 =  BurstHydrophone_06Vpp_200C_300kHz;

cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Analyse_Sessions_AvecProto_1mm\Mesures_NewCalibrationHydrophone_WithMatchingImpedance\600mVpp_300kHz_200C_84\data
load('Resultats_Analyse_200Cyc_06Vpp_300kHz_84_WithImpNetw_withoutCorr', 'BurstHydrophone_06Vpp_200C_300kHz')
BurstHydrophone_Calib_With_06Vpp_200Cyc_84 =  BurstHydrophone_06Vpp_200C_300kHz;

cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Analyse_Sessions_AvecProto_1mm\Mesures_NewCalibrationHydrophone_WithMatchingImpedance\600mVpp_300kHz_200C_85\data
load('Resultats_Analyse_200Cyc_06Vpp_300kHz_85_WithImpNetw_withoutCorr', 'BurstHydrophone_06Vpp_200C_300kHz')
BurstHydrophone_Calib_With_06Vpp_200Cyc_85 =  BurstHydrophone_06Vpp_200C_300kHz;


for x=1:size(BurstHydrophone_Calib_With_06Vpp_200Cyc_80,1)
    PtP_BurstHydrophone_Calib_Without_06Vpp_200Cyc_80(x,:) = max(BurstHydrophone_Calib_Without_06Vpp_200Cyc_80(x,end-200:end))-min(BurstHydrophone_Calib_Without_06Vpp_200Cyc_80(x,end-200:end));
    PtP_BurstHydrophone_Calib_Without_06Vpp_200Cyc_81(x,:) = max(BurstHydrophone_Calib_Without_06Vpp_200Cyc_81(x,end-200:end))-min(BurstHydrophone_Calib_Without_06Vpp_200Cyc_81(x,end-200:end));
    PtP_BurstHydrophone_Calib_Without_06Vpp_200Cyc_82(x,:) = max(BurstHydrophone_Calib_Without_06Vpp_200Cyc_82(x,end-200:end))-min(BurstHydrophone_Calib_Without_06Vpp_200Cyc_82(x,end-200:end));
    PtP_BurstHydrophone_Calib_Without_06Vpp_200Cyc_83(x,:) = max(BurstHydrophone_Calib_Without_06Vpp_200Cyc_83(x,end-200:end))-min(BurstHydrophone_Calib_Without_06Vpp_200Cyc_83(x,end-200:end));
    PtP_BurstHydrophone_Calib_Without_06Vpp_200Cyc_84(x,:) = max(BurstHydrophone_Calib_Without_06Vpp_200Cyc_84(x,end-200:end))-min(BurstHydrophone_Calib_Without_06Vpp_200Cyc_84(x,end-200:end));
    PtP_BurstHydrophone_Calib_Without_06Vpp_200Cyc_85(x,:) = max(BurstHydrophone_Calib_Without_06Vpp_200Cyc_85(x,end-200:end))-min(BurstHydrophone_Calib_Without_06Vpp_200Cyc_85(x,end-200:end));
    PtP_BurstHydrophone_Calib_With_06Vpp_200Cyc_80(x,:) = max(BurstHydrophone_Calib_With_06Vpp_200Cyc_80(x,end-200:end))-min(BurstHydrophone_Calib_With_06Vpp_200Cyc_80(x,end-200:end));
    PtP_BurstHydrophone_Calib_With_06Vpp_200Cyc_81(x,:) = max(BurstHydrophone_Calib_With_06Vpp_200Cyc_81(x,end-200:end))-min(BurstHydrophone_Calib_With_06Vpp_200Cyc_81(x,end-200:end));
    PtP_BurstHydrophone_Calib_With_06Vpp_200Cyc_82(x,:) = max(BurstHydrophone_Calib_With_06Vpp_200Cyc_82(x,end-200:end))-min(BurstHydrophone_Calib_With_06Vpp_200Cyc_82(x,end-200:end));
    PtP_BurstHydrophone_Calib_With_06Vpp_200Cyc_83(x,:) = max(BurstHydrophone_Calib_With_06Vpp_200Cyc_83(x,end-200:end))-min(BurstHydrophone_Calib_With_06Vpp_200Cyc_83(x,end-200:end));
    PtP_BurstHydrophone_Calib_With_06Vpp_200Cyc_84(x,:) = max(BurstHydrophone_Calib_With_06Vpp_200Cyc_84(x,end-200:end))-min(BurstHydrophone_Calib_With_06Vpp_200Cyc_84(x,end-200:end));
    PtP_BurstHydrophone_Calib_With_06Vpp_200Cyc_85(x,:) = max(BurstHydrophone_Calib_With_06Vpp_200Cyc_85(x,end-200:end))-min(BurstHydrophone_Calib_With_06Vpp_200Cyc_85(x,end-200:end));
    Coeff_ImpedanceNetwork_80(x) =(PtP_BurstHydrophone_Calib_With_06Vpp_200Cyc_80(x,:)-PtP_BurstHydrophone_Calib_Without_06Vpp_200Cyc_80(x,:))/PtP_BurstHydrophone_Calib_Without_06Vpp_200Cyc_80(x,:);
    Coeff_ImpedanceNetwork_81(x) =(PtP_BurstHydrophone_Calib_With_06Vpp_200Cyc_81(x,:)-PtP_BurstHydrophone_Calib_Without_06Vpp_200Cyc_81(x,:))/PtP_BurstHydrophone_Calib_Without_06Vpp_200Cyc_81(x,:);
    Coeff_ImpedanceNetwork_82(x) =(PtP_BurstHydrophone_Calib_With_06Vpp_200Cyc_82(x,:)-PtP_BurstHydrophone_Calib_Without_06Vpp_200Cyc_82(x,:))/PtP_BurstHydrophone_Calib_Without_06Vpp_200Cyc_82(x,:);
    Coeff_ImpedanceNetwork_83(x) =(PtP_BurstHydrophone_Calib_With_06Vpp_200Cyc_83(x,:)-PtP_BurstHydrophone_Calib_Without_06Vpp_200Cyc_83(x,:))/PtP_BurstHydrophone_Calib_Without_06Vpp_200Cyc_83(x,:);
    Coeff_ImpedanceNetwork_84(x) =(PtP_BurstHydrophone_Calib_With_06Vpp_200Cyc_84(x,:)-PtP_BurstHydrophone_Calib_Without_06Vpp_200Cyc_84(x,:))/PtP_BurstHydrophone_Calib_Without_06Vpp_200Cyc_84(x,:);
    Coeff_ImpedanceNetwork_85(x) =(PtP_BurstHydrophone_Calib_With_06Vpp_200Cyc_85(x,:)-PtP_BurstHydrophone_Calib_Without_06Vpp_200Cyc_85(x,:))/PtP_BurstHydrophone_Calib_Without_06Vpp_200Cyc_85(x,:);
end


%%
% cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Matlab\SessionMultipleNumberOfCyclesInPulse
% 
% load('UltrasoundParameters_SessionAvril_Prob_Echo_1Vpp_6Freq_6NumCycles_200Cycles_300kHz','BurstHydrophone')
% BurstHydrophone_1Vpp_200Cyc_300kHz = BurstHydrophone;
% load('UltrasoundParameters_SessionAvril_Prob_Echo_1Vpp_6Freq_6NumCycles_200Cycles_300kHz','Isppa')
% [PositionX_maxIsppa, PositionY_maxIsppa] = find(Isppa==max(max(Isppa(:,1:91))));
% for x=1:size(BurstHydrophone_1Vpp_200Cyc_300kHz,1)
%     for y =1:size(BurstHydrophone_1Vpp_200Cyc_300kHz,2)
%         BurstHydrophone_Evaluated_06Vpp_200Cyc_300kHz(x,y,:)=BurstHydrophone_1Vpp_200Cyc_300kHz(x,y,:)/(1+Variation_Burst_Moyenne(PositionX_maxIsppa,PositionY_maxIsppa,:));
%     end
% end
% 
% for x=1:size(BurstHydrophone_1Vpp_200Cyc_300kHz,1)
%     for y =1:size(BurstHydrophone_1Vpp_200Cyc_300kHz,2)
%         Burst_Evaluated_WithImpedanceNetwork_06Vpp_200Cyc_300kHz(x,y,:)=BurstHydrophone_Evaluated_06Vpp_200Cyc_300kHz(x,y,:)*(1+mean([Coeff_ImpedanceNetwork_81]));
%     end
% end
% % Variation_PtP_Tension_250kHz(25,90,:) 
% % PtP_Tension_Hydophone_1Vpp_5Cyc_250kHz(25,90,:)
% % PtP_Tension_Hydophone_06Vpp_5Cyc_250kHz(25,90,:)
% % 
% % PtP_Tension_Hydophone_1Vpp_5Cyc_250kHz(25,90,:)/(1+Variation_PtP_Tension_250kHz(25,90,:)) 
% 
% % Coeff_ImpedanceNetwork_80(x)
% % PtP_Tension_Hydrophone_Calib_With_06Vpp_200Cyc_80(x,:)
% % PtP_Tension_Hydrophone_Calib_Without_06Vpp_200Cyc_80(x,:)
% % PtP_Tension_Hydrophone_Calib_Without_06Vpp_200Cyc_80(x,:)*(1+Coeff_ImpedanceNetwork_80(x))    

%%
% load('UltrasoundParameters_SessionAvril_Prob_Echo_1Vpp_6Freq_6NumCycles_200Cycles_300kHz','BurstHydrophone')
% BurstHydrophone_1Vpp_200Cyc_300kHz = BurstHydrophone;
cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Matlab\SessionMultipleNumberOfCyclesInPulse
load('RawData_SessionAvril_Prob_Echo_1Vpp_6Freq_6NumCycles_200Cycles_300kHz','Tension_Hydrophone')
Tension_Hydrophone_1Vpp_200C_April = Tension_Hydrophone;
load('UltrasoundParameters_SessionAvril_Prob_Echo_1Vpp_6Freq_6NumCycles_200Cycles_300kHz','Isppa')
[PositionX_maxIsppa, PositionY_maxIsppa] = find(Isppa==max(max(Isppa(:,1:91))));

NumberOfCycles = 200;
UltrasoundBurstFrequency = 300000;
SamplingFrequency = 10000000;
ToneBurstDuration = NumberOfCycles * 1/UltrasoundBurstFrequency  ;
DutyCycle = ToneBurstDuration* 1000 * 1;
HydrophoneSensitivity = 0.91;
VecteurTemps_FunctionGen = 0:1/SamplingFrequency:30000/SamplingFrequency;
UltrasoundBurstPeriod = 1/UltrasoundBurstFrequency;
SonicationDuration=0.3;

% for x=1:size(Tension_Hydrophone_1Vpp_200C_April,1)
%     for y=1:size(Tension_Hydrophone_1Vpp_200C_April,2)
%     Tension_Hydrophone_1Vpp_200C_April_Rect(x,y,:) = Tension_Hydrophone_1Vpp_200C_April(x,y,:)-mean(Tension_Hydrophone_1Vpp_200C_April(x,y,25000:end));
%     [ValPic, NumCycle] = findpeaks(squeeze(Tension_Hydrophone_1Vpp_200C_April_Rect(x,y,:)),'MINPEAKHEIGHT',0.0041);
%     PeakValue_Hydrophone_Tension_Hydrophone_1Vpp_200C_April(x,y,:) = ValPic(1);
%     NumCycle_Hydrophone_Tension_Hydrophone_1Vpp_200C_April(x,y,:)=NumCycle(1)+14999;
%     InitBurst = NumCycle_Hydrophone_Tension_Hydrophone_1Vpp_200C_April(x,y,:)-ceil((0.5*UltrasoundBurstPeriod*SamplingFrequency));
%     EndBurst = NumCycle_Hydrophone_Tension_Hydrophone_1Vpp_200C_April(x,y,:)+ceil((NumberOfCycles*UltrasoundBurstPeriod*SamplingFrequency));
% %     EndBurst = EndBurst+9999;
%     BurstHydrophone_Tension_Hydrophone_1Vpp_200C_April(x,y,:) = ((Tension_Hydrophone_1Vpp_200C_April_Rect(x,y,InitBurst:EndBurst)).*1000000)./HydrophoneSensitivity; 
%     BurstHydrophone_Tension_06Vpp_Evaluated(x,y,:) = BurstHydrophone_Tension_Hydrophone_1Vpp_200C_April(x,y,:)/(1+Variation_Burst_Moyenne(PositionX_maxIsppa,PositionY_maxIsppa,:));
%     BurstHydrophone_Tension_06Vpp_Evaluated_WithImpedanceNetwork(x,y,:) = BurstHydrophone_Tension_06Vpp_Evaluated(x,y,:) *(1+mean([Coeff_ImpedanceNetwork_81]));
%     TimeVector_Tension_06Vpp_Evaluated_WithImpedanceNetwork(x,y,:) = VecteurTemps_FunctionGen(InitBurst:EndBurst);
%         
%     [Pi_Tension_Evaluee_WithImpedanceNetwork_06Vpp(x,y,:),Isppa_Tension_Evaluee_WithImpedanceNetwork_06Vpp_Corr(x,y,:),Ispta_NewCalib_06Vpp_200C_300kHz(x,y,:),MI_Tension_Evaluee_WithImpedanceNetwork_06Vpp(x,y,:), TI_Tension_Evaluee_WithImpedanceNetwork_06Vpp(x,y,:)] = ultrasoundParameters(BurstHydrophone_Tension_06Vpp_Evaluated_WithImpedanceNetwork(x,y,:),TimeVector_Tension_06Vpp_Evaluated_WithImpedanceNetwork(x,y,:),1028,1515,UltrasoundBurstFrequency,DutyCycle,SamplingFrequency,SonicationDuration);
%     end
% end
% 
% Isppa_Tension_Evaluee_WithImpedanceNetwork_06Vpp_Corr(PositionX_maxIsppa,
% PositionY_maxIsppa) -> = 27.278

Tension_Hydrophone_1Vpp_200C_April_Rect = Tension_Hydrophone_1Vpp_200C_April(PositionX_maxIsppa, PositionY_maxIsppa,:)-mean(Tension_Hydrophone_1Vpp_200C_April(PositionX_maxIsppa, PositionY_maxIsppa,25000:end));
[ValPic, NumCycle] = findpeaks(squeeze(Tension_Hydrophone_1Vpp_200C_April_Rect),'MINPEAKHEIGHT',0.01);
PeakValue_Hydrophone_Tension_Hydrophone_1Vpp_200C_April = ValPic(1);
NumCycle_Hydrophone_Tension_Hydrophone_1Vpp_200C_April=NumCycle(1);
InitBurst = NumCycle_Hydrophone_Tension_Hydrophone_1Vpp_200C_April-ceil((0.5*UltrasoundBurstPeriod*SamplingFrequency));
EndBurst = NumCycle_Hydrophone_Tension_Hydrophone_1Vpp_200C_April+ceil((NumberOfCycles*UltrasoundBurstPeriod*SamplingFrequency));
%     EndBurst = EndBurst+9999;
BurstHydrophone_Tension_Hydrophone_1Vpp_200C_April = ((Tension_Hydrophone_1Vpp_200C_April_Rect(InitBurst:EndBurst)).*1000000)./HydrophoneSensitivity; 
BurstHydrophone_Tension_06Vpp_Evaluated = BurstHydrophone_Tension_Hydrophone_1Vpp_200C_April/(1+Variation_Burst_Moyenne(PositionX_maxIsppa,PositionY_maxIsppa,:));
BurstHydrophone_Tension_06Vpp_Evaluated_WithImpedanceNetwork= BurstHydrophone_Tension_06Vpp_Evaluated *(1+mean([Coeff_ImpedanceNetwork_81]));
TimeVector_Tension_06Vpp_Evaluated_WithImpedanceNetwork = VecteurTemps_FunctionGen(InitBurst:EndBurst);
PeakPressure = max(BurstHydrophone_Tension_06Vpp_Evaluated_WithImpedanceNetwork(end-200:end));
Isppa1 = (PeakPressure^2)/(2*1028*1515);
MI1 = (PeakPressure.*1e-6)./sqrt(UltrasoundBurstFrequency*1e-6);
[Pi_Tension_Evaluee_WithImpedanceNetwork_06Vpp,Isppa_Tension_Evaluee_WithImpedanceNetwork_06Vpp_Corr,Ispta_NewCalib_06Vpp_200C_300kHz,MI_Tension_Evaluee_WithImpedanceNetwork_06Vpp, TI_Tension_Evaluee_WithImpedanceNetwork_06Vpp] = ultrasoundParameters(BurstHydrophone_Tension_06Vpp_Evaluated_WithImpedanceNetwork,TimeVector_Tension_06Vpp_Evaluated_WithImpedanceNetwork,1028,1515,UltrasoundBurstFrequency,DutyCycle,SamplingFrequency,SonicationDuration);
Isppa_Tension_Evaluee_WithImpedanceNetwork_06Vpp_Corr
Isppa1
% Comparaison résultats, données avril, via fonction ultrasoundParameters
% Isppa_Tension_Evaluee_WithImpedanceNetwork_06Vpp_Corr, au point focal, en faisant les
% boucles --> = 27.278
% En calculant juste pour le point focal, et en gardant le même suil de
% détection que celui utilisée dans le script "Analyse_Data_Calibrator" ,
% i.e. 0.01, Isppa_Tension_Evaluee_WithImpedanceNetwork_06Vpp_Corr -->
% 27.277
% via Isppa1 --> 28.198

cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Matlab\Evaluation06Vpp_300kHz_200C
save('Results_Evaluation_06Vpp_200C_300kHz_DataSessionApril_Coeff81')
%%
% load('UltrasoundParameters_SessionAvril_Prob_Echo_1Vpp_6Freq_6NumCycles_200Cycles_300kHz.mat', 'BurstHydrophone')
% BurstHydrophone_Original = BurstHydrophone;
% figure
% subplot(4,1,1)
% plot(squeeze(BurstHydrophone_Original(PositionX_maxIsppa,PositionY_maxIsppa,:)))
% subplot(4,1,2)
% plot(squeeze(BurstHydrophone_Tension_Hydrophone_1Vpp_200C_April_Corr(PositionX_maxIsppa,PositionY_maxIsppa,:)))
% subplot(4,1,3)
% plot(squeeze(BurstHydrophone_Tension_06Vpp_Evaluated(PositionX_maxIsppa,PositionY_maxIsppa,:)))
% subplot(4,1,4)
% plot(squeeze(BurstHydrophone_Tension_06Vpp_Evaluated_WithImpedanceNetwork(PositionX_maxIsppa,PositionY_maxIsppa,:)))
% 
% figure
% subplot(3,1,1)
% plot(squeeze(BurstHydrophone_Tension_Hydrophone_1Vpp_200C_April_Corr(PositionX_maxIsppa,PositionY_maxIsppa,:)))
% subplot(3,1,2)
% plot(squeeze(BurstHydrophone_Tension_06Vpp_Evaluated(PositionX_maxIsppa,PositionY_maxIsppa,:)))
% subplot(3,1,3)
% plot(squeeze(BurstHydrophone_Tension_06Vpp_Evaluated_WithImpedanceNetwork(PositionX_maxIsppa,PositionY_maxIsppa,:)))

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Second method : correcting data from the calibrator to evaluate the Isppa
%for a driving voltage of 0.6 Vpp, 200 Cycles, 300 kHz with impedance
%matching network
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Import data Calib 1 Vpp 200 Cycles 300 kHz - calibrator
% cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Analyse_Sessions_AvecProto_1mm\Mesures_NewCalibrationHydrophone\1Vpp_200Cycles_300kHz_81\data
% load('Resultats_Analyse_200Cyc_1Vpp_300kHz_81_WithoutImpNetw_withoutCorr', 'BurstHydrophone_1Vpp_200C_300kHz');
% BurstHydrophone_Calib_200C_1Vpp_300kHz_81 = BurstHydrophone_1Vpp_200C_300kHz;
% 
% cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Analyse_Sessions_AvecProto_1mm\Mesures_NewCalibrationHydrophone\1Vpp_200Cycles_300kHz_82\data
% load('Resultats_Analyse_200Cyc_1Vpp_300kHz_82_WithoutImpNetw_withoutCorr', 'BurstHydrophone_1Vpp_200C_300kHz')
% BurstHydrophone_Calib_200C_1Vpp_300kHz_82 = BurstHydrophone_1Vpp_200C_300kHz;
% for x=1:size(BurstHydrophone_Calib_200C_1Vpp_300kHz_81,1)
%     PtP_BurstHydrophone_Calib_200C_1Vpp_300kHz_81(x) = max(BurstHydrophone_Calib_200C_1Vpp_300kHz_81(x,end-200:end))-min(BurstHydrophone_Calib_200C_1Vpp_300kHz_81(x,end-200:end));
% end
% for x=1:size(BurstHydrophone_Calib_200C_1Vpp_300kHz_82,1)
%     PtP_BurstHydrophone_Calib_200C_1Vpp_300kHz_82(x) = max(BurstHydrophone_Calib_200C_1Vpp_300kHz_82(x,end-200:end))-min(BurstHydrophone_Calib_200C_1Vpp_300kHz_82(x,end-200:end));
% end
% Mean_PtP_BurstHydrophone_Calib_200C_1Vpp_300kHz_81_82 = mean([PtP_BurstHydrophone_Calib_200C_1Vpp_300kHz_81 PtP_BurstHydrophone_Calib_200C_1Vpp_300kHz_82]);

cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Matlab\SessionValidationCalibratorAndStimulator\Transducteur_Zero
load('Resultats_Air_81_300kHz','BurstHydrophone')
BurstHydrophone_Calib_June_200C_1Vpp_300kHz_81=BurstHydrophone;
cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Matlab\SessionValidationCalibratorAndStimulator\Transducteur_Zero
load('Resultats_Air_82_300kHz','BurstHydrophone')
BurstHydrophone_Calib_June_200C_1Vpp_300kHz_82=BurstHydrophone;
for x=1:size(BurstHydrophone_Calib_June_200C_1Vpp_300kHz_81,1)
    PtP_BurstHydrophone_Calib_200C_1Vpp_300kHz_81(x) = max(BurstHydrophone_Calib_June_200C_1Vpp_300kHz_81(x,end-200:end))-min(BurstHydrophone_Calib_June_200C_1Vpp_300kHz_81(x,end-200:end));
end
for x=1:size(BurstHydrophone_Calib_June_200C_1Vpp_300kHz_82,1)
    PtP_BurstHydrophone_Calib_200C_1Vpp_300kHz_82(x) = max(BurstHydrophone_Calib_June_200C_1Vpp_300kHz_82(x,end-200:end))-min(BurstHydrophone_Calib_June_200C_1Vpp_300kHz_82(x,end-200:end));
end
Mean_PtP_BurstHydrophone_Calib_200C_1Vpp_300kHz_81_82 = mean([PtP_BurstHydrophone_Calib_200C_1Vpp_300kHz_81 PtP_BurstHydrophone_Calib_200C_1Vpp_300kHz_82]);


% figure
% for i =1:size(BurstHydrophone,1)
%     plot(BurstHydrophone(i,:))
%     hold on
% end
% figure
% for i =1:size(BurstHydrophone,1)
%     plot(BurstHydrophone_Calib_200C_1Vpp_300kHz_81(i,:))
%     hold on
% end


%% Import data free field
cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Matlab\SessionAttenuation\1Vpp_200Cycles_Session1\SansCrane
load('UltrasoundParameters_SessionAttenuation_SansCrane_1Vpp_200Cycles_6Freq_Sans_1_300kHz.mat', 'BurstHydrophone')
BurstHydrophone_1Vpp_200Cyc_300kHz_1 = BurstHydrophone;

cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Matlab\SessionAttenuation\1Vpp_200Cycles_Session2\SansCrane
load('UltrasoundParameters_SessionAttenuation_SansCrane_1Vpp_200Cycles_6Freq_Sans_2_300kHz.mat', 'BurstHydrophone')
BurstHydrophone_1Vpp_200Cyc_300kHz_2 = BurstHydrophone;

cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Matlab\SessionAttenuation\1Vpp_200Cycles_Session3\SansCrane
load('UltrasoundParameters_SessionAttenuation_SansCrane_1Vpp_200Cycles_6Freq_Sans_3_300kHz.mat', 'BurstHydrophone')
BurstHydrophone_1Vpp_200Cyc_300kHz_3 = BurstHydrophone;

cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Matlab\SessionAttenuation\1Vpp_200Cycles_Session4\SansCrane
load('UltrasoundParameters_SessionAttenuation_SansCrane_1Vpp_200Cycles_6Freq_Sans_4_300kHz.mat', 'BurstHydrophone')
BurstHydrophone_1Vpp_200Cyc_300kHz_4 = BurstHydrophone;

cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Matlab\SessionAttenuation\1Vpp_200Cycles_Session5\SansCrane
load('UltrasoundParameters_SessionAttenuation_SansCrane_1Vpp_200Cycles_6Freq_Sans_5_300kHz.mat', 'BurstHydrophone')
BurstHydrophone_1Vpp_200Cyc_300kHz_5 = BurstHydrophone;

PtP_BurstHydrophone_1Vpp_200Cyc_300kHz_1 = max(BurstHydrophone_1Vpp_200Cyc_300kHz_1(26,83,end-200:end))-min(BurstHydrophone_1Vpp_200Cyc_300kHz_1(26,83,end-200:end));
PtP_BurstHydrophone_1Vpp_200Cyc_300kHz_2 = max(BurstHydrophone_1Vpp_200Cyc_300kHz_2(26,85,end-200:end))-min(BurstHydrophone_1Vpp_200Cyc_300kHz_2(26,85,end-200:end));
PtP_BurstHydrophone_1Vpp_200Cyc_300kHz_3 = max(BurstHydrophone_1Vpp_200Cyc_300kHz_3(27,86,end-200:end))-min(BurstHydrophone_1Vpp_200Cyc_300kHz_3(27,86,end-200:end));
PtP_BurstHydrophone_1Vpp_200Cyc_300kHz_4 = max(BurstHydrophone_1Vpp_200Cyc_300kHz_4(26,85,end-200:end))-min(BurstHydrophone_1Vpp_200Cyc_300kHz_4(26,85,end-200:end));
PtP_BurstHydrophone_1Vpp_200Cyc_300kHz_5 = max(BurstHydrophone_1Vpp_200Cyc_300kHz_5(27,85,end-200:end))-min(BurstHydrophone_1Vpp_200Cyc_300kHz_5(27,85,end-200:end));

Mean_PtP_BurstHydrophone_1Vpp_200Cyc_300kHz = mean([PtP_BurstHydrophone_1Vpp_200Cyc_300kHz_1 PtP_BurstHydrophone_1Vpp_200Cyc_300kHz_2 PtP_BurstHydrophone_1Vpp_200Cyc_300kHz_3 PtP_BurstHydrophone_1Vpp_200Cyc_300kHz_4 PtP_BurstHydrophone_1Vpp_200Cyc_300kHz_5]);
%%
figure
plot(squeeze(BurstHydrophone_1Vpp_200Cyc_300kHz_1(26,83,:)))
hold on
plot(squeeze(BurstHydrophone_1Vpp_200Cyc_300kHz_2(26,85,:)))
plot(squeeze(BurstHydrophone_1Vpp_200Cyc_300kHz_3(27,86,:)))
plot(squeeze(BurstHydrophone_1Vpp_200Cyc_300kHz_4(26,85,:)))
plot(squeeze(BurstHydrophone_1Vpp_200Cyc_300kHz_5(27,85,:)))
title('Burst hydrophone Sans calibreur @ distance focale')

figure
plot(BurstHydrophone_Calib_200C_1Vpp_300kHz_81(1,:))
hold on
plot(BurstHydrophone_Calib_200C_1Vpp_300kHz_82(1,:))
title('Burst hydrophone Sans calibreur @ distance focale')



%% Import data calibrator to correct
FoC = Mean_PtP_BurstHydrophone_1Vpp_200Cyc_300kHz/Mean_PtP_BurstHydrophone_Calib_200C_1Vpp_300kHz_81_82;
cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Analyse_Sessions_AvecProto_1mm\Mesures_NewCalibrationHydrophone_WithMatchingImpedance\600mVpp_300kHz_200C_82\data
load('Resultats_Analyse_200Cyc_06Vpp_300kHz_82_WithImpNetw_withoutCorr', 'Tension_Hydrophone_06Vpp_200C_300kHz_Rect')

NumberOfCycles = 200;
UltrasoundBurstFrequency = 300000;
SamplingFrequency = 1000000;
ToneBurstDuration = NumberOfCycles * 1/UltrasoundBurstFrequency  ;
DutyCycle = ToneBurstDuration* 1000 * 1;
HydrophoneSensitivity = 0.799;
VecteurTemps_FunctionGen = 0:1/SamplingFrequency:30000/SamplingFrequency;
UltrasoundBurstPeriod = 1/UltrasoundBurstFrequency;
SonicationDuration=0.3;

for i=1:size(Tension_Hydrophone_06Vpp_200C_300kHz_Rect,1)
    Tension_Hydrophone_FreeField_06Vpp_200C_300kHz_Corr2(i,:) = Tension_Hydrophone_06Vpp_200C_300kHz_Rect(i,:)-mean(Tension_Hydrophone_06Vpp_200C_300kHz_Rect(i,2000:end));
    [ValPic, NumCycle] = findpeaks(Tension_Hydrophone_FreeField_06Vpp_200C_300kHz_Corr2(i,:),'MINPEAKHEIGHT',0.01);
    PeakValue_Hydrophone_FreeField_06Vpp_200C_300kHz(i,:) = ValPic(1);
    NumCycle_Hydrophone_FreeField_06Vpp_200C_300kHz(i,:)=NumCycle(1);
    
    InitBurst = NumCycle_Hydrophone_FreeField_06Vpp_200C_300kHz(i,:)-ceil((0.5*UltrasoundBurstPeriod*SamplingFrequency));
    if InitBurst==0
        InitBurst=1;
    end
    EndBurst = NumCycle_Hydrophone_FreeField_06Vpp_200C_300kHz(i,:)+ceil((NumberOfCycles*UltrasoundBurstPeriod*SamplingFrequency));
    BurstHydrophone_FreeField_06Vpp_200C_300kHz(i,:) = ((Tension_Hydrophone_FreeField_06Vpp_200C_300kHz_Corr2(i,InitBurst:EndBurst)).*1000000)./HydrophoneSensitivity; %% Attention facteur d'échelle % * 1000000 pour passer en µV /0.99 pour avoir des Pa
    BurstHydrophone_FreeField_06Vpp_200C_300kHz_Corr(i,:) = BurstHydrophone_FreeField_06Vpp_200C_300kHz(i,:).*FoC;
    TimeVector_BurstHydrophone_FreeField_06Vpp_200C_300kHz_Corr(i,:) = VecteurTemps_FunctionGen(InitBurst:EndBurst);
    PeakPressure(i,:) = max(BurstHydrophone_FreeField_06Vpp_200C_300kHz_Corr(i,end-200:end));
    Isppa1(i,:) = (PeakPressure(i,:)^2)/(2*1028*1515);
    MI1(i,:) = (PeakPressure(i,:).*1e-6)./sqrt(UltrasoundBurstFrequency*1e-6);
    [Pi_FreeField_06Vpp_200C_300kHz_Corr(i,:),Isppa_FreeField_06Vpp_200C_300kHz_Corr(i,:),Ispta_FreeField_06Vpp_200C_300kHz_Corr(i,:),MI_FreeField_06Vpp_200C_300kHz_Corr(i,:), TI_FreeField_06Vpp_200C_300kHz_Corr(i,:)] = ultrasoundParameters(BurstHydrophone_FreeField_06Vpp_200C_300kHz_Corr(i,:),TimeVector_BurstHydrophone_FreeField_06Vpp_200C_300kHz_Corr(i,:),1028,1515,UltrasoundBurstFrequency,DutyCycle,SamplingFrequency,SonicationDuration);
end

mean(Isppa_FreeField_06Vpp_200C_300kHz_Corr)
mean(Isppa1)
cd D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Matlab\Evaluation06Vpp_300kHz_200C
save('Results_Evaluation_Data_Corrected_for_calibrationpart_06_200_ImpNetw_June_82')

% for i =1:size(BurstHydrophone_NewCalib_06Vpp_200C_300kHz_Corr,1)
%    plot(BurstHydrophone_NewCalib_06Vpp_200C_300kHz_Corr(i,:))
% end
% 
% hold on
% for j =1:size(BurstHydrophone_NewCalib_06Vpp_200C_300kHz_Corr,1)
%    plot(BurstHydrophone_FreeField_06Vpp_200C_300kHz_Corr2(j,:))
% end

%%
figure
for j=1:size(BurstHydrophone_FreeField_06Vpp_200C_300kHz,1)
   plot(BurstHydrophone_FreeField_06Vpp_200C_300kHz(j,:))
   hold on
end
title('Burst hydrophone 0.6 Vpp Raw')

figure
for j=1:size(BurstHydrophone_FreeField_06Vpp_200C_300kHz_Corr,1)
   plot(BurstHydrophone_FreeField_06Vpp_200C_300kHz_Corr(j,:))
   hold on
end
title('Burst hydrophone 0.6 Vpp in freefield evaluated with Method 2 - data from June')

figure
plot(squeeze(BurstHydrophone_Tension_06Vpp_Evaluated_WithImpedanceNetwork))
title('Burst hydrophone 0.6 Vpp in freefield evaluated with Method 1')
%% Sum up results

Isppa_Evaluated_Method1 = [11.759 13.815 12.575 12.287 10.359 13.234]; % [Session Attenuation -> Session Avril]
Isppa_Evaluated_Method2 = [11.751 12.836]; % Si 20 mm 

Isppa1_Evaluated_Method1 = [12.196 13.871 12.648 12.503 10.229 13.681]; % [Session Attenuation -> Session Avril]
Isppa1_Evaluated_Method2 = [9.2052 10.485]; % Si 20 mm 


Alpha =  11.69;
EpaisseurCrane = 0.7; %[cm]
UltrasoundBurstFrequency = 300000;
NumberOfCycles = 200;
UltrasoundBurstPeriod = 1/UltrasoundBurstFrequency;
PulseRepetitonFrequency = 1; %!!!![kHz]
ToneBurstDuration = NumberOfCycles * UltrasoundBurstPeriod  ;
DutyCycle = ToneBurstDuration* 1000 * PulseRepetitonFrequency;% *1000 pour avoir des [ms] et pour le calcul du DutyCycle la PRF est en [kHz]

%results from the measures witht the calibration prototype 0.6Vpp @300 kHz
%from 25->20 mm 
% Isppa = [19.83514/1.3152 16.90659/1.3152 13.20256/1.3152 13.44037/1.3152 12.30221/1.3152 18.29359/1.3152]; % Isppa = [9.1167 8.7850 8.1515 7.8133 6.9518];

% Isppa = [19.83514 16.90659 13.20256 13.44037 12.30221 18.29359]; % Isppa = [9.1167 8.7850 8.1515 7.8133 6.9518];
% mean(Isppa)

Isppa_InSitu_Method1 = mean(Isppa_Evaluated_Method1)./(10.^(Alpha.*(EpaisseurCrane/10)))
Ispta_InSitu_Method1 = Isppa_InSitu_Method1.*DutyCycle

Isppa_InSitu_Method2 = mean(Isppa_Evaluated_Method2)./(10.^(Alpha.*(EpaisseurCrane/10)))
Ispta_InSitu_Method2 = Isppa_InSitu_Method2.*DutyCycle
