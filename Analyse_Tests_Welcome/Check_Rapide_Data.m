% [finalOutput,metaStruct] = TDMS_readTDMSFile('C:\Users\jullambert\Nocions_Dropbox\Dropbox (NOCIONS)\jlambert\UCL_PhD\Setup\1Vpp_200Cycles_6Freq_2_Num_Step_  1X_Coordinate_-24_Y_Coordinate_-40Freq_250000.tdms');
[finalOutput,metaStruct] = TDMS_readTDMSFile('D:\data\jlambert\TFUS_Mesures_Welcome\Resultats_Analyse_Sessions_AvecProto_1mm\Mesures_NewCalibrationHydrophone\1Vpp_5Cycles_300kHz_80\data\NewCalibHydro_1Vpp_5cyc_300kHz_80_2.tdms');

%             plot(finalOutput.data{:,3}) % genfunction
Tension_FunctionGen = finalOutput.data{:,3};
Tension_NewCalib_1Vpp_5C_300kHz(2,:) = finalOutput.data{:,3};

figure
plot(Tension_Hydrophone_CableRF_200Cyc_1Vpp_300kHz)

Tension_Hydrophone_Juillet = Tension_Hydrophone;

%%

