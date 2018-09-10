%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analyse des données des "hydrophones" crées via un modèle dans Wave3000 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Params

NumberOfCycles = 5;
SonicationDuration = 0.3 ;% time in second

VoltagePP = 1 ;%[Vpp]
DistanceTransducteurHydrophone = 5; %[mm]

Density = 1028;
SoundVelocity = 1515;
UltrasoundBurstFrequency = 500000;
UltrasoundBurstPeriod = 1/UltrasoundBurstFrequency;
PulseRepetitonFrequency = 1; %!!!![kHz]
ToneBurstDuration = NumberOfCycles * UltrasoundBurstPeriod * 1000 ;% *1000 pour avoir des [ms] et pour le calcul du DutyCycle la PRF est en [kHz]
DutyCycle = ToneBurstDuration * PulseRepetitonFrequency;
AttenuationCoefficient = 0.3 ; % [dB/(cm*MHz)]

%% Boucle permettant de sauver dans des variables les colonnes de chaque fichier


SamplingFrequency = 60000000;



plot(AbsoluteTimeData{:,3},LongitudinalHydrophoneData{:,3})
hold on
plot(AbsoluteTimeData{:,3},TransversalHydrophoneData{:,3},'r')

% 
% %% Creation d'une variable de type "table" afin de pouvoir plus facilement traiter les données par après
% 
% Results = table(TimeStepData,AbsoluteTimeData,LongitudinalHydrophoneData,TransversalHydrophoneData);
% 
% 
% 
% plot(Results.AbsoluteTimeData,Results.LongitudinalHydrophoneData)

%% Sauvegarde des résultats dans un fichier Excell

Titel = ['Resultats_' RootDir(1,73:end) '.xls'];
writetable(Results,Titel)