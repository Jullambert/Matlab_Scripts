%%
% * = source points are over a disc that represents the transducer 
% . = observer points 

% 
%            |
%            *
%            |
%            *
% xaxis ^    |
%       |    *
%       |    |__.__.__.__.__.__.__.__
%       |
%       |-------> z axis
%  yaxisO
%   (point out)


% v2 is related to the adition of ellipse equation in the model to reduce
% the sidelobes, to tune the amplitude of the field and to enlarge the
% principal lobe

%% Params
f0= 300000; %frequency of the ultrasound field to model
w0 = 2*pi*f0;
c = 1550 ; %sound velocity of US in water
lambda = c/f0; %wavelength
k = 2*pi/lambda; %wavenumber
j=sqrt(-1);

% Params for the data to import
Fs = 10000000; %Sampling frequency;
t = 0:1/Fs:(30000-1)/Fs;
vf = exp(j*w0.*t);
%% Loading data reference for comparison
load('DataCharacterisation_SkullBoneAttenuation_4_Without_200Cyc_10Vpp_300kHz.mat','HydrophoneVoltage')
HydroVpp = fliplr(HydrophoneVoltage);
for x = 1:size(HydroVpp,1)
    for y = 1:size(HydroVpp,2)
        S(x,y,:) = squeeze(HydroVpp(x,y,:))'.*vf;  
        IntS(x,y) = sum(S(x,y,:))/Fs;
    end
end
figure
imagesc(abs(IntS))
set(gca,'YDir','normal')
title('Valeur reference - 1Vpp 200C 300kHz')
[Xcoord2, Ycoord2] = find(abs(IntS)==max(max(abs(IntS(:,[11,end])))));
Xname2 = strcat('Valeur maximal = ', num2str(max(max(abs(IntS(:,[11,end]))))), '; position x: ', num2str(Ycoord2),' position y:',num2str(Xcoord2));
xlabel(Xname2);


%% Mathematical model to simulate the US emitter
% Observations performed in the XoZ plan
% Y obs = 0
% Z source = 0
% Params for the model
a = 0.016 ; %radius of the emitter in [m]
fd = 0.022;% focal distance
%b = (pi/(lambda*fd)); % param representative of the transducer cfr notes CC 25 july
b=8e3;
d=0.014;
V0 = 1;
V1 = 0; %pedestal
e = 3;

n= 50;
n1 = 100;
r = linspace(0,a,n1+1)' ;
dr = a/n1;

XobsMax = 0.05 ; % Length of the field of observation
Xobs = linspace(-XobsMax,XobsMax,n+1)'; % length of the observation field
YobsMax=0;
Yobs = linspace(0.0000,YobsMax,n1+1)';
ZobsMax = 0.100 ;
Zobs = linspace(0.0001,ZobsMax ,n1+1)';
dPhi = pi/n1;
Phi = linspace(0,pi,n1+1)'; % angle for the integration
T = zeros(size(Xobs,1),size(Zobs,1));

for f0=1:size(Xobs,1) %displacement along the observation points - X direction
    for p = 1:size(Zobs,1) %displacement along the observation points - Z direction
        for i = 1:size(Phi,1)         %integration over the source points
            for m = 1:size(r,1)
                    Xs = r(m)*cos(Phi(i));
                    Ys = r(m)*sin(Phi(i));
                    R = sqrt((Xs-Xobs(f0))^2+(Ys-0)^2+(0-Zobs(p))^2);
                    T(f0,p) = T(f0,p)+exp((-j*b*(r(m)^2)))*(V0*(1-((Xs^2)+(Ys^2))/(d^2))^e+V1)*(exp(-j*k*R)/R) *r(m)*dr*dPhi;
             end
        end
    end
end
%  figure; plot(abs(T(1,:,26)))
% %
% S=sum(T,3);
%   figure;plot(abs(S))
%  figure;imagesc(abs(T))
figname = strcat('Model 2D v3, b = ',num2str(b),', V0 = ',num2str(V0),', V1 = ',num2str(V1),', d= ',num2str(d),'and e=',num2str(e));
figure;
plot(abs(T))
title(figname)
figure;
imagesc(abs(T))
set(gca,'YDir','normal')
title(figname)

[Xcoord, Ycoord] = find(abs(T)==max(max(abs(T))));
Xname = strcat('Valeur maximal = ', num2str(max(max(abs(T)))), '; position x: ', num2str(Ycoord),' position y:',num2str(Xcoord));
xlabel(Xname);
%%

%%

%% Optimization of the model
% Based on the least square theorem, it is possible to fit a model on
% observed/measurements data. In order to find the best parameter for the fit, 
% we have to define alpha defined as alpha*xi = yi with yi the measurments
% data and xi the modelled data

%IndexFreqInterest = round(Params.UltrasoundBurstFrequency(DfN)/Params.SamplingFrequency(DfN)*NSamples+NSamples/2+1);

% load('DataFFT_MechanicalAlignment_Cylinder_1_5Cyc_10Vpp_350kHz.mat','HydrophoneVoltageBurstVect_Complex');
load('DataFFT_MechanicalAlignment_Cylinder_1_5Cyc_10Vpp_350kHz.mat');
p0 = HydrophoneVoltageBurstVect_Complex(:,:,round((350000/10000000)*16384+16384/2+1));
p0=fliplr(p0);
figure;
imagesc(abs(p0))
p0 = reshape(p0,size(p0,1)*size(p0,2),1);

pt = T;
pt = reshape(pt,size(pt,1)*size(pt,2),1);

alpha = (pt'*p0)/(pt'*pt);



%%
for x=1:size(FunctionGenVoltageBurstCut,1)
    for y=1:size(FunctionGenVoltageBurstCut,2)
            FunctionGenVoltageBurstVect_FFT2(x,y,:)= squeeze(FunctionGenVoltageBurstVect_FFT(x,y,:))'.*exp((j*2*pi*Freq_Axis)/(2*350000)); % Partie freq neg = à 0
            FunctionGenVoltageBurstVect_Complex(x,y,:) = squeeze(ifft(FunctionGenVoltageBurstVect_FFT2(x,y,:))).*Haar; % Vecteur imaginaire décalé dans le temps d'un quart de période = ok (cfr
            
            HydrophoneVoltageBurstVect_FFT2(x,y,:)= squeeze(HydrophoneVoltageBurstVect_FFT(x,y,:))'.*exp((j*2*pi*Freq_Axis)/(2*350000)); % Partie freq neg = à 0 , permet signal analytique
            HydrophoneVoltageBurstVect_Complex(x,y,:) = squeeze(ifft(HydrophoneVoltageBurstVect_FFT2(x,y,:))).*Haar; % Vecteur imaginaire décalé dans le temps d'un quart de période = ok (cfr

%FFT_Burst_Tension_Hydro_Amp_Freq_Intererst(x,y) = FFT_vecteur_Burst_Tension_Hydro(x,y,IndexFreqInterest);
    end
end

%Recherche frequence d'intéret afin de déterminer le déphasage
Freq_Axis(IndexFreqInterest);
HydrophoneVoltageBurstVect_FFT(x,y,IndexFreqInterest); % Amplitude et phase du signal à la freq voulue
% Calculer rapport Recu/émis pour chaque point à sauvegarder
% FFTPhaseshift = angle(HydrophoneVoltageBurstVect_Complex(:,:,IndexFreqInterest)./FunctionGenVoltageBurstVect_Complex(:,:,IndexFreqInterest)); %= dephasage entre émis et reçu cfr notes
% FFTAmplitude =  abs(HydrophoneVoltageBurstVect_Complex(:,:,IndexFreqInterest)./FunctionGenVoltageBurstVect_Complex(:,:,IndexFreqInterest));

% Should compute Received/emitted, A/B * e^j*(phi2-phi1)
ComplexRatio = HydrophoneVoltageBurstVect_Complex./FunctionGenVoltageBurstVect_Complex;
