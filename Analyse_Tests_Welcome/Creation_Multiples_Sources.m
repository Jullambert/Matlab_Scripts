%% Création virtuelle de 3 source sur base d'une source existante.
% L'idée est de translater selon l'axe x les valeurs de XX pas en positif
% et en négatif ! Ceci permettra de donne un apercu de ce qui sera fait
% avec 3 sources point de vue de la focalisation

%Creation d'un matrice vide pour le déplacement vers le haut et vers le bas
%de la source
load('Resultats_Analyse_AlignementLaiton_1Vpp_5C_Freq250_Rot0')

Tension_Hydrophone_Corr_Filtre_250_Rot0_Up = zeros(size(v,1),size(v,2),20000);
Tension_Hydrophone_Corr_Filtre_250_Rot0_Down = zeros(size(v,1),size(v,2),20000);

%boucle pour le up
for x=1:size(v,1)-4;
    for y=1:size(v,2);
        Tension_Hydrophone_Corr_Filtre_250_Rot0_Up(x,y,:) = Tension_Hydrophone_Corr_Filtre_250_Rot0(x+4,y,:);
    end
end

T1 = squeeze(Tension_Hydrophone_Corr_Filtre_250_Rot0(26,10,:));
T2 = squeeze(Tension_Hydrophone_Corr_Filtre_250_Rot0_Up(22,10,:));
figure()
plot(T1)
hold on
plot(T2,'r')

%boucle pour le down
for x=5:size(v,1);
    for y=1:size(v,2);
        Tension_Hydrophone_Corr_Filtre_250_Rot0_Down(x,y,:) = Tension_Hydrophone_Corr_Filtre_250_Rot0(x-4,y,:);
    end
end

T3 = squeeze(Tension_Hydrophone_Corr_Filtre_250_Rot0(22,10,:));
T4 = squeeze(Tension_Hydrophone_Corr_Filtre_250_Rot0_Down(26,10,:));
figure()
plot(T3)
hold on
plot(T4,'r')

Somme_Tension_3Sources = Tension_Hydrophone_Corr_Filtre_250_Rot0_Down+Tension_Hydrophone_Corr_Filtre_250_Rot0+Tension_Hydrophone_Corr_Filtre_250_Rot0_Up;
PeakThreshold_Hydrophone = 0.01;
   
for x=1:size(v,1);
    for y=1:size(v,2);
        Vector_Tension_Hydrophone_Somme = reshape(Somme_Tension_3Sources(x,y,:),1,length(Somme_Tension_3Sources(x,y,:)));
        [ValPic2_250_Somme, NumCycle2_250_Somme] = findpeaks(Vector_Tension_Hydrophone_Somme,'MINPEAKHEIGHT',PeakThreshold_Hydrophone);
        PeakValue_Hydrophone_250_Somme(x,y,:) = ValPic2_250_Somme(1);
        NumCycle_Hydrophone_250_Somme(x,y,:) = NumCycle2_250_Somme(1);
        % Découpage du signal afin de ne garder que le Burst
        InitBurst_Somme = NumCycle_Hydrophone_250_Somme(x,y,:)-ceil((0.5*UltrasoundBurstPeriod*SamplingFrequency));
        EndBurst_Somme = NumCycle_Hydrophone_250_Somme(x,y,:)+ceil((NumberOfCycles*UltrasoundBurstPeriod*SamplingFrequency));
        A(x,y,:)=length(InitBurst_Somme:EndBurst_Somme);
        BurstHydrophone_250_Somme(x,y,:) = ((Somme_Tension_3Sources(x,y,InitBurst_Somme:EndBurst_Somme)).*1000000)./0.99; % * 1000000 pour passer en µV /0.99 pour avoir des Pa
        TimeVector_BurstHydrophone_250_Somme(x,y,:) = VecteurTemps_FunctionGen_250_5Cycles_Rot0(x,y,InitBurst_Somme:EndBurst_Somme);
        
        %[Pi_Complet(x,y,:),Isppa_Complet(x,y,:),Ispta_Complet(x,y,:),mechanicalIndex_Complet(x,y,:)] = ultrasoundParameters((Tension_Hydrophone_Corr_Filtre_Rot0(x,y,:).*1000000)./0.99,VecteurTemps_FunctionGen_5Cycles_Rot0(x,y,:),Density,SoundVelocity,UltrasoundBurstFrequency,DutyCycle);  
        [Pi_250_Somme(x,y,:),Isppa_250_Somme(x,y,:),Ispta_250_Somme(x,y,:),mechanicalIndex_250_Somme(x,y,:)] = ultrasoundParameters(BurstHydrophone_250_Somme(x,y,:),TimeVector_BurstHydrophone_250_Somme(x,y,:),Density,SoundVelocity,UltrasoundBurstFrequency,DutyCycle);
    end;
end;

[PositionX_maxIsppa_Somme, PositionY_maxIsppa_Somme] = find(Isppa_250_Somme==max(max(Isppa_250_Somme)))
[PositionX_maxIsppa_250_Rot0, PositionY_maxIsppa_250_Rot0] = find(Isppa_250_Rot0==max(max(Isppa_250_Rot0)))

figure;
imagesc(Pi_250_Somme)
title('Pi AF 250[kHz] 3 sources')
figure;
imagesc(Isppa_250_Somme)
title('Isppa AF 250[kHz] 3 sources')
figure;
imagesc(Ispta_250_Somme)
title('Ispta AF 250[kHz] 3 sources')


figure()
imagesc(Isppa_250_Rot0)
title('Isppa AF 250[kHz]')
