%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analyse des données des acquises lors des mesures réalisées en WELCOME
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ! Tous les fichiers à analyser doivent se trouver dans un dossier qui lui même se trouve dans le dossier Tests_Setup_Welcome à l'emplacement E: 
%% Import du nom de l'ensemble des fichiers contenu dans le dossier sélectionné
clc
clear all


RootDir = uigetdir;
DataFilesName = dir(RootDir);
DataFilesName(1:2) = []; % delete . and .
cd(RootDir)

Tension = zeros(length(DataFilesName),800);
NameFile = {};


%% Boucle permettant de sauver dans des variables les lignes de chaque fichier
for s = 1:length(DataFilesName)
    
    filename = fullfile(RootDir,DataFilesName(s).name);
    % Recherche du delta T défini lors de l'acquisition de données
    fid = fopen(filename);
    content = fscanf(fid,'%c');
    
    
    % import des données
    
   % if strfind(RootDir,'2')& strfind(RootDir,'Channels')
        A = importfile_2columns(filename);
        deltaT = str2num(content(strfind(content,'delta t')+7:strfind(content,'time')-1)) %% Test ac 2 DeltaT!!!!
        disp('2 different measurements')
        
        Tension1(s,1:length(A.Volt0)) = A.Volt0;
        Tension2(s,1:length(A.Volt1)) = A.Volt1;

        VecteurTemps1 = (0:deltaT(1):(length(Tension1(s,:))-1)*deltaT(1)).*1e3;
        VecteurTemps2 = (0:deltaT(2):(length(Tension1(s,:))-1)*deltaT(2)).*1e3;
    % analyse fft des tensions enregistrées
        L1 = length(A.Volt0);
        NFFT1 = 2^nextpow2(L1);
        FFT_Amplitude1 = zeros(length(DataFilesName),NFFT1);
        FFT_Frequence1 = zeros(length(DataFilesName),(NFFT1/2)+1);
        FFT_Amplitude1(s,:) = (fft(A.Volt0,NFFT1)/L1)';
        FFT_Frequence1(s,:) = (1/deltaT(1))/2*linspace(0,1,NFFT1/2+1);
        
        L2 = length(A.Volt1);
        NFFT2 = 2^nextpow2(L2);
        FFT_Amplitude2 = zeros(length(DataFilesName),NFFT1);
        FFT_Frequence2 = zeros(length(DataFilesName),(NFFT1/2)+1);
        FFT_Amplitude2(s,:) = (fft(A.Volt1,NFFT2)/L2)';
        FFT_Frequence2(s,:) = (1/deltaT(2))/2*linspace(0,1,NFFT2/2+1);
                
    % Plot des données
        figure(s)
        subplot(2,2,1)
        plot(VecteurTemps1,Tension1(s,:))
        title('Recordings from the function generator')
        xlabel('Time [ms]')
        ylabel('Tension from the function generator [V]')

        subplot(2,2,2)
        plot(FFT_Frequence1(s,:),2*abs(FFT_Amplitude1(s,1:NFFT1/2+1)))
        title('Frequency analysis - FFT')
        xlabel('Frequency [Hz]')
        ylabel('Amplitude')    
        
        subplot(2,2,3)
        plot(VecteurTemps2,Tension2(s,:))
        title('Recordings from the amplifier')
        xlabel('Time [ms]')
        ylabel('Tension from the amplifier [V]')

        subplot(2,2,4)
        plot(FFT_Frequence2(s,:),2*abs(FFT_Amplitude2(s,1:NFFT2/2+1)))
        title('Frequency analysis - FFT')
        xlabel('Frequency [Hz]')
        ylabel('Amplitude')  
        
%     else 
%         disp('1 measurement')
%         deltaT = str2num(content(strfind(content,'delta t')+7:strfind(content,'time')-1));
%         A = importfile_1column(filename);
%         
%         Tension1(s,1:length(A.Volt0)) = A.Volt0;
%         VecteurTemps1 = (0:deltaT:(length(Tension1(s,:))-1)*deltaT).*1e3;
%     % analyse fft de la tension enregistrée
%         L1 = length(A.Volt0);
%         NFFT1 = 2^nextpow2(L1);
%         FFT_Amplitude1 = zeros(length(DataFilesName),NFFT1);
%         FFT_Frequence1 = zeros(length(DataFilesName),(NFFT1/2)+1);
% 
%         FFT_Amplitude1(s,:) = (fft(A.Volt0,NFFT1)/L1)';
%         FFT_Frequence1(s,:) = (1/deltaT)/2*linspace(0,1,NFFT1/2+1);
%             
%     % Plot des données
% 
%         figure(s)
%         subplot(1,2,1)
%         plot(VecteurTemps1,Tension1(s,:))
%         title('Recordings from the function generator')
%         xlabel('Time [ms]')
%         ylabel('Tension from the function generator [V]')
% 
%         subplot(1,2,2)
%         plot(FFT_Frequence1(s,:),2*abs(FFT_Amplitude1(s,1:NFFT1/2+1)))
%         title('Frequency analysis - FFT')
%         xlabel('Frequency [Hz]')
%         ylabel('Amplitude')
%         
%     end
    
    
    NameFile{s,1} = filename;
    clear A
end

%


%% Creation d'une variable de type "table" afin de pouvoir plus facilement traiter les données par après
    if strfind(RootDir,'2')& strfind(RootDir,'Channels')
        Results = table(NameFile,Tension1,FFT_Amplitude1,FFT_Frequence1,Tension2,FFT_Amplitude2,FFT_Frequence2,'VariableNames', {'Nom_Fichier', 'ValeurTension_Generateur', 'Amplitude_Analyse_FFT_Generateur', 'Frequence_Analyse_FFT_Generateur','ValeurTension_Ampli', 'Amplitude_Analyse_FFT_Ampli', 'Frequence_Analyse_FFT_Ampli'});

    else
        Results = table(NameFile,Tension1,FFT_Amplitude1,FFT_Frequence1,'VariableNames', {'Nom_Fichier', 'ValeurTension', 'Amplitude_Analyse_FFT', 'Frequence_Analyse_FFT'});

    end
    

%% Sauvegarde des résultats dans un fichier .mat

Titel = ['Resultats_' RootDir(strfind(RootDir,'Tests_Setup_Welcome\'):strfind(RootDir,'ome\')+2) '_' RootDir(strfind(RootDir,'Only\')+5:end)  '.mat'];
save(Titel,'Results')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%

