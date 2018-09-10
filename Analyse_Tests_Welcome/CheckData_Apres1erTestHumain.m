
figure
plot(squeeze(Tension_Hydrophone_Janvier(27,87,:)))
title('Tension hydrophone janvier')
figure
plot(squeeze(Tension_Hydrophone_Juillet(27,87,:)))
title('Tension hydrophone juillet')
figure
plot(squeeze(Tension_Hydrophone(1,:)-0.19))
title('Tension hydrophone septembre')



TimeVector_BurstHydrophone_200Cyc_1Vpp_300kHz_corr = [15180/10000000:1/10000000:15380/10000000];

[Pi2,Isppa2,Ispta2,MI2, TI2] = ultrasoundParameters((Tension_Hydrophone_Juillet(27,87,15180:15380).*1000000)./HydrophoneSensitivity,TimeVector_BurstHydrophone_200Cyc_1Vpp_300kHz_corr,1028,1515,250000,DutyCycle,10000000,0.3);

mechanicalIndex = (abs(min((Tension_Hydrophone(1,23:43)-0.18).*1000000./HydrophoneSensitivity)*1e-6)/(sqrt(250000*1e-6)));
mechanicalIndex2 = (abs(min(Tension_Hydrophone_Juillet(27,87,15180:15380).*1000000./HydrophoneSensitivity)*1e-6)/(sqrt(250000*1e-6)));



[Pi,Isppa,Ispta,MI, TI] = ultrasoundParameters((Tension_Hydrophone_corr.*1000000)./HydrophoneSensitivity,TimeVector_BurstHydrophone_200Cyc_1Vpp_300kHz_corr,1028,1515,250000,DutyCycle,1000000,0.3);



Tension_Hydrophone_200Cyc_14Vpp_300kHz_corr = Tension_Hydrophone_5Cyc_1Vpp_300kHz-0.22;





%% 300 kHz
NumberOfCycles = 200;
UltrasoundBurstFrequency = 300000;
SamplingFrequency = 1000000;
ToneBurstDuration = NumberOfCycles * 1/UltrasoundBurstFrequency  ;
DutyCycle = ToneBurstDuration* 1000 * 1;
HydrophoneSensitivity = 0.91;
VecteurTemps_FunctionGen = 0:1/1000000:2000/1000000;
UltrasoundBurstPeriod = 1/UltrasoundBurstFrequency;
SonicationDuration=0.3;

for i=1:size(Tension_Hydrophone_CableRF_200Cyc_1Vpp_300kHz_T25,1)
    Tension_Hydrophone_CableRF_200Cyc_1Vpp_300kHz_T25_corr(i,:) = Tension_Hydrophone_CableRF_200Cyc_1Vpp_300kHz_T25(i,:)-mean(Tension_Hydrophone_CableRF_200Cyc_1Vpp_300kHz_T25(i,1500:end));
    [ValPic, NumCycle] = findpeaks(Tension_Hydrophone_CableRF_200Cyc_1Vpp_300kHz_T25_corr(i,:),'MINPEAKHEIGHT',0.04);
    PeakValue_Hydrophone_TestCableRF_200Cyc_300kHz_T25(i,:) = ValPic(1);
    NumCycle_Hydrophone_TestCableRF_200Cyc_300kHz_T25(i,:)=NumCycle(1);
    
    InitBurst = NumCycle_Hydrophone_TestCableRF_200Cyc_300kHz_T25(i,:)-ceil((0.5*UltrasoundBurstPeriod*SamplingFrequency));
    EndBurst = NumCycle_Hydrophone_TestCableRF_200Cyc_300kHz_T25(i,:)+ceil((NumberOfCycles*UltrasoundBurstPeriod*SamplingFrequency));
    BurstHydrophone_TestCableRF_200Cyc_300kHz_T25_corr(i,:) = ((Tension_Hydrophone_CableRF_200Cyc_1Vpp_300kHz_T25_corr(i,InitBurst:EndBurst)).*1000000)./HydrophoneSensitivity; %% Attention facteur d'échelle % * 1000000 pour passer en µV /0.99 pour avoir des Pa
    TimeVector_BurstHydrophone_200Cyc_T25_300kHz(i,:) = VecteurTemps_FunctionGen(InitBurst:EndBurst);
        
    [Pi_TestCableRF_200Cyc_300kHz_T25(i,:),Isppa_TestCableRF_200Cyc_300kHz_T25(i,:),Ispta_TestCableRF_200Cyc_300kHz_T25(i,:),MI_TestCableRF_200Cyc_300kHz_T25(i,:), TI_TestCableRF_200Cyc_300kHz_T25(i,:)] = ultrasoundParameters(BurstHydrophone_TestCableRF_200Cyc_300kHz_T25_corr(i,:),TimeVector_BurstHydrophone_200Cyc_T25_300kHz(i,:),1024,1515,UltrasoundBurstFrequency,DutyCycle,SamplingFrequency,SonicationDuration);
end
 
figure
plot(BurstHydrophone(1,:))
hold on
for i=2:size(BurstHydrophone,1)
   plot(BurstHydrophone(i,:)) 
end
%%
NumberOfCycles = 200;
UltrasoundBurstFrequency = 300000;
SamplingFrequency = 1000000;
ToneBurstDuration = NumberOfCycles * 1/UltrasoundBurstFrequency  ;
DutyCycle = ToneBurstDuration* 1000 * 1;
HydrophoneSensitivity = 0.91;
VecteurTemps_FunctionGen = 0:1/1000000:2000/1000000;
UltrasoundBurstPeriod = 1/UltrasoundBurstFrequency;
SonicationDuration=0.3;

for i=1:size(Tension_Hydrophone_CableUltran_200Cyc_1Vpp_300kHz_dimanche,1)
    Tension_Hydrophone_CableUltran_dimanche_corr(i,:) = Tension_Hydrophone_CableUltran_200Cyc_1Vpp_300kHz_dimanche(i,:)-mean(Tension_Hydrophone_CableUltran_200Cyc_1Vpp_300kHz_dimanche(i,1500:end));
    [ValPic, NumCycle] = findpeaks(Tension_Hydrophone_CableUltran_dimanche_corr(i,:),'MINPEAKHEIGHT',0.02);
    PeakValue_Hydrophone_TestCableUltran_dimanche_corr(i,:) = ValPic(1);
    NumCycle_Hydrophone_TestCableUltran_dimanche_corr(i,:)=NumCycle(1);
    
    InitBurst = NumCycle_Hydrophone_TestCableUltran_dimanche_corr(i,:)-ceil((0.5*UltrasoundBurstPeriod*SamplingFrequency));
    EndBurst = NumCycle_Hydrophone_TestCableUltran_dimanche_corr(i,:)+ceil((NumberOfCycles*UltrasoundBurstPeriod*SamplingFrequency));
    BurstHydrophone_TestCableUltran_dimanche_corr(i,:) = ((Tension_Hydrophone_CableUltran_dimanche_corr(i,InitBurst:EndBurst)).*1000000)./HydrophoneSensitivity; %% Attention facteur d'échelle % * 1000000 pour passer en µV /0.99 pour avoir des Pa
    TimeVector_BurstHydrophone_dimanche_corr(i,:) = VecteurTemps_FunctionGen(InitBurst:EndBurst);
        
    [Pi_TestCableUltran_dimanche(i,:),Isppa_TestCableUltran_dimanche(i,:),Ispta_TestCableUltran_dimanche(i,:),MI_TestCableUltran_dimanche(i,:), TI_TestCableUltran_dimanche(i,:)] = ultrasoundParameters(BurstHydrophone_TestCableUltran_dimanche_corr(i,:),TimeVector_BurstHydrophone_dimanche_corr(i,:),1024,1515,UltrasoundBurstFrequency,DutyCycle,SamplingFrequency,SonicationDuration);
end




%%

figure
plot(BurstHydrophone_TestCableRF_5Cyc_300kHz_corr(1,:))
figure
plot(BurstHydrophone_200Cyc_1Vpp_300kHz_corr(1,:))


figure
plot(Tension_Hydrophone_200Cyc_14Vpp_300kHz_corr(1,:))
hold on
plot(Tension_Hydrophone_200Cyc_14Vpp_300kHz_corr(2,:))
plot(Tension_Hydrophone_200Cyc_14Vpp_300kHz_corr(3,:))
plot(Tension_Hydrophone_200Cyc_14Vpp_300kHz_corr(4,:))
plot(Tension_Hydrophone_200Cyc_14Vpp_300kHz_corr(5,:))
plot(Tension_Hydrophone_200Cyc_14Vpp_300kHz_corr(6,:))
plot(Tension_Hydrophone_200Cyc_14Vpp_300kHz_corr(7,:))
plot(Tension_Hydrophone_200Cyc_14Vpp_300kHz_corr(8,:))
plot(Tension_Hydrophone_200Cyc_14Vpp_300kHz_corr(9,:))
plot(Tension_Hydrophone_200Cyc_14Vpp_300kHz_corr(10,:))

rowMean = sum(A,2) ./ sum(A~=0,2);
