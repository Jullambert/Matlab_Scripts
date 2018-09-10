%% Script réalisé pour analyser les données acquises lors des tests réalisés avec le châssis PXI 1073 + carte PXIe 6368
% On envoie les données sous forme de matrice avec en premiere colonne,lestimulus (captured_data(:,1)
% et en deuxième colonne le signal de synchro
% Cablage :
% AO : 54 - 21
% AI : 34 - 68
% DO : 50 - 17
% DI : 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Import Data + Variables + Analyse
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Constantes
ErreurTension = 0;
ErreurTensionRecorded = 0;
ErreurTensionNegative = 0;
ErreurTensionNegativeRecorded = 0;
count = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Params
Fs = 2000000; % Sampling frequency
Figure_Burst_Plot = 1;
Figure_FFT_Plot = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DataFiles = [];
DataFiles.FileName = {};
DataFiles.Burst_Number_Of_Cycles = [];
DataFiles.Burst_Number_Of_Cycles_Recorded = [];
DataFiles.Burst_Tension_Positive_Programmee = [];
DataFiles.Burst_Tension_Moyenne_Positive_Enregistree = [];
DataFiles.Burst_Erreur_Tension_Positive = [];
DataFiles.Burst_Tension_Negative_Programmee = [];
DataFiles.Burst_Tension_Moyenne_Negative_Enregistree = [];
DataFiles.Burst_Erreur_Tension_Negative = [];
DataFiles.Burst_Valeur_Moyenne_Enregistree = [];
DataFiles.DutyCycle_Valeur_Max_Enregistree = [];
DataFiles.DutyCycle_Valeur_min_Enregistree = [];
DataFiles.Delta_T_Pic = [];

DataFFT = [];
DataFFT.Burst_Programme_Amplitude = [];
DataFFT.Burst_Programme_Frequence = [];
DataFFT.Burst_Enregistre_Amplitude = [];
DataFFT.Burst_Enregistre_Frequence = [];
DataFFT.DutyCycle_Programme_Amplitude = [];
DataFFT.DutyCycle_Programme_Frequence = [];
DataFFT.DutyCycle_Enregistre_Amplitude = [];
DataFFT.DutyCycle_Enregistre_Frequence = [];


RootDir = uigetdir;
FilesName = dir(RootDir);
FilesName(1:2) = []; % delete . and ..

cd(RootDir)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Traitement des données
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for s = 1:length(FilesName)

    datafilename = FilesName(s).name;
    load(datafilename);
    DataFiles.FileName{end+1,1} = datafilename;

    % Récupération des parametres du Burst nécessaires pour les analyses
    DelayOnset = str2double(datafilename(strfind(datafilename,'DeOnset')+7:end-4)) ; % end -4 car les 4 derniers caractères sont ".mat"
    DureeBurst = str2double(datafilename(strfind(datafilename,'D_')+2:strfind(datafilename,'_F')-1)) ;
    FrequenceBurst = str2double(datafilename(strfind(datafilename,'F_')+2:strfind(datafilename,'_M')-1));
    BurstWaveform = StimulusWaveform_Y(DelayOnset*Fs+1:(DelayOnset+DureeBurst)*Fs+1,1);
    BurstWaveformRecorded = captured_data(DelayOnset*Fs+1:(DelayOnset+DureeBurst)*Fs+1,1);
    SeuilPic = str2double(datafilename(strfind(datafilename,'M_')+2:strfind(datafilename,'V_')-1));
    
    PRF = str2double(datafilename(strfind(datafilename,'PRF_')+4:strfind(datafilename,'_St')-1));
    DureeDutyCycle = 1/PRF - DureeBurst;
    DutyCycle = StimulusWaveform_Y((DelayOnset+DureeBurst)*Fs+1:(DelayOnset+DureeBurst+DureeDutyCycle)*Fs+1,1);
    DutyCycleRecorded = captured_data((DelayOnset+DureeBurst)*Fs+1:(DelayOnset+DureeBurst+DureeDutyCycle)*Fs+1,1);
    
    if Figure_Burst_Plot
        figure()
        plot(BurstWaveform,'*-')
        hold on
        plot(BurstWaveformRecorded,'r*-')
    end
    
% 1. Detection du nombre de pics positifs et négatifs pour le burst créé en
% Matlab et générés par la carte PXIe 6368
    [ValPicPositif, NumSamplePositif] = findpeaks(BurstWaveform,'MINPEAKHEIGHT',SeuilPic-0.01*SeuilPic);
    [ValPicNegatif, NumSampleNegatif] = findpeaks(-BurstWaveform,'MINPEAKHEIGHT',SeuilPic-0.01*SeuilPic);
    [ValPicPositifRecorded, NumSamplePositifRecorded] = findpeaks(BurstWaveformRecorded,'MINPEAKHEIGHT',SeuilPic-0.17*SeuilPic);
    [ValPicNegatifRecorded, NumSampleNegatifRecorded] = findpeaks(-BurstWaveformRecorded,'MINPEAKHEIGHT',SeuilPic-0.17*SeuilPic);
    
    
% 2. Vérification du nombre cycles créés en Matlab pour le Burst
    if length(ValPicPositif) == FrequenceBurst*DureeBurst
        disp([' Nombre de cycles générés par Matlab pour le burst ' num2str(length(ValPicPositif))])
        DataFiles.Burst_Number_Of_Cycles{end+1,1} = length(ValPicPositif);
    else
        disp(' Il y a une différence entre le nombre de cycles programmé et théorique')
        DataFiles.Burst_Number_Of_Cycles{end+1,1} = length(ValPicPositif);
    end

% 3. Vérification du nombre cycles générés par la carte PXIe 
    if length(ValPicPositifRecorded) == FrequenceBurst*DureeBurst
        disp([' Nombre de cycle générés par la carte PXIe 6368 pour le burst ' num2str(length(ValPicPositifRecorded))])
        DataFiles.Burst_Number_Of_Cycles_Recorded{end+1,1} = length(ValPicPositifRecorded);
    else
        disp([' Il y a une différence entre le nombre de cycles programmés et enregistrés/envoyés, le nombre est de ' num2str(length(ValPicPositifRecorded))])
        DataFiles.Burst_Number_Of_Cycles_Recorded{end+1,1} = length(ValPicPositifRecorded);
    end
   
% 4. Vérification de la valeur de chaque pic positif créé en Matlab
    for i = 1:length(ValPicPositif)
       if ValPicPositif >= SeuilPic-0.01*SeuilPic
       else
        ErreurTension = 1; 
       end
    end
        
    if ErreurTension
        disp('KO')
    end
DataFiles.Burst_Tension_Positive_Programmee{end+1,1} = SeuilPic;
    
% 5. Vérification de la valeur de chaque pic positif généré par la carte PXIe
    for i = 1:length(ValPicPositifRecorded)
       if ValPicPositifRecorded >= SeuilPic-0.01*SeuilPic
       else
        ErreurTensionRecorded = 1; 
       end
    end

    if ErreurTensionRecorded
        disp(['Tension positive en sortie KO, la valeur moyenne est de ' num2str(mean(ValPicPositifRecorded)) 'V, au lieu de ' num2str(SeuilPic) ])
    end
DataFiles.Burst_Tension_Moyenne_Positive_Enregistree{end+1,1} = mean(ValPicPositifRecorded);
DataFiles.Burst_Erreur_Tension_Positive{end+1,1} = (SeuilPic-mean(ValPicPositifRecorded))/SeuilPic;

% 6. Vérification de la valeur de chaque pic négatif créé en Matlab
    for i = 1:length(ValPicNegatif)
       if ValPicNegatif >= SeuilPic-0.01*SeuilPic
       else
        ErreurTensionNegative = 1; 
       end
    end

    if ErreurTensionNegative
        disp('KO')
    end
DataFiles.Burst_Tension_Negative_Programmee{end+1,1} = SeuilPic;
    
% 7. Vérification de la valeur de chaque pic positif généré par la carte PXIe
    for i = 1:length(ValPicNegatifRecorded)
       if ValPicNegatifRecorded >= SeuilPic-0.01*SeuilPic
       else
        ErreurTensionNegativeRecorded = 1; 
       end
    end

    if ErreurTensionNegativeRecorded
        disp(['Tension négative en sortie KO, la valeur moyenne est de ' num2str(mean(ValPicNegatifRecorded)) 'V, au lieu de ' num2str(SeuilPic) ])
    end
DataFiles.Burst_Tension_Moyenne_Negative_Enregistree{end+1,1} = mean(ValPicNegatifRecorded);
DataFiles.Burst_Erreur_Tension_Negative{end+1,1} = (SeuilPic-mean(ValPicNegatifRecorded))/SeuilPic;    

% 8. Calcul de la valeur moyenen du Burst afin de savoir si le sigal
% produit est bien symétrique
DataFiles.Burst_Valeur_Moyenne_Enregistree{end+1,1} = mean(BurstWaveformRecorded);

% 9. Analyse fft du burst généré par Matlab
L1 = length(BurstWaveform);                     % Length of signal
NFFT1 = 2^nextpow2(L1); % Next power of 2 from length of y
DataFFT.Burst_Programme_Amplitude(:,s) = fft(BurstWaveform,NFFT1)/L1;
DataFFT.Burst_Programme_Frequence(:,s) = Fs/2*linspace(0,1,NFFT1/2+1);

% 10. Analyse fft du burst généré par la carte PXIe
L2 = length(BurstWaveformRecorded);                     % Length of signal
NFFT2 = 2^nextpow2(L2); % Next power of 2 from length of y
DataFFT.Burst_Enregistre_Amplitude(:,s) = fft(BurstWaveformRecorded,NFFT2)/L2;
DataFFT.Burst_Enregistre_Frequence(:,s) = Fs/2*linspace(0,1,NFFT2/2+1);

    if Figure_FFT_Plot
        figure(s)
        plot(DataFFT.Burst_Programme_Frequence(:,s),2*abs(DataFFT.Burst_Programme_Amplitude(1:NFFT1/2+1,s)))
        hold on
        plot(DataFFT.Burst_Enregistre_Frequence(:,s),2*abs(DataFFT.Burst_Enregistre_Amplitude(1:NFFT2/2+1,s)),'r')
        title('Single-Sided Amplitude Spectrum of y(t)')
        xlabel('Frequency (Hz)')
        ylabel('|Y(f)|')
    end
% 11. Analyse fft du Duty Cycle généré par Matlab
L3 = length(DutyCycle);                     % Length of signal
NFFT3 = 2^nextpow2(L3); % Next power of 2 from length of y
DataFFT.DutyCycle_Programme_Amplitude(:,s) = fft(DutyCycle,NFFT3)/L3;
DataFFT.DutyCycle_Programme_Frequence(:,s) = Fs/2*linspace(0,1,NFFT3/2+1);

% 12. Analyse fft du burst généré par la carte PXIe
L4 = length(DutyCycleRecorded);                     % Length of signal
NFFT4 = 2^nextpow2(L4); % Next power of 2 from length of y
DataFFT.DutyCycle_Enregistre_Amplitude(:,s) = fft(DutyCycleRecorded,NFFT4)/L4;
DataFFT.DutyCycle_Enregistre_Frequence(:,s) = Fs/2*linspace(0,1,NFFT4/2+1);

% 13. Calcul des valeurs min et max du DutyCycle enregistré

DataFiles.DutyCycle_Valeur_Max_Enregistree{end+1,1} = max(DutyCycleRecorded);
DataFiles.DutyCycle_Valeur_min_Enregistree{end+1,1} = min(DutyCycleRecorded);


%
    for j = 1:length(NumSamplePositif)
        DataFiles.Delta_T_Pic(j,s) =  NumSamplePositif(j) - NumSamplePositifRecorded(j);
    end
end
RootDir(end-16:end)=[];
cd(RootDir)

titre = ['Resultats_Analyses_Burst_Frequence_' num2str(FrequenceBurst) 'Hz'];
save(titre,'DataFiles');


titreFFT = ['Resultats_Analyses_FFT_Burst_Frequence_' num2str(FrequenceBurst) 'Hz'];
save(titreFFT,'DataFFT');


%     % analyse des données crées afin de générer un stimulus
%     DataFiles.Stim_Voltage_Out_Max{end+1,1} = max(StimulusWaveform_Y(:,1));
%     DataFiles.Stim_Voltage_Out_min{end+1,1} = min(StimulusWaveform_Y(:,1));
%     DataFiles.Stim_Voltage_Out_mean{end+1,1} = mean(StimulusWaveform_Y(:,1));
% 
% 
%     % analyse des données enregistrées, représentatives de ce qui sera
%     % fourni au transducteur
%     DataFiles.Stim_Voltage_In_Max{end+1,1} = max(captured_data(:,1));
%     DataFiles.Stim_Voltage_In_min{end+1,1} = min(captured_data(:,1));
%     DataFiles.Stim_Voltage_In_mean{end+1,1} = mean(captured_data(:,1));

        % Analyse FFT du stimulus créé 
%         L1 = length(StimulusWaveform_Y(:,1));                     % Length of signal
%         NFFT1 = 2^nextpow2(L1); % Next power of 2 from length of y
%         DataFiles.Stim_FFT_Out = fft(StimulusWaveform_Y(:,1),NFFT1)/L1;
%         f1 = Fs/2*linspace(0,1,NFFT1/2+1);
    % 
    %     % Analyse FFT du stimulus enregistré 
    %     L2 = length(StimulusWaveform_Y(:,1));                     % Length of signal
    %     NFFT2 = 2^nextpow2(L2); % Next power of 2 from length of y
    %     DataFiles.Stim_FFT_In = fft(StimulusWaveform_Y(:,1),NFFT2)/L2;
    %     f2 = Fs/2*linspace(0,1,NFFT2/2+1);



    % Plot single-sided amplitude spectrum.
%         plot(f,2*abs(Y(1:NFFT/2+1))) 
%         title('Single-Sided Amplitude Spectrum of y(t)')
%         xlabel('Frequency (Hz)')
%         ylabel('|Y(f)|')
