%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analyse des donn�es des acquises lors des mesures r�alis�es en WELCOME
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ! Tous les fichiers � analyser doivent se trouver dans un dossier qui lui m�me se trouve dans le dossier Tests_Setup_Welcome � l'emplacement E: 
% Ce script r�alise les op�rations uivantes :
%           1. Cr�ation de constantes et pr�allocations m�moire de
%           variables
%           2. Import et remise dans l'ordre de la liste des fichiers existant dans le dossier
%           pointer lors de l'apparition de la fen�tre pr�vue � cet effet.
%           
clc
clear all

%% 1: Initialisation de constantes et param�tres

%Parametres li�s au fichier "table" utilis� lors des mesures
XTableInit = -17;
XTableEnd = 17;
XStep = 2;

YTableInit = -40;
YTableEnd = 56;
YStep = 2;
YTableLentgth = YTableEnd-YTableInit;

Yvector = YTableInit:YStep:YTableEnd ; %linspace(YTableInit,YTableEnd,YTableEnd+1); % table mesure de 0 � 100 compris
Xvector = XTableInit:XStep:XTableEnd ;   %linspace(XTableEnd,XTableInit,(2*XTableEnd)+1);

%Parametres li�s � 1) l'enregistrement des donn�es et 2) aux stimulations apr US r�alis�es 
SamplingFrequency = 60000000;
CutoffFrequency = 1000000;
NumberOfCycles = 5;
SonicationDuration = 0.3 ;% time in second

%Vpp 
%  VoltagePP = 1.3 ;%[Vpp]
 VoltagePP = 1.2 ;%[Vpp]
%  VoltagePP = 1 ;%[Vpp]
%  VoltagePP = 0.8 ;%[Vpp]
%   VoltagePP = 0.6 ;%[Vpp]


Density = 1028;
SoundVelocity = 1515;
UltrasoundBurstFrequency = 250000;
UltrasoundBurstPeriod = 1/UltrasoundBurstFrequency;
PulseRepetitonFrequency = 1; %!!!![kHz]
ToneBurstDuration = NumberOfCycles * UltrasoundBurstPeriod * 1000 ;% *1000 pour avoir des [ms] et pour le calcul du DutyCycle la PRF est en [kHz]
DutyCycle = ToneBurstDuration * PulseRepetitonFrequency;
AttenuationCoefficient = 0.3 ; % [dB/(cm*MHz)]

switch VoltagePP
    case 1.3
        DistanceTransducteurHydrophone = 6; %[mm]close all
        
        switch UltrasoundBurstFrequency 
            case 250000
                HydrophoneSensitivity = 0.84
                PeakThreshold_Hydrophone = 3000/1000000;
            case 350000
                HydrophoneSensitivity = 0.99
                PeakThreshold_Hydrophone = 3000/1000000;
            case 500000
                HydrophoneSensitivity = 1.22
                PeakThreshold_Hydrophone = 1670/1000000;
        end
        
    case 1.2
        DistanceTransducteurHydrophone = 5.92; %[mm]
        switch UltrasoundBurstFrequency 
            case 250000
                HydrophoneSensitivity = 0.84
                PeakThreshold_Hydrophone = 3100/1000000;
            case 350000
                HydrophoneSensitivity = 0.99
                PeakThreshold_Hydrophone = 3000/1000000;
            case 500000
                HydrophoneSensitivity = 1.22
                PeakThreshold_Hydrophone = 1670/1000000;
        end 
    
    case 1
        DistanceTransducteurHydrophone = 5.4; %[mm]
        switch UltrasoundBurstFrequency 
            case 250000
                HydrophoneSensitivity = 0.84
                PeakThreshold_Hydrophone = 2400/1000000;
            case 350000
                HydrophoneSensitivity = 0.99
                PeakThreshold_Hydrophone = 3000/1000000;
            case 500000
                HydrophoneSensitivity = 1.22
                PeakThreshold_Hydrophone = 1500/1000000;
        end
    case 0.8
        DistanceTransducteurHydrophone = 5.2; %[mm]
        switch UltrasoundBurstFrequency 
            case 250000
                HydrophoneSensitivity = 0.84
                PeakThreshold_Hydrophone = 2400/1000000;
            case 350000
                HydrophoneSensitivity = 0.99
                PeakThreshold_Hydrophone = 3000/1000000;
            case 500000
                HydrophoneSensitivity = 1.22
                PeakThreshold_Hydrophone = 1070/1000000; %680 +/-ok
        end
        
    case 0.6
        DistanceTransducteurHydrophone = 5; %[mm]
        switch UltrasoundBurstFrequency 
            case 250000
                HydrophoneSensitivity = 0.84
                PeakThreshold_Hydrophone = 2500/1000000; %2200 ou 2300
            case 350000
                HydrophoneSensitivity = 0.99
                PeakThreshold_Hydrophone = 3000/1000000;
            case 500000
                HydrophoneSensitivity = 1.22
                PeakThreshold_Hydrophone = 1670/1000000;
        end
end
%Params pour d�tection de pics
PeakThreshold_FunctionGen = 0.1;
% PeakThreshold_Hydrophone = 0.0025; % 0.006 pour 1Vpp 0.003 pour 0.6Vpp

% Params FFT
NSamples = 2^14;
T= [0:(NSamples-1)]/SamplingFrequency;
Freq_Axis = (-SamplingFrequency/2)+[0:NSamples-1]/NSamples*SamplingFrequency; % Permet de cr�er un vecteur qui va de -fs/2 � 1 echnatillon avant Fs/2
Haar = (-1).^([0:NSamples-1]); % permet de recentrer les donn�es en 0
Haar = Haar';
Index_Freq_Interest = round(UltrasoundBurstFrequency/SamplingFrequency*NSamples+NSamples/2+1);

% Params li�s au type de fichier � traiter
TDMS = 1;
LV2015 = 0; % Param necessaire car suite au changement de fonctions forc� pour LabView 2015, la structure des fichiers est modifi�e...


PlotData = 0;
disp('1 : Initialisation finie')

%% 2:  Import du nom de l'ensemble des fichiers contenu dans le dossier s�lectionn�

RootDir = uigetdir;
DataFilesName = dir(RootDir);
DataFilesName(1:2) = []; % delete . and .
cd(RootDir)

NameFile = {};

% Cr�ation d'une matrice contenant les index li�s aux steps r�alis�s lors des mesures via la table X-Y. Pour rappel, elle se d�place "en snake". 
s=1;
v=[];
for y=1:length(Yvector);
    for x=1:length(Xvector);
        v(x,y)=s;
        s=s+1;
    end;
end;

% Boucle utilis�e afin de respecter le schema de d�placement "en snake" de la table
% x-y
for y=2:2:length(Yvector)%YTableEnd;
    v(:,y)=flip(v(:,y));
end;
% imagesc(v)

% Boucle pour trier par ordre num�rique des diff�rents "Steps" de mesure les fichiers contenus dans le dossier pointer par RootDir
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

%% Classement en  dossier

for iii=1:length(NameFile2);
    st=NameFile2{iii};
    idx_2=strfind(st,'Freq_')+5;
    idx2_2=strfind(st,'.tdms')-1;
    stval_2(iii)=str2num(st(idx_2(3):idx2_2));
    [a_2,b_2]=sort(stval_2);

        if stval_2(iii) == 250000
            if mod(iii,2)
                movefile(NameFile2{iii},'E:\Documents\Dropbox (NOCIONS)\jlambert\UCL_PhD\Setup\Mesures_Welcome\SessionJuin2016\AvecCrane2\250kHz')                
            else
                movefile(NameFile2{iii},'E:\Documents\Dropbox (NOCIONS)\jlambert\UCL_PhD\Setup\Mesures_Welcome\SessionJuin2016\AvecCrane2\250kHz_index')
            end
        elseif stval_2(iii) == 350000            
            if mod(iii,2)
                movefile(NameFile2{iii},'E:\Documents\Dropbox (NOCIONS)\jlambert\UCL_PhD\Setup\Mesures_Welcome\SessionJuin2016\AvecCrane2\350kHz')                
            else
                movefile(NameFile2{iii},'E:\Documents\Dropbox (NOCIONS)\jlambert\UCL_PhD\Setup\Mesures_Welcome\SessionJuin2016\AvecCrane2\350kHz_index')
            end
        else        
            if mod(iii,2)
                movefile(NameFile2{iii},'E:\Documents\Dropbox (NOCIONS)\jlambert\UCL_PhD\Setup\Mesures_Welcome\SessionJuin2016\AvecCrane2\500kHz')                
            else
                movefile(NameFile2{iii},'E:\Documents\Dropbox (NOCIONS)\jlambert\UCL_PhD\Setup\Mesures_Welcome\SessionJuin2016\AvecCrane2\500kHz_index')
            end
        end

end


%% 3 : Boucle permettant l'import des donn�es dans une matrice
figure
hold on
for x=1:size(v,1);
    for y=1:size(v,2);
        x;
        y;

        if TDMS
            [finalOutput,metaStruct] = TDMS_readTDMSFile(NameFile2{v(x,y)});

            plot(finalOutput.data{:,3}) % genfunction
            Tension_FunctionGen(x,y,1:length(finalOutput.data{:,3})) = finalOutput.data{:,3};
            Tension_Hydrophone(x,y,1:length(finalOutput.data{:,4})) = finalOutput.data{:,4};
            DeltaT = finalOutput.propValues{1,3}{1,3};
            VecteurTemps_FunctionGen(x,y,1:length(finalOutput.data{:,3})) = (0:DeltaT(1):(length(Tension_FunctionGen(x,y,:))-1)*DeltaT(1)).*1e3;
            MatrixNameFile_5Cycles{x,y,:}=NameFile2{v(x,y)};  
        else
            fid = fopen(NameFile2{v(x,y)});
            content = fscanf(fid,'%c');
                if LV2015
                    A = importfile_2columns_LV2015(NameFile2{v(x,y)});
                    DeltaT = str2num(content(strfind(content,'delta t')+7:strfind(content,'time')-1)) ;%% Recherche du delta T d�fini lors de l'acquisition de donn�es 
                else
                    A = importfile_2columns(NameFile2{v(x,y)});
                    DeltaT = str2num(content(strfind(content,'delta t')+7:strfind(content,'time')-1)) ;%% Recherche du delta T d�fini lors de l'acquisition de donn�es 
                    
                end     
            Tension_FunctionGen(x,y,1:length(A.Volt0)) = A.Volt0;
            Tension_Hydrophone(x,y,1:length(A.Volt1)) = A.Volt1;
            VecteurTemps_FunctionGen(x,y,1:length(A.Volt0)) = (0:DeltaT(1):(length(Tension_FunctionGen(x,y,:))-1)*DeltaT(1)).*1e3;
            MatrixNameFile_5Cycles{x,y,:}=NameFile2{v(x,y)};     
            clear A
            fclose(fid);
        end
%     MatrixNameFile_5Cycles{x,y,:}=NameFile2{v(x,y)};
    end;
end;
disp('3 : Import des donn�es fini')

%% 4 : Calcul afin de 1. R�ajuster par rapport � l'offset, 2. d�terminer le temps et la valeur des premiers pics �mis par le g�n�rateur de fonctions et 3.d�terminer le temps et la valeur des premiers picsre�us par l'hydrophone
% Calcul de l'offset existant pour chaque burst enregistr�
for x=1:size(v,1);
    for y=1:size(v,2);
        %Calcul de l'offset pour les deux s�ries de valeurs
        Offset_FunctionGen(x,y,:) = mean(Tension_FunctionGen(x,y,1:5000));
        Offset_Hydrophone(x,y,:) = mean(Tension_Hydrophone(x,y,1:5000));

        %Correction de l'offset
        Tension_FunctionGen_Corr(x,y,:)= Tension_FunctionGen(x,y,:) - Offset_FunctionGen(x,y,:);
        Tension_Hydrophone_Corr(x,y,:)= Tension_Hydrophone(x,y,:) - Offset_Hydrophone(x,y,:);
    end;
end;

% Filtrage des donn�es
[B A] = butter(2,CutoffFrequency/(SamplingFrequency/2),'low');

for x=1:size(v,1);
    for y=1:size(v,2);
        Tension_FunctionGen_Corr_Filtre(x,y,:)= filtfilt(B, A,Tension_FunctionGen_Corr(x,y,:));
        Tension_Hydrophone_Corr_Filtre(x,y,:)= filtfilt(B, A,Tension_Hydrophone_Corr(x,y,:));
    end;
end;

figure;
plot(squeeze(VecteurTemps_FunctionGen(12,43,:)),squeeze(Tension_Hydrophone_Corr(12,43,:)))
hold on
plot(squeeze(VecteurTemps_FunctionGen(12,43,:)),squeeze(Tension_Hydrophone_Corr_Filtre(12,43,:)),'r')

figure;
plot(squeeze(VecteurTemps_FunctionGen(12,43,:)),squeeze(Tension_FunctionGen_Corr(12,43,:)))
hold on
plot(squeeze(VecteurTemps_FunctionGen(12,43,:)),squeeze(Tension_FunctionGen_Corr_Filtre(12,43,:)),'r')

% D�tection des premiers pics sur base des valeurs filtr�es
for x=1:size(v,1);
    for y=1:size(v,2);
        %Calculs pour le Generateur de fonctions
        Vecteur_Tension_FunctionGen = squeeze(Tension_FunctionGen_Corr_Filtre(x,y,10000:end));
        [ValPic, NumCycle] = findpeaks(Vecteur_Tension_FunctionGen,'MINPEAKHEIGHT',PeakThreshold_FunctionGen);
        PeakValue_FunctionGen(x,y,:) = ValPic(1);
        NumCycle_FunctionGen(x,y,:) = NumCycle(1)+9999;

        %Calculs pour l'hydrophone
        Vecteur_Tension_Hydrophone = squeeze(Tension_Hydrophone_Corr_Filtre(x,y,NumCycle_FunctionGen(x,y,:):end)); % .*1000000 pour obtenir des �V
        [ValPic2, NumCycle2] = findpeaks(Vecteur_Tension_Hydrophone,'MINPEAKHEIGHT',PeakThreshold_Hydrophone);
        PeakValue_Hydrophone(x,y,:) = ValPic2(1);
        NumCycle_Hydrophone(x,y,:) = NumCycle2(1)+NumCycle_FunctionGen(x,y,:)-1;

        %Calculs du delta en nombre de cycles entre l'onde �mise et re�ue
        Delta_Hydrophone_FunctionGen(x,y,:) = NumCycle_Hydrophone(x,y,:) - NumCycle_FunctionGen(x,y,:);
    end;
end;

% NumCycle_FunctionGen = NumCycle_FunctionGen+9999;
% NumCycle_Hydrophone = NumCycle_Hydrophone+9999;
% figure
% plot(Vecteur_Tension_Hydrophone)
% figure
% plot(squeeze(VecteurTemps_FunctionGen(x,y,NumCycle_FunctionGen(x,y,:):end)),squeeze(Tension_Hydrophone_Corr_Filtre(x,y,NumCycle_FunctionGen(x,y,:):end)),'r')

% for x=1:size(v,1);
%     for y = 2:size(v,2)-1;
%         if NumCycle_Hydrophone(x,y)> NumCycle_FunctionGen(x,y)+ ((((YTableLentgth/1000)-(y-1)*YStep/1000)+(DistanceTransducteurHydrophone/1000))/SoundVelocity)*SamplingFrequency
%            NumCycle_Hydrophone_corr(x,y) =  mean([NumCycle_Hydrophone(x,y-1) NumCycle_Hydrophone(x,y+1)]);
%             
%         else
%             NumCycle_Hydrophone_corr(x,y) = NumCycle_Hydrophone(x,y);
%         end
%         Delta_Hydrophone_FunctionGen_corr(x,y) = NumCycle_Hydrophone_corr(x,y,:) - NumCycle_FunctionGen(x,y,:);
%     end
% end
% Delta_Hydrophone_FunctionGen_corr(:,1) = Delta_Hydrophone_FunctionGen(:,1);

% figure; imagesc(Delta_Hydrophone_FunctionGen)
% figure; imagesc(Delta_Hydrophone_FunctionGen_corr)

disp('4 : Correction des valeurs en fonction de leur offset, filtrage des donn�es et d�tection des premiers pics finis')

%% 5 : Calcul des diff�rents param�tres n�cessaires pour la caract�risation d'un champs d'ultrasons
   
for x=1:size(v,1);
    for y=1:size(v,2);
        % D�coupage du signal afin de ne garder que le Burst
        InitBurst = NumCycle_Hydrophone(x,y,:)-ceil((0.5*UltrasoundBurstPeriod*SamplingFrequency));
        EndBurst = NumCycle_Hydrophone(x,y,:)+ceil((NumberOfCycles*UltrasoundBurstPeriod*SamplingFrequency));
        A(x,y,:)=length(InitBurst:EndBurst);
        BurstHydrophone(x,y,:) = ((Tension_Hydrophone_Corr(x,y,InitBurst:EndBurst)).*1000000)./HydrophoneSensitivity; %% Attention facteur d'�chelle % * 1000000 pour passer en �V /0.99 pour avoir des Pa
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



% Calcul de la position max pour chacun des param�tres afin de d�finir la
% distance focale
[PositionX_maxIsppa, PositionY_maxIsppa] = find(Isppa==max(max(Isppa)));
disp(['La valeur max de l Isppa est de : ' num2str(max(max(Isppa))) ' et est postionn� au point : ' num2str(PositionX_maxIsppa) ' ' num2str(PositionY_maxIsppa)])
[PositionX_maxIspta, PositionY_maxIspta] = find(Ispta==max(max(Ispta)));
disp(['La valeur max de l Ispta est de : ' num2str(max(max(Ispta))) ' et est postionn� au point : ' num2str(PositionX_maxIspta) ' ' num2str(PositionY_maxIspta)])
[PositionX_maxPi, PositionY_maxPi] = find(Pi==max(max(Pi)));
disp(['La valeur max du Pi est de : ' num2str(max(max(Pi))) ' et est postionn� au point : ' num2str(PositionX_maxPi) ' ' num2str(PositionY_maxPi)])
[PositionX_maxMI, PositionY_maxMI] = find(MI==max(max(MI)));
disp(['La valeur max du MI est de : ' num2str(max(max(MI))) ' et est postionn� au point : ' num2str(PositionX_maxMI) ' ' num2str(PositionY_maxMI)])

disp('5 : Calcul des parametres du champs d ultrasons fini')


%% 6 : Calcul des diff�rents param�tres "derated" n�cessaires pour la caract�risation d'un champs d'ultrasons
% Calcul de la distance entre transducteur et hydrophone en fonction du
% d�placement dans l'eau
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

%% Modification du nom des variables du workspace en accord avec l'analyse r�alis�e + sauvegarde des variables du workspace

% VariableNameList = who;
% VariableNameList_Original = VariableNameList;
% for ww = 1:length(VariableNameList)
%     VariableName(ww) = VariableNameList(ww,1);
%     VariableNameList(ww,1) = strcat(VariableName(ww),'_',num2str(NumberOfCycles),'Cycles_0',num2str(VoltagePP*10),'Vpp_',num2str(UltrasoundBurstFrequency/1000),'_kHz');
%     NewName = VariableNameList{ww};
%     Brol = eval(VariableName{ww});
%     assignin('base',NewName,Brol);
% end

filenametosave = strcat('Resultats_Analyse_Data_AvecCrane2_',num2str(NumberOfCycles),'Cycles_0',num2str(VoltagePP*10),'Vpp_',num2str(UltrasoundBurstFrequency/1000),'_kHz','.mat');
% clear(VariableNameList_Original{:})
save(filenametosave)

disp('Sauvegarde finie')

%% Affichage pour check detection pic

figure
x=1
y=49
VecteurTemps_FunctionGen(x,y,NumCycle_Hydrophone(x,y))
plot(squeeze(VecteurTemps_FunctionGen(x,y,:)),squeeze(Tension_Hydrophone_Corr_Filtre(x,y,:)))
hold on
plot(squeeze(VecteurTemps_FunctionGen(x,y,NumCycle_Hydrophone(x,y))),squeeze(Tension_Hydrophone_Corr_Filtre(x,y,NumCycle_Hydrophone(x,y))),'*r')


for x=1:size(v,1);
figure
imagesc(NumCycle_Hydrophone(x,:))
end


for x=1:size(v,1);
    for y = 2:size(v,2)-1;
        if NumCycle_Hydrophone(x,y)> (NumCycle_FunctionGen(x,y)+ ((((YTableLentgth/1000)-(y-1)*YStep/1000)+(DistanceTransducteurHydrophone/1000))/SoundVelocity)*SamplingFrequency) + 20
           NumCycle_Hydrophone_corr(x,y) =  mean([NumCycle_Hydrophone(x,y-1) NumCycle_Hydrophone(x,y+1)]);
            
        else
            NumCycle_Hydrophone_corr(x,y) = NumCycle_Hydrophone(x,y);
        end
        Delta_Hydrophone_FunctionGen_corr(x,y) = NumCycle_Hydrophone_corr(x,y,:) - NumCycle_FunctionGen(x,y,:);
    end
end
NumCycle_Hydrophone_corr(:,1)= NumCycle_Hydrophone(:,1);
Delta_Hydrophone_FunctionGen_corr(:,1) = Delta_Hydrophone_FunctionGen(:,1);
NumCycle_Hydrophone_corr(:,end+1)= NumCycle_Hydrophone(:,end);
Delta_Hydrophone_FunctionGen_corr(:,end+1) = Delta_Hydrophone_FunctionGen(:,end);



for x=1:size(v,1);
figure
subplot(2,1,1)
imagesc(NumCycle_Hydrophone(x,:))
subplot(2,1,2)
imagesc(NumCycle_Hydrophone_corr(x,:))
end

figure
imagesc(NumCycle_Hydrophone)

figure
imagesc(NumCycle_Hydrophone_corr)



figure; imagesc(Delta_Hydrophone_FunctionGen)
figure; imagesc(Delta_Hydrophone_FunctionGen_corr)


x=18

for y = 1:size(v,2)
%     VecteurTemps_FunctionGen(x,y,NumCycle_Hydrophone(x,y))
    figure
    plot(squeeze(VecteurTemps_FunctionGen(x,y,:)),squeeze(Tension_Hydrophone_Corr_Filtre(x,y,:)))
    hold on
    plot(squeeze(VecteurTemps_FunctionGen(x,y,:)),squeeze(Tension_FunctionGen_Corr_Filtre(x,y,:)))
 
    plot(squeeze(VecteurTemps_FunctionGen(x,y,NumCycle_Hydrophone(x,y))),squeeze(Tension_Hydrophone_Corr_Filtre(x,y,NumCycle_Hydrophone(x,y))),'*r')
%     plot(squeeze(VecteurTemps_FunctionGen(x,y,latencies(x,y))),squeeze(Tension_Hydrophone_Corr_Filtre(x,y,latencies(x,y))),'*c')
    ylim([-0.1 0.1])
end


y=20
for x = 1:size(v,1)
    figure
    plot(squeeze(VecteurTemps_FunctionGen(x,y,:)),squeeze(Tension_Hydrophone_Corr_Filtre(x,y,:)))
    hold on
    plot(squeeze(VecteurTemps_FunctionGen(x,y,NumCycle_Hydrophone(x,y))),squeeze(Tension_Hydrophone_Corr_Filtre(x,y,NumCycle_Hydrophone(x,y))),'*r')
    ylim([-0.5 0.5]) 
end
%% Analyse fr�quentielle des donn�es. 
% Modif le 30/5/2016 --> Mise au propre de l'analyse frequentielle 
for x=1:size(v,1)
    for y=1:size(v,2)
        Burst_Tension_Resampled(x,y,:) =  Tension_Hydrophone(x,y,3617:end);% 3617 car on coupe les 3616 premiers �chantillons car ce n'est que du
            % BRUIT ET ON S4ARRANGE pour garder une puissance de 2 comme longueuer de
            % vecteur!
        vecteur_Burst_Tension_Resampled = squeeze(Burst_Tension_Resampled(x,y,:));
        FFT_vecteur_Burst(x,y,:) = (fft(vecteur_Burst_Tension_Resampled.*Haar)).*2;

        FFT_vecteur_Burst(x,y,1:(NSamples/2)+1)= FFT_vecteur_Burst(x,y,1:(NSamples/2)+1).*0; % Partie freq neg = � 0
        vecteur_Burst_Complex(x,y,:) = (ifft(FFT_vecteur_Burst(x,y,:))).*Haar; % Vecteur imaginaire d�cal� dans le temps d'un quart de p�riode = ok (cfr
% sin et cos quadrature)
    
        FFT_Burst_Amp_Freq(x,y) = FFT_vecteur_Burst(x,y,Index_Freq_Interest)
    
    end
end
%Recherche frequence d'int�ret afin de d�terminer le d�phasage
Freq_Axis(Index_Freq_Interest)
FFT_vecteur_Burst(x,y,Index_Freq_Interest) % Amplitude et phase du signal � la freq voulue

% Calculer rapport Recu/�mis pour chaque point � sauvegarder
% angle(S/T) %= dephasage entre �mis et re�u cfr notes
% abs(S/T)


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





%% Affichage des donn�es apr�s analyse

%Modif le 30/5/2016
% Plot des donn�es
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
%     disp('Trac� des donn�es fini')
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


% %% Analyse fr�quentielle des donn�es. 
% 
% % 
% 
% NSamples = 2^14;
% T= [0:(NSamples-1)]/SamplingFrequency;
% Freq_Axis = (-SamplingFrequency/2)+[0:NSamples-1]/NSamples*SamplingFrequency; % Permet de cr�er un vecteur qui va de -fs/2 � 1 echnatillon avant Fs/2
% Haar = (-1).^([0:NSamples-1]); % permet de recentrer les donn�es en 0
% Haar = Haar';
% 
% for x=1:size(v,1)
%     for y=1:size(v,2)
%         Burst_Tension_Resampled(11,20,:) =  Tension_Hydrophone_5Cycles_250_Rot15_Crane(x,y,3617:end);% 3617 car on coupe les 3616 premiers �chantillons car ce n'est que du
%             % BRUIT ET ON S4ARRANGE pour garder une puissance de 2 comme longueuer de
%             % vecteur!
%         
%         
%     end
% end
% x=11
% y=20
% 
% 
% Burst_Tension_Resampled(11,20,:) =  Tension_Hydrophone_5Cycles_250_Rot15_Crane(x,y,3617:end);% 3617 car on coupe les 3616 premiers �chantillons car ce n'est que du
% % BRUIT ET ON S4ARRANGE pour garder une puissance de 2 comme longueuer de
% % vecteur!
% vecteur_Burst_Tension_Resampled = squeeze(Burst_Tension_Resampled(11,20,:));
% FFT_vecteur_Burst = (fft(vecteur_Burst_Tension_Resampled.*Haar)).*2;
% 
% FFT_vecteur_Burst(1:(NSamples/2)+1)= FFT_vecteur_Burst(1:(NSamples/2)+1).*0; % Partie freq neg = � 0
% vecteur_Burst_Complex = (ifft(FFT_vecteur_Burst)).*Haar;
% % Vecteur imaginaire d�cal� dans le temps d'un quart de p�riode = ok (cfr
% % sin et cos quadrature)
% 
% 
% %Recherche frequence d'int�ret afin de d�terminer le d�phasage
% Index_Freq_Interest = round(UltrasoundBurstFrequency/SamplingFrequency*NSamples+NSamples/2+1)
% 
% Freq_Axis(Index_Freq_Interest)
% FFT_vecteur_Burst(Index_Freq_Interest) % Amplitude et phase du signal � la freq voulue
% 
% 
% % Calculer rapport Recu/�mis pour chaque point � sauvegarder
% % angle(S/T) %= dephasage entre �mis et re�u cfr notes
% % abs(S/T)
% 
% figure;
% plot(Freq_Axis,abs(FFT_vecteur_Burst))
% 
% figure;
% plot(T,vecteur_Burst_Tension_Resampled)
% hold on
% plot(T,real(vecteur_Burst_Complex),'r')
% plot(T,imag(vecteur_Burst_Complex),'k')

% %% xcorr pour detecter latence des pics
% for x=1:size(v,1);
%     for y=1:size(v,2);
%         sigx=squeeze(Tension_FunctionGen(x,y,:));
%         sigy=squeeze(Tension_Hydrophone_Corr_Filtre(x,y,:));
%         [c,lag]=xcorr(sigx,sigy');
%         [a,b]=max(c);
%         maxlag(x,y)=lag(b);
%         maxcoeff(x,y)=a;
%         latencies(x,y)=NumCycle_FunctionGen(x,y)-maxlag(x,y);
%     end;
% end;
% 
% 
% figure;imagesc(latencies);
