%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analyse des données des "hydrophones" crées via un modèle dans Wave3000 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Import du nom de l'ensemble des fichiers contenu dans le dossier sélectionné
RootDir = uigetdir;
DataFilesName = dir(RootDir);
DataFilesName(1:2) = []; % delete . and ..
cd(RootDir)

%% Boucle permettant de sauver dans des variables les colonnes de chaque fichier
for s = 1:length(DataFilesName)
    
    filename = fullfile(RootDir,DataFilesName(s).name);
    A = importdata(filename);
    TimeStepData{:,s} = A(:,1);
    AbsoluteTimeData{:,s} = A(:,2);
    LongitudinalHydrophoneData{:,s} = A(:,3);
    TransversalHydrophoneData{:,s} = A(:,4);
end

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

%%
plot(Time_07Scale,Pressure_500kHz)


dt = 0.0328*1e-06; % le temps fournit lors du démarrrage de la simulation est en microsecondes
SamplingFrequency = 1/dt;
PeakThreshold = 3;
UltrasoundBurstFrequency = 500000;
UltrasoundBurstPeriod = 1/UltrasoundBurstFrequency;
NumberOfCycles = 5;
SonicationDuration = 0.3 ;% time in second
Density = 1028;
SoundVelocity = 1515;

PulseRepetitonFrequency = 1; %!!!![kHz]
ToneBurstDuration = NumberOfCycles * UltrasoundBurstPeriod * 1000 ;% *1000 pour avoir des [ms] et pour le calcul du DutyCycle la PRF est en [kHz]
DutyCycle = ToneBurstDuration * PulseRepetitonFrequency;
AttenuationCoefficient = 0.3 ; % [dB/(cm*MHz)]

% ! l'amplitude de l'onde de pression est exprimée en 1000GPa!!!

%% Détection de pic pour découpage
[ValPic, NumCycle] = findpeaks(Pressure_500kHz,'MINPEAKHEIGHT',PeakThreshold);


InitBurst = NumCycle-ceil((0.5*UltrasoundBurstPeriod*SamplingFrequency));
EndBurst = NumCycle+ceil((NumberOfCycles*UltrasoundBurstPeriod*SamplingFrequency));
A=length(InitBurst:EndBurst);

BurstHydrophone = Pressure_500kHz(InitBurst:EndBurst).*1000*1e9; %% Attention facteur d'échelle % * 1000000 pour passer en µV /0.99 pour avoir des Pa
TimeVector_BurstHydrophone = Time_07Scale(InitBurst:EndBurst).*1e3; %pour etre en ms
   
        %[Pi_Complet(x,y,:),Isppa_Complet(x,y,:),Ispta_Complet(x,y,:),mechanicalIndex_Complet(x,y,:)] = ultrasoundParameters((Tension_Hydrophone_Corr_Filtre_Rot15(x,y,:).*1000000)./0.99,VecteurTemps_FunctionGen_5Cycles_Rot15(x,y,:),Density,SoundVelocity,UltrasoundBurstFrequency,DutyCycle);  
[Pi,Isppa,Ispta,MI, TI] = ultrasoundParameters(BurstHydrophone,TimeVector_BurstHydrophone,Density,SoundVelocity,UltrasoundBurstFrequency,DutyCycle,SamplingFrequency,SonicationDuration);





