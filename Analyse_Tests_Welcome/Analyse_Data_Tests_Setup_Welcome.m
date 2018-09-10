%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analyse des données des acquises lors des mesures réalisées en WELCOME
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ! Tous les fichiers à analyser doivent se trouver dans un dossier qui lui même se trouve dans le dossier Tests_Setup_Welcome à l'emplacement E: 
% Ce script réalise les opérations uivantes :
%           1. Création de constantes et préallocations mémoire de
%           variables
%           2. Import et remise dans l'ordre de la liste des fichiers existant dans le dossier
%           pointer lors de l'apparition de la fenêtre prévue à cet effet.
%           

clc
clear all

%% Initialisation de constantes et paramètres
XTableInit = -20;
XTableEnd = 20;

YTableInit = 0;
YTableEnd = 100;

Yvector = linspace(YTableInit,YTableEnd,YTableEnd+1); % table mesure de 0 à 100 compris
Xvector = linspace(XTableEnd,XTableInit,(2*XTableEnd)+1);
Xindeximpair = length(Xvector):-1:1;
Xindexpair = length(Xvector)+1:1:2*length(Xvector) ;

TableMatrixIsppa = zeros(length(Yvector),length(Xvector));
TableMatrixIspta = zeros(length(Yvector),length(Xvector));
TableMatrixMI = zeros(length(Yvector),length(Xvector));

SamplingFrequency = 60000000;

Density = 1028;
SoundVelocity = 1515;
UltrasoundBurstFrequency = 350000;
UltrasoundBurstPeriod = 1/UltrasoundBurstFrequency;
PulseRepetitonFrequency = 1;

PlotData = 0;

PeakThreshold_FunctionGen = 0.1;
PeakThreshold_Hydrophone = 0.0135;


%% Import du nom de l'ensemble des fichiers contenu dans le dossier sélectionné
RootDir = uigetdir;
DataFilesName = dir(RootDir);
DataFilesName(1:2) = []; % delete . and .
cd(RootDir)

NameFile = {};

%% Boucle utilisée afin de trier par ordre numérique des différents "Steps" de mesure les fichiers contenus dans le dossier pointer par RootDir
for i=1:length(DataFilesName);
    filename = fullfile(RootDir,DataFilesName(i).name);
    NameFile{i,1} = filename;
end;


for ii=1:length(DataFilesName);
    st=NameFile{ii};
    idx=strfind(st,'Num_Step_')+9;
    idx2=strfind(st,'X_Coordinate')-1;
    stval(ii)=str2num(st(idx:idx2));
    [a,b]=sort(stval);
end;
NameFile2=NameFile(b);

%% Boucle permettant de sauver dans des variables les lignes de chaque fichier
for s = 1:length(NameFile2)
        
    % Ouverture du fichier et creation d'un identifiant unique
        fid = fopen(NameFile2{s});
        content = fscanf(fid,'%c');
      
    % import des données
        A = importfile_2columns(NameFile2{s});
        deltaT = str2num(content(strfind(content,'delta t')+7:strfind(content,'time')-1)) %% Recherche du delta T défini lors de l'acquisition de données
                
        Tension_FunctionGen(s,1:length(A.Volt0)) = A.Volt0;
        Tension_Hydrophone(s,1:length(A.Volt1)) = A.Volt1;
        VecteurTemps_FunctionGen(s,1:length(A.Volt0)) = (0:deltaT(1):(length(Tension_FunctionGen(s,:))-1)*deltaT(1)).*1e3; %*1e3 to convert the vector from [s] to [ms]
        VecteurTemps_Hydrophone(s,1:length(A.Volt1)) = (0:deltaT(2):(length(Tension_Hydrophone(s,:))-1)*deltaT(2)).*1e3;
        
    % analyse fft des tensions enregistrées
        L1 = length(A.Volt0);
        NFFT1 = 2^nextpow2(L1);
        if s ==1
        FFT_Amplitude_FunctionGen = zeros(length(DataFilesName),NFFT1);
        FFT_Frequence_FunctionGen = zeros(length(DataFilesName),(NFFT1/2)+1);
        end
        FFT_Amplitude_FunctionGen(s,:) = (fft(A.Volt0,NFFT1)/L1)';
        FFT_Amplitude_FunctionGen_Plot(s,:)= 2*abs(FFT_Amplitude_FunctionGen(s,1:NFFT1/2+1));
        FFT_Frequence_FunctionGen(s,:) = (1/deltaT(1))/2*linspace(0,1,NFFT1/2+1);
        
        L2 = length(A.Volt1);
        NFFT2 = 2^nextpow2(L2);
        if s==1
        FFT_Amplitude_Hydrophone = zeros(length(DataFilesName),NFFT1);
        FFT_Frequence_Hydrophone = zeros(length(DataFilesName),(NFFT1/2)+1);
        end
        FFT_Amplitude_Hydrophone(s,:) = (fft(A.Volt1,NFFT2)/L2)';
        FFT_Amplitude_Hydrophone_Plot(s,:)= 2*abs(FFT_Amplitude_Hydrophone(s,1:NFFT2/2+1));
        FFT_Frequence_Hydrophone(s,:) = (1/deltaT(2))/2*linspace(0,1,NFFT2/2+1);
    
    % Fermeture du fichier et effacement de la variable de stockage A
    clear A
    fclose(fid);
end


disp('Import et analyse des données finis')


%% Calcul afin de 1. Réajuster par rapport à l'offset, 2. déterminer le temps et la valeur des premiers pics émis par le générateur de fonctions et 3.déterminer le temps et la valeur des premiers picsreçus par l'hydrophone

% Calcul de la valeur d'offest + correction des courbes
for d=1:length(NameFile2)
    %Calcul de l'offset pour les deux séries de valeurs
    Offset_FunctionGen(d,:) = mean(Tension_FunctionGen(d,1:5000));
    Offset_Hydrophone(d,:) = mean(Tension_Hydrophone(d,1:5000));
    
    %Correction de l'offset
    Tension_FunctionGen_Corr(d,:)= Tension_FunctionGen(d,:) - Offset_FunctionGen(d,:);
    Tension_Hydrophone_Corr(d,:)= Tension_Hydrophone(d,:) - Offset_Hydrophone(d,:);
end

% détection du temps du 1er pic du burst dans le signal du générateur de fonction et
% de l'hydrophone  + calcul du delta en cycles entre
% onde envoyée et reçue
for f = 1:length(NameFile2)
    %Calculs pour le Generateur de fonctions
    [ValPic, NumCycle] = findpeaks(Tension_FunctionGen_Corr(f,:),'MINPEAKHEIGHT',PeakThreshold_FunctionGen);
    PeakValue_FunctionGen(f,:) = ValPic(1);
    NumCycle_FunctionGen(f,:) = NumCycle(1);
    
    %Calculs pour l'hydrophone
    [ValPic2, NumCycle2] = findpeaks(Tension_Hydrophone_Corr(f,:),'MINPEAKHEIGHT',PeakThreshold_Hydrophone);
    PeakValue_Hydrophone(f,:) = ValPic2(1);
    NumCycle_Hydrophone(f,:) = NumCycle2(1);
    
    %Calculs du delta en nombre de cycles entre l'onde émise et reçue
    Delta_Hydrophone_FunctionGen(f,:) = NumCycle_Hydrophone(f,:) - NumCycle_FunctionGen(f,:);
end





% zut=4121;
% figure(zut)
% plot(VecteurTemps_FunctionGen(zut,:),Tension_FunctionGen(zut,:))
% hold on;
% plot(VecteurTemps_FunctionGen(zut,:),Tension_FunctionGen_Corr(zut,:),'r')
% plot(VecteurTemps_FunctionGen(zut,NumCycle_FunctionGen(zut,:)),PeakValue_FunctionGen(zut,:),'*c')
% plot(VecteurTemps_FunctionGen(zut,Cycle_Peak_FunctionGen(zut,:)),Peaks_FunctionGen(zut,:),'*k')

% plot(VecteurTemps_Hydrophone(zut,:),Tension_Hydrophone(zut,:))
% hold on;
% plot(VecteurTemps_Hydrophone(zut,:),Tension_Hydrophone_Corr(zut,:),'r')
% plot(VecteurTemps_Hydrophone(zut,NumCycle_Hydrophone(zut,:)),PeakValue_Hydrophone(zut,:),'*c')
% plot(VecteurTemps_Hydrophone(zut,10568),PeakValue_Hydrophone(zut,:),'*c')

%VecteurTemps_FunctionGen(d,NumCycle_FunctionGen(d,:))
%VecteurTemps_Hydrophone(4130,NumCycle_Hydrophone(4130,:))

%% Calcul des différents paramètres nécessaires pour la caractérisation d'un champs d'ultrasons
    
    % Filtrage des données
   
for ww = 1: length(NameFile2)
    % Calcul des valeurs sur base du Busrt et non de l'ensemble de
    % l'enregistrement. Du coup, nécessité de découper les bursts pour des T compris entre NumCycle 1er pic - 1/4*periodeBurst( =ceil(UltrasoundBurstPeriod*SamplingFrequency) ),
    % NumCylce 1er Burst + 9,75*periodeBurst
    
    [Pi(ww,1),Isppa(ww,1),Ispta(ww,1),mechanicalIndex(ww,1)] = ultrasoundParameters(Tension_Hydrophone_Corr(ww,0.25*NumCycle_Hydrophone(ww,:):9.75*NumCycle_Hydrophone(ww,:))./0.99,VecteurTemps_Hydrophone(ww,0.25*NumCycle_Hydrophone(ww,:):9.75*NumCycle_Hydrophone(ww,:)),Density,SoundVelocity,UltrasoundBurstFrequency,PulseRepetitonFrequency);
end

    % Stockage des valeurs dans une matrix contenant Y lignes et X colonnes
    % (ce qui correspond aux dimensions du champ de points mesurés)
b = 0;
for j= 1:length(Yvector)
    for k = 1:length(Xvector)
        if mod(j,2)
            TableMatrixIsppa(j,k) = Isppa(Xindeximpair(k)+b*2*length(Xvector),1);
            TableMatrixIspta(j,k) = Ispta(Xindeximpair(k)+b*2*length(Xvector),1);
            TableMatrixMI(j,k) = mechanicalIndex(Xindeximpair(k)+b*2*length(Xvector),1);
            TableStepsIndex(j,k)=(Xindeximpair(k)+b*2*length(Xvector))-1;
            TableNames{j,k}=NameFile2(Xindeximpair(k)+b*2*length(Xvector),1);
        else
            TableMatrixIsppa(j,k) = Isppa(Xindexpair(k)+b*2*length(Xvector),1);
            TableMatrixIspta(j,k) = Ispta(Xindexpair(k)+b*2*length(Xvector),1);
            TableMatrixMI(j,k) = mechanicalIndex(Xindexpair(k)+b*2*length(Xvector),1);
            TableStepsIndex(j,k)= (Xindexpair(k)+b*2*length(Xvector))-1;
            TableNames{j,k}=NameFile2(Xindexpair(k)+b*2*length(Xvector),1);
        end
    end
    
    if mod(j,2)

    else
    b = b+1;
    end
end

% figure()
% [xx, yy] = meshgrid(Xvector,Yvector);
% plot3(xx,yy,TableMatrixIsppa,'*')
% mesh(TableMatrixIspta)

disp('Calcul des parametres du champs d ultrasons fini')

% %% Creation d'une variable de type "table" afin de pouvoir plus facilement traiter les données par après
%         Results = table(NameFile,Tension_GenFunction,FFT_Amplitude_GenFunction, FFT_Amplitude_GenFunction_Plot,FFT_Frequence_GenFunction,Tension_Hydrophone,FFT_Amplitude_Hydrophone, FFT_Amplitude_Hydrophone_Plot,FFT_Frequence_Hydrophone,'VariableNames', {'Nom_Fichier', 'ValeurTension_Generateur', 'Amplitude_Analyse_FFT_Generateur', 'Amplitude_Analyse_FFT_Generateur_Plot', 'Frequence_Analyse_FFT_Generateur','ValeurTension_Ampli', 'Amplitude_Analyse_FFT_Ampli', 'Amplitude_Analyse_FFT_Ampli_Plot', 'Frequence_Analyse_FFT_Ampli'});
% 
% %% Sauvegarde des résultats dans un fichier .mat
% 
% Titel = ['Resultats_' RootDir(strfind(RootDir,'Mesures_Welcome')+16:strfind(RootDir,'Mesure_Axe')+11) '_' RootDir(strfind(RootDir,'Serie'):strfind(RootDir,'\Data')-1)  '.mat'];
% save(Titel,'Results')


%% Affichage des données après analyse

% Plot des données
if PlotData
    for w = 1: length(NameFile)
        figure(w)
        subplot(2,2,1)
        plot(VecteurTemps_FunctionGen(w,:),Tension_FunctionGen(w,:))
        title('Recordings from the function generator')
        xlabel('Time [ms]')
        ylabel('Tension from the function generator [V]')

        subplot(2,2,2)
        plot(FFT_Frequence_FunctionGen(w,:),2*abs(FFT_Amplitude_FunctionGen(w,1:NFFT1/2+1)))
        title('Frequency analysis - FFT')
        xlabel('Frequency [Hz]')
        ylabel('Amplitude')    

        subplot(2,2,3)
        plot(VecteurTemps_Hydrophone(w,:),Tension_Hydrophone(w,:))
        title('Recordings from the hydrophone')
        xlabel('Time [ms]')
        ylabel('Tension from the hydrophone [V]')

        subplot(2,2,4)
        plot(FFT_Frequence_Hydrophone(w,:),2*abs(FFT_Amplitude_Hydrophone(w,1:NFFT2/2+1)))
        title('Frequency analysis - FFT')
        xlabel('Frequency [Hz]')
        ylabel('Amplitude')  

        pause(1)
    end 
    disp('Tracé des données fini')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%