%% Traitement des fichiers suite à l'analyse des mesures sur oscilloscope afin de les présenter en tableau
clear all;
Color_Plot = {'r' 'b' 'c' 'g' 'y' 'm' 'k' 'r.' 'b.' 'c.'}; 

DataFiles = [];
DataFiles.FileName = {};
DataFiles.Burst_Tension_Pogrammee = [];
DataFiles.Burst_Tension_Positive_Moyenne_Maximum = []; % valeur moyenne de l'ensemble des pics détectés
DataFiles.Burst_Tension_Positive_EcartType = [];
DataFiles.Burst_Tension_Negative_Moyenne_Maximum = [];
DataFiles.Burst_Tension_Negative_EcartType = [];
DataFiles.Burst_Frequence = [];
DataFiles.DutyCycle_Valeur_Moyenne = [];
DataFiles.DutyCycle_EcartType = [];

RootDir = uigetdir;
FilesName = dir(RootDir);
FilesName(1:2) = []; % delete . and ..

cd(RootDir)

for s=1:length(FilesName)
    
    datafilename = FilesName(s).name;
    load(datafilename);
    DataFiles.FileName{end+1,1} = datafilename;
    DataFiles.Burst_Tension_Pogrammee{end+1,1} = Tension_Prevue;
    DataFiles.Burst_Tension_Positive_Moyenne_Maximum{end+1,1} = Burst_Tension_Maximum_Positive_Moyenne;
    DataFiles.Burst_Tension_Positive_EcartType{end+1,1} = Burst_EcartType_Tension_Maximum_Positive_Moyenne;
    DataFiles.Burst_Tension_Negative_Moyenne_Maximum{end+1,1} = Burst_Tension_Maximum_Negative_Moyenne;
    DataFiles.Burst_Tension_Negative_EcartType{end+1,1} = Burst_EcartType_Tension_Maximum_Negative_Moyenne;
    DataFiles.Burst_Frequence{end+1,1} = FFT_Burst_Freq_Centrale;
    DataFiles.DutyCycle_Valeur_Moyenne{end+1,1} = DutyCycle_Tension_Moyenne;
    DataFiles.DutyCycle_EcartType{end+1,1} = DutyCycle_EcartType;
    
    
    plot(FFT_Burst_Frequence,2*abs(FFT_Burst_Amplitude(1:NFFT1/2+1)),Color_Plot{s})
    hold on
    
end
legend(DataFiles.FileName)
title('Analyse frequentielle des burst générés à 200kHz une une fréquence de répétition de 3kHz')
figure()
for j=1:length(DataFiles.FileName)
 
errorbar(DataFiles.Burst_Tension_Pogrammee{j,1},DataFiles.Burst_Tension_Positive_Moyenne_Maximum{j,1},DataFiles.Burst_Tension_Positive_EcartType{j,1},'.')
hold on

end


l = length(DataFiles.FileName);
savetable('Resultats_Analyse_Burst',DataFiles,l)
save('Resultats_Analyse_Burst','DataFiles')

