%%
RootDir = uigetdir;
DataFilesName = dir(RootDir);
DataFilesName(1:2) = []; % delete . and .
cd(RootDir)
NameFile = {};
for ii=1:length(DataFilesName)
    filename = fullfile(RootDir,DataFilesName(ii).name);
    NameFile{ii,1} = filename;
    st=NameFile{ii};
    idx=strfind(st,'_81_')+4;
    idx2=strfind(st,'.tdms')-1;
    stval(ii)=str2num(st(idx:idx2));
    [a,b]=sort(stval);
end;
NameFile2=NameFile(b);

for i=1:length(NameFile2)
    [finalOutput,metaStruct] = TDMS_readTDMSFile(NameFile2{i,1});
    %             plot(finalOutput.data{:,3}) % genfunction
    Tension_Hydrophone_06Vpp_200C_300kHz(i,:) = finalOutput.data{:,3};
end;


NumberOfCycles = 200;
UltrasoundBurstFrequency = 300000;
SamplingFrequency = 1000000;
ToneBurstDuration = NumberOfCycles * 1/UltrasoundBurstFrequency  ;
DutyCycle = ToneBurstDuration* 1000 * 1;
HydrophoneSensitivity = 0.799;
VecteurTemps_FunctionGen = 0:1/SamplingFrequency:3000/SamplingFrequency;
UltrasoundBurstPeriod = 1/UltrasoundBurstFrequency;
SonicationDuration=0.3;
Density = 1028;
SoundVelocity = 1515;
% Tension_Hydrophone_06Vpp_200C_300kHz = Tension_Hydrophone_06Vpp_200C_300kHz/0.8;

for i=1:size(Tension_Hydrophone_06Vpp_200C_300kHz,1)
    Tension_Hydrophone_06Vpp_200C_300kHz_Rect(i,:) = Tension_Hydrophone_06Vpp_200C_300kHz(i,:)-mean(Tension_Hydrophone_06Vpp_200C_300kHz(i,2000:end));
    [ValPic, NumCycle] = findpeaks(Tension_Hydrophone_06Vpp_200C_300kHz_Rect(i,:),'MINPEAKHEIGHT',0.01);
    PeakValue_Hydrophone_06Vpp_200C_300kHz(i,:) = ValPic(1);
    NumCycle_Hydrophone_06Vpp_200C_300kHz(i,:)=NumCycle(1);
    
    InitBurst = NumCycle_Hydrophone_06Vpp_200C_300kHz(i,:)-ceil((0.5*UltrasoundBurstPeriod*SamplingFrequency));
    if InitBurst==0
        InitBurst=1;
    end
    EndBurst = NumCycle_Hydrophone_06Vpp_200C_300kHz(i,:)+ceil((NumberOfCycles*UltrasoundBurstPeriod*SamplingFrequency));
    BurstHydrophone_06Vpp_200C_300kHz(i,:) = ((Tension_Hydrophone_06Vpp_200C_300kHz_Rect(i,InitBurst:EndBurst)).*1000000)./HydrophoneSensitivity; %% Attention facteur d'échelle % * 1000000 pour passer en µV /0.99 pour avoir des Pa
    TimeVector_BurstHydrophone_1Vpp_200C_300kHz(i,:) = VecteurTemps_FunctionGen(InitBurst:EndBurst);
    PeakPressure(i,:) = max(BurstHydrophone_06Vpp_200C_300kHz(i,end-200:end));
    PtPPressure(i,:) = max(BurstHydrophone_06Vpp_200C_300kHz(i,end-200:end))-min(BurstHydrophone_06Vpp_200C_300kHz(i,end-200:end));
    Isppa1(i,:) = (PeakPressure(i,:)^2)/(2*Density*SoundVelocity);    
    MI1(i,:) = (PeakPressure(i,:).*1e-6)./sqrt(UltrasoundBurstFrequency*1e-6); 
    [Pi_06Vpp_200C_300kHz(i,:),Isppa_06Vpp_200C_300kHz(i,:),Ispta_06Vpp_200C_300kHz(i,:),MI_06Vpp_200C_300kHz(i,:), TI_06Vpp_200C_300kHz(i,:)] = ultrasoundParameters(BurstHydrophone_06Vpp_200C_300kHz(i,:),TimeVector_BurstHydrophone_1Vpp_200C_300kHz(i,:),Density,SoundVelocity,UltrasoundBurstFrequency,DutyCycle,SamplingFrequency,SonicationDuration);
    
end
%    Isppa2(i,:) = (PtPPressure(i,:)^2)/(2*1024*1515);
Isppa1=Isppa1/10000; %from W/m² to W/cm²
% save('Resultats_Analyse_200Cyc_1Vpp_300kHz_81')

save('Resultats_Analyse_200Cyc_06Vpp_300kHz_81_WithImpNetw_withoutCorr')
%%
figure
for i = 1:size(BurstHydrophone_06Vpp_200C_300kHz)
 plot(BurstHydrophone_06Vpp_200C_300kHz(i,:))
 hold on
end

title('Calibreur @ 81 mm - November - 0.6Vpp')