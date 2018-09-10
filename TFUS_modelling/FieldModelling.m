%% Params of the model
clear all

n = 100;
a = 0.016 ; %radius of the emitter in [m]
r = linspace(0,a,n+1)' ;
dr = a/n;
XobsMax = 0.100 ; % Length of the field of observation
Xobs = linspace(0.0001,XobsMax,n+1)'; % length of the observation field
f= 300000; %frequency of the ultrasound field to model
c = 1550 ; %sound velocity of US in water
lambda = c/f; %wavelength
k = 2*pi/lambda; %wavenumber
fd = 0.022;% focal distance
b = pi/(lambda*0.04); % param representative of the transducer cfr notes CC 25 july
j=sqrt(-1);
%% kitchen side
%along the central axis of the emitter , axysimmetric property supposed
S2 = zeros(size(Xobs,1),1);
for p = 1 : size(Xobs,1) %displacement along the observation points
    for m=1:size(r) %integration over the source points
        R = sqrt(Xobs(p)^2+r(m)^2);
        S2(p) = S2(p)+exp((j*b*(r(m)^2)))*exp(-j*k*R)/R *r(m)*dr;
    end
end

% hint : deux doubles boucles

figure
plot(abs(S2))
figure
plot(log10(abs(S2)))


