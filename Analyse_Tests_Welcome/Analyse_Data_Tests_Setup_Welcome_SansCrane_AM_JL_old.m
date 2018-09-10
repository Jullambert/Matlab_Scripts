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

%% 1: Initialisation de constantes et paramètres

%Parametres liés au fichier "table" utilisé lors des mesures
XTableInit = -25;
XTableEnd = 25;
XStep = 2;

YTableInit = -40;
YTableEnd = 60;
YStep = 2;

Yvector = YTableInit:YStep:YTableEnd ; %linspace(YTableInit,YTableEnd,YTableEnd+1); % table mesure de 0 à 100 compris
Xvector = XTableInit:XStep:XTableEnd ;   %linspace(XTableEnd,XTableInit,(2*XTableEnd)+1);

%Parametres liés à 1) l'enregistrement des données et 2) aux stimulations apr US réalisées 
SamplingFrequency = 60000000;
CutoffFrequency = 1000000;
NumberOfCycles = 5;
SonicationDuration = 0.3 ;% time in second

%Vpp sans crane
 VoltagePP = 1.3 ;%[Vpp]
% VoltagePP = 1.2 ;%[Vpp]
% VoltagePP = 1 ;%[Vpp]
% VoltagePP = 0.8 ;%[Vpp]
% VoltagePP = 0.6 ;%[Vpp]

switch VoltagePP
    case 1.3
        DistanceTransducteurHydrophone = 6; %[mm]
        PeakThreshold_Hydrophone = 0.006
    case 1.2
        DistanceTransducteurHydrophone = 5.92; %[mm]
        PeakThreshold_Hydrophone = 0.006
    case 1
        DistanceTransducteurHydrophone = 5.4; %[mm]
        PeakThreshold_Hydrophone = 0.006
    case 0.8
        DistanceTransducteurHydrophone = 5.2; %[mm]
        PeakThreshold_Hydrophone = 0.0025
    case 0.6
        DistanceTransducteurHydrophone = 5; %[mm]
        PeakThreshold_Hydrophone = 0.003
end

Density = 1028;
SoundVelocity = 1515;
UltrasoundBurstFrequency = 250000;
UltrasoundBurstPeriod = 1/UltrasoundBurstFrequency;
PulseRepetitonFrequency = 1; %!!!![kHz]
ToneBurstDuration = NumberOfCycles * UltrasoundBurstPeriod * 1000 ;% *1000 pour avoir des [ms] et pour le calcul du DutyCycle la PRF est en [kHz]
DutyCycle = ToneBurstDuration * PulseRepetitonFrequency;
AttenuationCoefficient = 0.3 ; % [dB/(cm*MHz)]

switch UltrasoundBurstFrequency 
    case 250000
        HydrophoneSensitivity = 0.84
    case 350000
        HydrophoneSensitivity = 0.99
    case 500000
        HydrophoneSensitivity = 1.22  
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


LV2015 = 0; % Param necessaire car suite au changement de fonctions forcé pour LabView 2015, la structure des fichiers est modifiée...
PlotData = 0;
disp('1 : Initialisation finie')

%% 2:  Import du nom de l'ensemble des fichiers contenu dans le dossier sélectionné

RootDir = uigetdir;
DataFilesName = dir(RootDir);
DataFilesName(1:2) = []; % delete . and .
cd(RootDir)

NameFile = {};

% Création d'une matrice contenant les index liés aux steps réalisés lors des mesures via la table X-Y. Pour rappel, elle se déplace "en snake". 
s=1;
v=[];
for y=1:length(Yvector);
    for x=1:length(Xvector);
        v(x,y)=s;
        s=s+1;
    end;
end;

% Boucle utilisée afin de respecter le schema de déplacement "en snake" de la table
% x-y
for y=2:2:length(Yvector)%YTableEnd;
    v(:,y)=flip(v(:,y));
end;
% imagesc(v)

% Boucle pour trier par ordre numérique des différents "Steps" de mesure les fichiers contenus dans le dossier pointer par RootDir
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
disp('2 : Reorganisation des noms de fichiers fini')

%% Classement en trois dossier
for iii=1:length(NameFile2);
    st=NameFile2{iii};
    idx_2=strfind(st,'Freq_')+5;
    idx2_2=strfind(st,'.txt')-1;
    stval_2(iii)=str2num(st(idx_2(3):idx2_2));
    [a_2,b_2]=sort(stval_2);
    
    if stval_2(iii) == 250000
        movefile(NameFile2{iii},'E:\Documents\Dropbox (NOCIONS)\jlambert\UCL_PhD\Setup\Mesures_Welcome\SessionMars_Avril\Mesures_Mars\SansCrane\1V_5Cycles_3Freq_bis\250kHz')
       
    elseif stval_2(iii) == 350000
        
        movefile(NameFile2{iii},'E:\Documents\Dropbox (NOCIONS)\jlambert\UCL_PhD\Setup\Mesures_Welcome\SessionMars_Avril\Mesures_Mars\SansCrane\1V_5Cycles_3Freq_bis\350kHz')
        
    else        
        movefile(NameFile2{iii},'E:\Documents\Dropbox (NOCIONS)\jlambert\UCL_PhD\Setup\Mesures_Welcome\SessionMars_Avril\Mesures_Mars\SansCrane\1V_5Cycles_3Freq_bis\500kHz')
    end
 end;

 

%% 3 : Boucle permettant l'import des données dans une matrice


for x=1:size(v,1);
    for y=1:size(v,2);
        x;
        y;
        fid = fopen(NameFile2{v(x,y)});
        content = fscanf(fid,'%c');
        
        if LV2015
            A = importfile_2columns_LV2015(NameFile2{v(x,y)});
            DeltaT = str2num(content(strfind(content,'delta t')+7:strfind(content,'time')-1)) ;%% Recherche du delta T défini lors de l'acquisition de données 
        else
            A = importfile_2columns(NameFile2{v(x,y)});
            DeltaT = str2num(content(strfind(content,'delta t')+7:strfind(content,'time')-1)) ;%% Recherche du delta T défini lors de l'acquisition de données 
        end
        Tension_FunctionGen(x,y,1:length(A.Volt0)) = A.Volt0;
        Tension_Hydrophone(x,y,1:length(A.Volt1)) = A.Volt1;
        VecteurTemps_FunctionGen(x,y,1:length(A.Volt0)) = (0:DeltaT(1):(length(Tension_FunctionGen(x,y,:))-1)*DeltaT(1)).*1e3;
        MatrixNameFile_5Cycles{x,y,:}=NameFile2{v(x,y)};     
        clear A
        fclose(fid);
        
    end;
end;
disp('3 : Import des données fini')

%% 4 : Calcul afin de 1. Réajuster par rapport à l'offset, 2. déterminer le temps et la valeur des premiers pics émis par le générateur de fonctions et 3.déterminer le temps et la valeur des premiers picsreçus par l'hydrophone
% Calcul de l'offset existant pour chaque burst enregistré
for x=1:size(v,1);
    for y=1:size(v,2);
        %Calcul de l'offset pour les deux séries de valeurs
        Offset_FunctionGen(x,y,:) = mean(Tension_FunctionGen(x,y,1:5000));
        Offset_Hydrophone(x,y,:) = mean(Tension_Hydrophone(x,y,1:5000));

        %Correction de l'offset
        Tension_FunctionGen_Corr(x,y,:)= Tension_FunctionGen(x,y,:) - Offset_FunctionGen(x,y,:);
        Tension_Hydrophone_Corr(x,y,:)= Tension_Hydrophone(x,y,:) - Offset_Hydrophone(x,y,:);
    end;
end;

% Filtrage des données
[B A] = butter(2,CutoffFrequency/(SamplingFrequency/2),'low');

for x=1:size(v,1);
    for y=1:size(v,2);
        Tension_FunctionGen_Corr_Filtre(x,y,:)= filtfilt(B, A,Tension_FunctionGen_Corr(x,y,:));
        Tension_Hydrophone_Corr_Filtre(x,y,:)= filtfilt(B, A,Tension_Hydrophone_Corr(x,y,:));
    end;
end;

figure;
plot(squeeze(VecteurTemps_FunctionGen(1,1,:)),squeeze(Tension_Hydrophone_Corr(1,1,:)))
hold on
plot(squeeze(VecteurTemps_FunctionGen(1,1,:)),squeeze(Tension_Hydrophone_Corr_Filtre(1,1,:)),'r')


% Détection des premiers pics sur base des valeurs filtrées
for x=1:size(v,1);
    for y=1:size(v,2);
        %Calculs pour le Generateur de fonctions
        Vector_Tension_FunctionGen = squeeze(Tension_FunctionGen_Corr_Filtre(x,y,10000:end));
        [ValPic, NumCycle] = findpeaks(Vector_Tension_FunctionGen,'MINPEAKHEIGHT',PeakThreshold_FunctionGen);
        PeakValue_FunctionGen(x,y,:) = ValPic(1);
        NumCycle_FunctionGen(x,y,:) = NumCycle(1);

        %Calculs pour l'hydrophone
        Vector_Tension_Hydrophone = squeeze(Tension_Hydrophone_Corr_Filtre(x,y,10000:end));
        [ValPic2, NumCycle2] = findpeaks(Vector_Tension_Hydrophone,'MINPEAKHEIGHT',PeakThreshold_Hydrophone);
        PeakValue_Hydrophone(x,y,:) = ValPic2(1);
        NumCycle_Hydrophone(x,y,:) = NumCycle2(1);

        %Calculs du delta en nombre de cycles entre l'onde émise et reçue
        Delta_Hydrophone_FunctionGen(x,y,:) = NumCycle_Hydrophone(x,y,:) - NumCycle_FunctionGen(x,y,:);
    end;
end;
NumCycle_FunctionGen = NumCycle_FunctionGen+9999;
NumCycle_Hydrophone = NumCycle_Hydrophone+9999;


figure;
plot(squeeze(VecteurTemps_FunctionGen(20,51,:)),squeeze(Tension_Hydrophone_Corr(20,51,:)))
hold on
plot(squeeze(VecteurTemps_FunctionGen(21,43,10000:end)),squeeze(Tension_Hydrophone_Corr_Filtre(21,43,10000:end)),'r')
plot(squeeze(VecteurTemps_FunctionGen(20,51,:)),squeeze(Tension_FunctionGen(20,51,:)),'k')


disp('4 : Correction des valeurs en fonction de leur offset, filtrage des données et détection des premiers pics finis')

%% 5 : Calcul des différents paramètres nécessaires pour la caractérisation d'un champs d'ultrasons
   
for x=1:size(v,1);
    for y=1:size(v,2);
        % Découpage du signal afin de ne garder que le Burst
        InitBurst = NumCycle_Hydrophone(x,y,:)-ceil((0.5*UltrasoundBurstPeriod*SamplingFrequency));
        EndBurst = NumCycle_Hydrophone(x,y,:)+ceil((NumberOfCycles*UltrasoundBurstPeriod*SamplingFrequency));
        A(x,y,:)=length(InitBurst:EndBurst);
        BurstHydrophone(x,y,:) = ((Tension_Hydrophone_Corr_Filtre(x,y,InitBurst:EndBurst)).*1000000)./HydrophoneSensitivity; %% Attention facteur d'échelle % * 1000000 pour passer en µV /0.99 pour avoir des Pa
        TimeVector_BurstHydrophone(x,y,:) = VecteurTemps_FunctionGen(x,y,InitBurst:EndBurst);
        
        %[Pi_Complet(x,y,:),Isppa_Complet(x,y,:),Ispta_Complet(x,y,:),mechanicalIndex_Complet(x,y,:)] = ultrasoundParameters((Tension_Hydrophone_Corr_Filtre_Rot15(x,y,:).*1000000)./0.99,VecteurTemps_FunctionGen_5Cycles_Rot15(x,y,:),Density,SoundVelocity,UltrasoundBurstFrequency,DutyCycle);  
        [Pi(x,y,:),Isppa(x,y,:),Ispta(x,y,:),MI(x,y,:), TI(x,y,:)] = ultrasoundParameters(BurstHydrophone(x,y,:),TimeVector_BurstHydrophone(x,y,:),Density,SoundVelocity,UltrasoundBurstFrequency,DutyCycle,SamplingFrequency,SonicationDuration);
    end;
end;

figure;
imagesc(Pi)
title(strcat('Pi AF',num2str(UltrasoundBurstFrequency/1000),'_kHz'))
figure;
imagesc(Isppa)
title(strcat('Isppa AF',num2str(UltrasoundBurstFrequency/1000),'_kHz'))
figure;
imagesc(Ispta)
title(strcat('Ispta AF',num2str(UltrasoundBurstFrequency/1000),'_kHz'))
figure;
imagesc(MI)
title(strcat('MI AF',num2str(UltrasoundBurstFrequency/1000),'_kHz'))

% Calcul de la position max pour chacun des paramètres afin de définir la
% distance focale
[PositionX_maxIsppa, PositionY_maxIsppa] = find(Isppa==max(max(Isppa)));
disp(['Postion Max Isppa = ' num2str(PositionX_maxIsppa) ' ' num2str(PositionY_maxIsppa)])
[PositionX_maxIspta, PositionY_maxIspta] = find(Ispta==max(max(Ispta)));
disp(['Postion Max Ispta = ' num2str(PositionX_maxIspta) ' ' num2str(PositionY_maxIspta)])
[PositionX_maxPi, PositionY_maxPi] = find(Pi==max(max(Pi)));
disp(['Postion Max Pi = ' num2str(PositionX_maxPi) ' ' num2str(PositionY_maxPi)])
[PositionX_maxMI, PositionY_maxMI] = find(MI==max(max(MI)));
disp(['Postion Max Mi = ' num2str(PositionX_maxMI) ' ' num2str(PositionY_maxMI)])

disp('5 : Calcul des parametres du champs d ultrasons fini')


%% 6 : Calcul des différents paramètres "derated" nécessaires pour la caractérisation d'un champs d'ultrasons

% Calcul de la distance entre transducteur et hydrophone en fonction du
% déplacement dans l'eau

for x=1:size(v,1);
    for y=1:size(v,2);
        % Calcul Isppa Derated
        DistanceX_Isppa(x,y) = XStep*abs(PositionX_maxIsppa-x); % Distance en [mm]
        DistanceY_Isppa(x,y) = YStep*(max(size(v,2))-y) + DistanceTransducteurHydrophone; % Distance en [mm]
        DistanceDerating_Isppa(x,y) = sqrt((DistanceX_Isppa(x,y))^2 + (DistanceY_Isppa(x,y))^2); % Distance en [mm]
        [IsppaDerated(x,y), LinearAttenuationCoeff(x,y)] = deratedValue(Isppa(x,y),AttenuationCoefficient,DistanceDerating_Isppa(x,y)/10,UltrasoundBurstFrequency/1000000);
    
        % Calcul Ispta derated
        DistanceX_Ispta(x,y) = XStep*abs(PositionX_maxIspta-x); % Distance en [mm]
        DistanceY_Ispta(x,y) = YStep*(max(size(v,2))-y) + DistanceTransducteurHydrophone; % Distance en [mm]
        DistanceDerating_Ispta(x,y) = sqrt((DistanceX_Ispta(x,y))^2 + (DistanceY_Ispta(x,y))^2); % Distance en [mm]
        [IsptaDerated(x,y), LinearAttenuationCoeff(x,y)] = deratedValue(Ispta(x,y),AttenuationCoefficient,DistanceDerating_Ispta(x,y)/10,UltrasoundBurstFrequency/1000000);
        
        % Calcul Ispta derated
        DistanceX_MI(x,y) = XStep*abs(PositionX_maxMI-x); % Distance en [mm]
        DistanceY_MI(x,y) = YStep*(max(size(v,2))-y) + DistanceTransducteurHydrophone; % Distance en [mm]
        DistanceDerating_MI(x,y) = sqrt((DistanceX_MI(x,y))^2 + (DistanceY_MI(x,y))^2); % Distance en [mm]
        [MIDerated(x,y), LinearAttenuationCoeff(x,y)] = deratedValue(MI(x,y),AttenuationCoefficient,DistanceDerating_MI(x,y)/10,UltrasoundBurstFrequency/1000000);
        
    end;
end;
disp('6 : Calcul des parametres "derated" du champs d ultrasons fini')

%% 7 : Calcul de la Full width half maximum area

 
Max_Isppa = max(max(Isppa));
Isppa_Normalisee = Isppa./Max_Isppa;
 
[PositionX_maxIsppa_Normalisee, PositionY_maxIsppa_Normalisee] = find(Isppa_Normalisee==1);
FWHM_Matrix = zeros(size(v,1),size(v,2));
 
for x=1:size(v,1);
    for y=1:size(v,2);
       if Isppa_Normalisee(x,y) >= 0.5
            FWHM_Matrix(x,y) = 1;
       end
    end;
end;

figure;
imagesc(FWHM_Matrix)
disp('7 : Calcul FWHM fini')


%% Modification du nom des variables du workspace en accord avec l'analyse réalisée + sauvegarde des variables du workspace

% VariableNameList = who;
% VariableNameList_Original = VariableNameList;
% for ww = 1:length(VariableNameList)
%     VariableName(ww) = VariableNameList(ww,1);
%     VariableNameList(ww,1) = strcat(VariableName(ww),'_',num2str(NumberOfCycles),'Cycles_0',num2str(VoltagePP*10),'Vpp_',num2str(UltrasoundBurstFrequency/1000),'_kHz');
%     NewName = VariableNameList{ww};
%     Brol = eval(VariableName{ww});
%     assignin('base',NewName,Brol);
% end

filenametosave = strcat('Resultats_Analyse_Data_',num2str(NumberOfCycles),'Cycles_0',num2str(VoltagePP*10),'Vpp_',num2str(UltrasoundBurstFrequency/1000),'_kHz','.mat');
% clear(VariableNameList_Original{:})
save(filenametosave)

disp('Sauvegarde finie')

%% Analyse fréquentielle des données. 
% Modif le 30/5/2016 --> Mise au propre de l'analyse frequentielle 
for x=1:size(v,1)
    for y=1:size(v,2)
        Burst_Tension_Resampled(x,y,:) =  Tension_Hydrophone(x,y,3617:end);% 3617 car on coupe les 3616 premiers échantillons car ce n'est que du
            % BRUIT ET ON S4ARRANGE pour garder une puissance de 2 comme longueuer de
            % vecteur!
        vecteur_Burst_Tension_Resampled = squeeze(Burst_Tension_Resampled(x,y,:));
        FFT_vecteur_Burst(x,y,:) = (fft(vecteur_Burst_Tension_Resampled.*Haar)).*2;

        FFT_vecteur_Burst(x,y,1:(NSamples/2)+1)= FFT_vecteur_Burst(x,y,1:(NSamples/2)+1).*0; % Partie freq neg = à 0
        vecteur_Burst_Complex(x,y,:) = (ifft(FFT_vecteur_Burst(x,y,:))).*Haar; % Vecteur imaginaire décalé dans le temps d'un quart de période = ok (cfr
% sin et cos quadrature)
    
        FFT_Burst_Amp_Freq(x,y) = FFT_vecteur_Burst(x,y,Index_Freq_Interest)
    
    end
end
%Recherche frequence d'intéret afin de déterminer le déphasage
Freq_Axis(Index_Freq_Interest)
FFT_vecteur_Burst(x,y,Index_Freq_Interest) % Amplitude et phase du signal à la freq voulue

% Calculer rapport Recu/émis pour chaque point à sauvegarder
% angle(S/T) %= dephasage entre émis et reçu cfr notes
% abs(S/T)



% 
% 
% figure;
% plot(reshape(SquaredBurstPressureWaveformCumsum(x,y,:),1,length(SquaredBurstPressureWaveformCumsum(x,y,:))))
% 
% 
% plot(reshape(VecteurTemps_FunctionGen(x,y,:),1,length(VecteurTemps_FunctionGen(x,y,:))),reshape(Tension_Hydrophone_Corr(x,y,:),1,length(Tension_Hydrophone_Corr(x,y,:))))
% hold on
% plot(reshape(VecteurTemps_FunctionGen(x,y,:),1,length(VecteurTemps_FunctionGen(x,y,:))),reshape(Tension_Hydrophone_Corr_Filtre(x,y,:),1,length(Tension_Hydrophone_Corr_Filtre(x,y,:))),'r')
% plot(reshape(TimeVector_BurstHydrophone(x,y,:),1,length(TimeVector_BurstHydrophone(x,y,:))),reshape(BurstHydrophone(x,y,:),1,length(BurstHydrophone(x,y,:))),'c')
% 
% 
% plot(VecteurTemps_FunctionGen(x,y,NumCycle_Hydrophone(x,y,:)),Tension_Hydrophone_Corr(x,y,NumCycle_Hydrophone(x,y,:)),'*k')





%% Affichage des données après analyse

%Modif le 30/5/2016
% Plot des données
% if PlotData
%     for w = 1: length(NameFile2)
%         figure(w)
%         subplot(2,2,1)
%         plot(VecteurTemps_FunctionGen(w,:),Tension_FunctionGen(w,:))
%         title('Recordings from the function generator')
%         xlabel('Time [ms]')
%         ylabel('Tension from the function generator [V]')
% 
%         subplot(2,2,2)
%         plot(FFT_Frequence_FunctionGen(w,:),2*abs(FFT_Amplitude_FunctionGen(w,1:NFFT/2+1)))
%         title('Frequency analysis - FFT')
%         xlabel('Frequency [Hz]')
%         ylabel('Amplitude')    
% 
%         subplot(2,2,3)
%         plot(VecteurTemps_Hydrophone(w,:),Tension_Hydrophone(w,:))
%         title('Recordings from the hydrophone')
%         xlabel('Time [ms]')
%         ylabel('Tension from the hydrophone [V]')
% 
%         subplot(2,2,4)
%         plot(FFT_Frequence_Hydrophone(w,:),2*abs(FFT_Amplitude_Hydrophone(w,1:NFFT2/2+1)))
%         title('Frequency analysis - FFT')
%         xlabel('Frequency [Hz]')
%         ylabel('Amplitude')  
% 
%         pause(1)
%     end 
%     disp('Tracé des données fini')
% end


if PlotData
    for x=1:size(v,1);
        for y=1:size(v,2); 
            figure(v(x,y))
            subplot(2,1,1)
            plot(Freq_Axis,squeeze(abs(FFT_vecteur_Burst(x,y,:))))

            subplot(2,1,2)
            plot(T,squeeze(Burst_Tension_Resampled(x,y,:)))
            hold on
            plot(T,squeeze(real(vecteur_Burst_Complex(x,y,:)),'r'))
            plot(T,squeeze(imag(vecteur_Burst_Complex(x,y,:)),'k'))

        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%