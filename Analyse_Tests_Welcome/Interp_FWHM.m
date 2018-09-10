crane = 0;
if crane
    Xmin=-17;
    Xmax=17;
    Ymin=0;
    Ymax=95;
    [X,Y] = meshgrid([Ymin:Ymax],[Xmin:Xmax]);
    Isppa_Norm = Isppa./max(max(Isppa(:,1:Ymax-5)));
else
    Xmin=-25;
    Xmax=25;
    Ymin=0;
    Ymax=100;
    [X,Y] = meshgrid([Ymin:Ymax],[Xmin:Xmax]);
    Isppa_Norm = Isppa./max(max(Isppa(:,1:Ymax-10)));
end
% X=X';
% Y=Y';
[X_Interpol,Y_Interpol]=meshgrid(linspace(Ymin,Ymax,500),linspace(Xmin,Xmax,500));%MA: meshgrid 2D
Isppa_Interp=interp2(X,Y,Isppa_Norm,X_Interpol,Y_Interpol);%MA: interpolate scattered data
figure;
%surf(X,Y,Z,'EdgeColor','none','LineStyle','none');%MA: 3D
imagesc(Isppa_Interp);%MA: 3D

for x=1:size(Isppa_Interp,1)
    for y=1:size(Isppa_Interp,2)
        if(Isppa_Interp(x,y)>=0.5)
            FWHM2(x,y)=1;
        else
            FWHM2(x,y)=0;
        end
    end
end
for x=1:size(Isppa_Norm,1)
    for y=1:size(Isppa_Norm,2)
        if(Isppa_Norm(x,y)>=0.5)
            FWHM(x,y)=1;
        else
            FWHM(x,y)=0;
        end
    end
end
figure
imagesc([Ymin:Ymax],[Xmin:Xmax],FWHM2)
figure
imagesc([Ymin:Ymax],[Xmin:Xmax],FWHM_Matrix)
figure
imagesc([Ymin:Ymax],[Xmin:Xmax],FWHM)
level = sort(Isppa_Norm(Isppa_Norm>=0.5));
figure
imagesc([Ymin:Ymax],[Xmin:Xmax],Isppa_Norm)
% set(gca,'YDir','normal')
hold on
contour(X,Y,Isppa_Norm,[level(1) level(1)] ,'LineWidth',2,'LineColor','k')

%%
title('Session 5 - Avec Crane - 350kHz - Isppa Normalisee interpol')
title('Session 5 - Avec Crane - 350kHz - FWHM (Isppa norm interpolee)')
title('Session 5 - Avec Crane - 350kHz - FWHM (Isppa norm)')
title('Session 5 - Avec Crane - 350kHz - FWHM (Isppa norm via Isppa(:,:))')
title('Session 5 - Avec Crane - 350kHz - ISppa + contour FWHM (Isppa norm via Isppa(:,:))')

%%
Burst_350_200 = BurstHydrophone;

figure;plot(squeeze(Burst_350_200(26,77,:)));hold on; plot(squeeze(Burst_350_200(26,78,:)),'r')
figure;plot(squeeze(Burst_350_100(26,77,:)));hold on; plot(squeeze(Burst_350_100(26,78,:)),'r')
figure;plot(squeeze(Burst_350_50(26,77,:)));hold on; plot(squeeze(Burst_350_50(26,78,:)),'r')

Density = 1028;
SoundVelocity = 1515;
for x=1:size(Burst_350_200,1)
    for y=1:size(Burst_350_200,2)
        
        PeakPressure(x,y,:) = max(Burst_350_200(x,y,:));
        PtPPressure(x,y,:) = max(Burst_350_200(x,y,:))-min(BurstHydrophone(x,y,:));
        Isppa1(x,y,:) = (PeakPressure(x,y,:)^2)/(2*Density*SoundVelocity);    
   
    end
end
Isppa1_Norm = Isppa1./(max(max(Isppa1)));
for x=1:size(Isppa1_Norm,1)
    for y=1:size(Isppa1_Norm,2)
        if(Isppa1_Norm(x,y)>=0.5)
            FWHM3(x,y)=1;
        else
            FWHM3(x,y)=0;
        end
    end
end

%%
save('UltrasoundParameters_SessionAttenuation_AvecCrane_1Vpp_200Cycles_6Freq_Crane_5_300kHz','BurstHydrophone','EndBurst','FWHM_Matrix','InitBurst','Isppa','Ispta','MI','Pi','TI','Isppa_Interp','TimeVector_BurstHydrophone','Isppa_Norm','X','Y','X_Interpol','Y_Interpol','FWHM2','FWHM')
