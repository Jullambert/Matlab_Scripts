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

%%

n1 = 100;
a = 0.016 ; %radius of the emitter in [m]
r = linspace(0,a,n1+1)' ;
dr = a/n1;

f= 300000; %frequency of the ultrasound field to model
c = 1550 ; %sound velocity of US in water
lambda = c/f; %wavelength
k = 2*pi/lambda; %wavenumber
fd = 0.022;% focal distance
b = 2*pi-(pi/(lambda*0.04)); % param representative of the transducer cfr notes CC 25 july
j=sqrt(-1);
%
dPhi = pi/n1;
Phi = linspace(0,pi,n1+1)'; % angle for the integration
%
Xc=0.04;
Rc = 3;
%%
% Observations performed in the XoZ plan
% Y obs = 0
% Z source = 0
n= 50;
XobsMax = 0.05 ; % Length of the field of observation = diam of emitter
Xobs = linspace(-XobsMax,XobsMax,n+1)'; % length of the observation field
YobsMax=0;
Yobs = linspace(0.0000,YobsMax,n1+1)';
ZobsMax = 0.100 ;
Zobs = linspace(0.0001,ZobsMax ,n1+1)';
S =[]; %zeros(size(Xobs,1),size(Yobs,1));
T = zeros(size(Xobs,1),size(Zobs,1));

for f=1:size(Xobs,1) %displacement along the observation points - X direction
    for p = 1:size(Zobs,1) %displacement along the observation points - Z direction
        for i = 1:size(Phi,1)         %integration over the source points
            for m = 1:size(r,1)
                    Xs = r(m)*cos(Phi(i));
                    Ys = r(m)*sin(Phi(i));
                    R = sqrt((Xs-Xobs(f))^2+(Ys-0)^2+(0-Zobs(p))^2);
                    T(f,p) = T(f,p)+exp((-j*b*(r(m)^2)))*(Rc-((r(m)/Xc)-1)^2)^0.5*exp(-j*k*R)/R *r(m)*dr*dPhi;
             end
        end
    end
end
%  figure; plot(abs(T(1,:,26)))
% %
% S=sum(T,3);
%   figure;plot(abs(S))
%  figure;imagesc(abs(T))

figure;
plot(abs(T))
figure;
imagesc(abs(T))
set(gca,'YDir','normal')
figname = strcat('Model 2D v2 - Ju - Xc = ',num2str(Xc),' - Rc = ',num2str(Rc));
title(figname)