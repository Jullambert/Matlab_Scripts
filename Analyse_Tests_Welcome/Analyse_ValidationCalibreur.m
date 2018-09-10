%%
clear all
clc

%%
NumberOfTrials = 1;
%Parametres liés à 1) l'enregistrement des données et 2) aux stimulations apr US réalisées 
SamplingFrequency = 10000000;%pour 200 cycles %60000000; %pour 5 cycles
CutoffFrequency = 1000000;
NumberOfCycles = 200; % 5
SonicationDuration = 0.3 ;% time in second
NumberSamplesRecorded =  30000;%20000; %pour 5 cycles

Density = 1028;
SoundVelocity = 1515;
UltrasoundBurstFrequency = 250000;
UltrasoundBurstPeriod = 1/UltrasoundBurstFrequency;
PulseRepetitonFrequency = 1; %!!!![kHz]
ToneBurstDuration = NumberOfCycles * UltrasoundBurstPeriod  ;
DutyCycle = ToneBurstDuration* 1000 * PulseRepetitonFrequency;% *1000 pour avoir des [ms] et pour le calcul du DutyCycle la PRF est en [kHz]
AttenuationCoefficient = 0.3 ; % [dB/(cm*MHz)]

VoltagePP = 1;
switch VoltagePP
    case 2.6
        DistanceTransducteurHydrophone = 5.7; %[mm]
        
        switch UltrasoundBurstFrequency 
            case 250000
                HydrophoneSensitivity = 0.84;
                PeakThreshold_Hydrophone = 4000/1000000; %3700 ;
            case 350000
                HydrophoneSensitivity = 0.99;
                PeakThreshold_Hydrophone = 4500/1000000; %
            case 500000
                HydrophoneSensitivity = 1.22;
                PeakThreshold_Hydrophone = 4100/1000000; %
        end
    case 2
        DistanceTransducteurHydrophone = 5.7; %[mm]
        
        switch UltrasoundBurstFrequency 
            case 250000
                HydrophoneSensitivity = 0.84;
                PeakThreshold_Hydrophone = 4000/1000000; %3700 ;
            case 350000
                HydrophoneSensitivity = 0.99;
                PeakThreshold_Hydrophone = 4500/1000000; %
            case 500000
                HydrophoneSensitivity = 1.22;
                PeakThreshold_Hydrophone = 4100/1000000; %
        end
    case 1.3
        DistanceTransducteurHydrophone = 5.24; %6; %[mm]close all
        
        switch UltrasoundBurstFrequency 
            case 250000
                HydrophoneSensitivity = 0.84;
                PeakThreshold_Hydrophone = 2400/1000000;
            case 350000
                HydrophoneSensitivity = 0.99;
                PeakThreshold_Hydrophone = 2350/1000000;
            case 500000
                HydrophoneSensitivity = 1.22;
                PeakThreshold_Hydrophone = 2250/1000000;
        end
        
    case 1.2
        DistanceTransducteurHydrophone = 5.24; %5.92; %[mm]
        switch UltrasoundBurstFrequency 
            case 250000
                HydrophoneSensitivity = 0.84;
                PeakThreshold_Hydrophone = 2500/1000000;
            case 350000
                HydrophoneSensitivity = 0.99;
                PeakThreshold_Hydrophone = 2600/1000000;
            case 500000
                HydrophoneSensitivity = 1.22;
                PeakThreshold_Hydrophone = 2300/1000000;
        end 
    
    case 1
        DistanceTransducteurHydrophone = 6.34;%(SessionAttenuation 20 cycles_1)%5.3; % ( SessionAttenuation 5)% 5.2;%(SessionAttenuation4 SansCrane)%5.74; %(SessionAttenuation3 SansCrane) 5.1; %(SessionAttenuation2 SansCrane)%5.6; %(SessionAttenuation1 SansCrane) %5.7; %(proto_Zero_Protection %10.6; %(protoMoinsDix)%5.4;%(pour proto Zero)%5.5 ;%(pour proto hors)%5.6;%(pour 20 Deg)%5.54; %%(pour10Deg)%5.6; %(pour5Deg);%5.3; %(pour-10)%5.24;%(pour0Deg) ;%5.28;%(pour -5deg)%5.54; %%(pour10Deg) %4.64; %5.4; %[mm] 5.6 pour nouvelle pièce d'alignement
        switch UltrasoundBurstFrequency 
            case 250000
                HydrophoneSensitivity = 0.84;
                PeakThreshold_Hydrophone = 4400/1000000; %2700/1000000; %50/1000000;3300/1000000;
            case 300000
                HydrophoneSensitivity = 0.91;
                PeakThreshold_Hydrophone = 3000/1000000; %
            case 350000
                HydrophoneSensitivity = 0.99;
                PeakThreshold_Hydrophone = 4000/1000000; %2800 pr 5 cycles
            case 400000
                HydrophoneSensitivity = 1.07;
                PeakThreshold_Hydrophone = 4200/1000000; %
            case 450000
                HydrophoneSensitivity = 1.14;
                PeakThreshold_Hydrophone = 3750/1000000; %
            case 500000
                HydrophoneSensitivity = 1.22;
                PeakThreshold_Hydrophone = 3700/1000000; % 3500/1000000;2300 pour 5 cycles
        end
    case 0.8
        DistanceTransducteurHydrophone = 5.24; %5.2; %[mm]
        switch UltrasoundBurstFrequency 
            case 250000
                HydrophoneSensitivity = 0.84;
                PeakThreshold_Hydrophone = 2300/1000000;
            case 350000
                HydrophoneSensitivity = 0.99;
                PeakThreshold_Hydrophone = 2400/1000000;
            case 500000
                HydrophoneSensitivity = 1.22;
                PeakThreshold_Hydrophone = 2300/1000000; %
        end
        
    case 0.6
        DistanceTransducteurHydrophone = 5.24; %5; %[mm]
        switch UltrasoundBurstFrequency 
            case 250000
                HydrophoneSensitivity = 0.84;
                PeakThreshold_Hydrophone = 2100/1000000; %2200 ou 2300
            case 350000
                HydrophoneSensitivity = 0.99;
                PeakThreshold_Hydrophone = 2200/1000000;
            case 500000
                HydrophoneSensitivity = 1.22;
                PeakThreshold_Hydrophone = 2200/1000000;
        end
end
%Params pour détection de pics
PeakThreshold_FunctionGen = 0.1;
% PeakThreshold_Hydrophone = 0.0025; % 0.006 pour 1Vpp 0.003 pour 0.6Vpp

% Params FFT
NSamples = 2^14;
T= [0:(NSamples-1)]/SamplingFrequency;
Freq_Axis = (-SamplingFrequency/2)+[0:NSamples-1]/NSamples*SamplingFrequency; % Permet de créer un vecteur qui va de -fs/2 à 1 echnatillon avant Fs/2
Haar = (-1).^([0:NSamples-1]); % permet de recentrer les données en 0
Haar = Haar';
Index_Freq_Interest = round(UltrasoundBurstFrequency/SamplingFrequency*NSamples+NSamples/2+1);


%%
listing=dir;
listing(listing.isdir);
listing([1:2])=[];

for ii=1:size(listing,1)
    st=listing(ii).name(1,:);
    idx=strfind(st,'Air_')+4;
    idx2=strfind(st,'_Freq')-1;
    stval(ii)=str2num(st(idx:idx2));
    [a,b]=sort(stval);
end;
listing2=listing(b);

%%
for i=1:NumberOfTrials
    [finalOutput,metaStruct] = TDMS_readTDMSFile(listing2(i).name(1,:));
    %             plot(finalOutput.data{:,3}) % genfunction
    Tension_FunctionGen(i,1:length(finalOutput.data{:,3})) = finalOutput.data{:,3};
    Tension_Hydrophone(i,1:length(finalOutput.data{:,4})) = finalOutput.data{:,4};
    DeltaT = finalOutput.propValues{1,3}{1,3};
    VecteurTemps_FunctionGen(i,1:length(finalOutput.data{:,3})) = (0:DeltaT(1):(length(Tension_FunctionGen(i,:))-1)*DeltaT(1));

    clear finalOutput
    clear metaStruct
end
%%

for j=1:NumberOfTrials
%Calcul de l'offset pour les deux séries de valeurs
Offset_FunctionGen(j,:) = mean(Tension_FunctionGen(j,1:5000));
Offset_Hydrophone(j,:) = mean(Tension_Hydrophone(j,1:5000));

%Correction de l'offset
Tension_FunctionGen_Corr(j,:)= Tension_FunctionGen(j,:) - Offset_FunctionGen(j,:);
Tension_Hydrophone_Corr(j,:)= Tension_Hydrophone(j,:) - Offset_Hydrophone(j,:);

[B A] = butter(2,CutoffFrequency/(SamplingFrequency/2),'low');
Tension_FunctionGen_Corr_Filtre(j,:)= filtfilt(B, A,Tension_FunctionGen_Corr(j,:));
Tension_Hydrophone_Corr_Filtre(j,:)= filtfilt(B, A,Tension_Hydrophone_Corr(j,:));

Vecteur_Tension_FunctionGen = squeeze(Tension_FunctionGen(j,10000:end));
[ValPic, NumCycle] = findpeaks(Vecteur_Tension_FunctionGen,'MINPEAKHEIGHT',PeakThreshold_FunctionGen);
PeakValue_FunctionGen(j,:) = ValPic(1);
NumCycle_FunctionGen(j,:) = NumCycle(1)+9999;
        
Vecteur_Tension_Hydrophone = squeeze(Tension_Hydrophone(j,NumCycle_FunctionGen(j,:):end)); % .*1000000 pour obtenir des µV
[ValPic2, NumCycle2] = findpeaks(Vecteur_Tension_Hydrophone,'MINPEAKHEIGHT',PeakThreshold_Hydrophone);
PeakValue_Hydrophone(j,:) = ValPic2(1);
NumCycle_Hydrophone(j,:) = NumCycle2(1)+NumCycle_FunctionGen(j,:)-1;

end
%%
for k=1:NumberOfTrials
InitBurst = NumCycle_Hydrophone(k,:)-ceil((0.5*UltrasoundBurstPeriod*SamplingFrequency));
EndBurst = NumCycle_Hydrophone(k,:)+ceil((NumberOfCycles*UltrasoundBurstPeriod*SamplingFrequency));
A(k,:) = length(InitBurst:EndBurst);
BurstHydrophone(k,:) = ((Tension_Hydrophone_Corr(k,InitBurst:EndBurst)).*1000000)./HydrophoneSensitivity; %% Attention facteur d'échelle % * 1000000 pour passer en µV /0.99 pour avoir des Pa
TimeVector_BurstHydrophone(k,:) = VecteurTemps_FunctionGen(k,InitBurst:EndBurst);

%[Pi_Complet(x,y,:),Isppa_Complet(x,y,:),Ispta_Complet(x,y,:),mechanicalIndex_Complet(x,y,:)] = ultrasoundParameters((Tension_Hydrophone_Corr_Filtre_Rot15(x,y,:).*1000000)./0.99,VecteurTemps_FunctionGen_5Cycles_Rot15(x,y,:),Density,SoundVelocity,UltrasoundBurstFrequency,DutyCycle);  
[Pi(k,:),Isppa(k,:),Ispta(k,:),MI(k,:), TI(k,:)] = ultrasoundParameters(BurstHydrophone(k,:),TimeVector_BurstHydrophone(k,:),Density,SoundVelocity,UltrasoundBurstFrequency,DutyCycle,SamplingFrequency,SonicationDuration);

end


%%


