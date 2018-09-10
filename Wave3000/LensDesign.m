%% Script made to design a lens according to the focal distance of it and the diameter of the transducer.

clc;
clear all
%% Parameters
SoundVelocity_Material = 2365; %[m/s] for material of the official lens
% SoundVelocity_Material = ; %[m/s] for 
% SoundVelocity_Material = ; %[m/s] for 
% SoundVelocity_Material = ; %[m/s] for 
SoundVelocity_Water = 1515; %[m/s]

CompressibilityCoefficient_Material = 1/(SoundVelocity_Material*1000);
CompressibilityCoefficient_Water = 1/(SoundVelocity_Water*1000);
DeltaCompressibilityCoefficient = CompressibilityCoefficient_Water - CompressibilityCoefficient_Material;

R0_prime = 31; %[mm]
Radius_Transducer = 16; % [mm]

Resolution_x = 0.1;
Resolution_rho = Resolution_x*Resolution_x;

rho_2D = 0:Resolution_x*Resolution_x:Radius_Transducer;
x = -Radius_Transducer:Resolution_x:Radius_Transducer;
y = x;

theta_rot = 0:pi/40:2*pi;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Computation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% First step : R0 = Focal distance
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R0 = R0_prime;

for i = 1:length(rho_2D)
   Radius_Z(i) = R0 + 0.5*((rho_2D(i)^2)/R0);
   h_Z(i) =  (CompressibilityCoefficient_Water*(Radius_Z(i)-R0))/DeltaCompressibilityCoefficient;
end

figure()
plot(rho_2D,Radius_Z)
hold on
plot(rho_2D,h_Z,'r')
title('First step, first way of calculation')
legend('R(z)','H1(z)')
xlabel('z')

%% Second step : R0 = Focal length - hmax
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R0 = R0_prime - max(h_Z);
% for ii = 1:length(z)
%    Radius_Z2_1(ii) = R0 + 0.5*((z(ii)^2)/R0);
%    h1_Z2_1(ii) =  (CompressibilityCoefficient_Water*(Radius_Z2_1(ii)-R0))/DeltaCompressibilityCoefficient;
% end

Radius_Z2 = Radius_Z;

for ii = 1:length(rho_2D)
   h_Z2(ii) =  (CompressibilityCoefficient_Water*(Radius_Z2(ii)-R0))/DeltaCompressibilityCoefficient;
end

figure()
plot(rho_2D,Radius_Z2)
hold on
plot(rho_2D,h_Z2,'r')
title('Second step, based on the first way of calculation for the 1st step')
legend('R(z)','H1(z)')
 



%% 3D design - Revolution du tracé 2D autour de l'axe Y


for i = 1:length(x)
   for j = 1:length(y)
      rho_calcul(i,j) =  sqrt(x(i)^2 + y(j)^2);
      rho_3D(i,j) = Resolution_rho * round(rho_calcul(i,j)/Resolution_rho);
      
      if rho_3D(i,j)>=0 && rho_3D(i,j) <= 16+Resolution_rho*Resolution_x
          disp('ok')
%           index_rho(i,j) = find(rho_2D >= rho_3D(i,j)-Resolution_rho & rho_2D < rho_3D(i,j)-Resolution_rho,1,'first');
          z(i,j) = h_Z2(find(Resolution_rho*round(rho_2D/Resolution_rho) == rho_3D(i,j))); % necessaire de faire le calcul sur rho_2D parce qu'il ne trouvait les indices pour rho_2D = 16 par exemeple.

      else
          %index_rho(i,j) = 0;
          z(i,j) = 0;            
      end      
   end   
end
plot(z)

% 
% for i = 1:length(x)
%    for j = 1:length(y)
%       wut(i,j) =  sqrt(x(i)^2 + y(j)^2);
%       if sqrt(x(i)^2 + y(j)^2)>0.1 & sqrt(x(i)^2 + y(j)^2) < 16-0.1
%           index_rho(i,j) = find(rho>=sqrt(x(i)^2 + y(j)^2) -0.01 & rho <sqrt(x(i)^2 + y(j)^2) +0.01 ,1, 'first');
%           z(i,j) = h_Z(index_rho(i,j));
%       else
% %           index_rho(i,j) = 0;
%            z(i,j) = 0;            
%       end      
%    end   
% end
% 
% figure(),mesh(x,y,z)
%Problème de résolution spatiale : pas de match entre rho et rho = sqrt(x^2+y^2)

%% ancien code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Autres possibilités d'approximation - 1st step
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     for i = 1:length(z)
%        Radius_Z1_2(i) = z(i) * (DeltaCompressibilityCoefficient/CompressibilityCoefficient_Water)*R0;
%        h1_Z2(i) =  (CompressibilityCoefficient_Water*(Radius_Z1_2(i)-R0))/DeltaCompressibilityCoefficient;
%     end
% 
% figure()
% plot(Radius_Z1_2)
% hold on
% plot(h1_Z2,'r')
% title('First step, first way of calculation')


%     for i = 1:length(z)
%        alpha = atan((z(i))/R0);
%        Radius_Z1_3(i) = R0/cos(alpha);
%        h1_Z3(i) =  (CompressibilityCoefficient_Water*(Radius_Z1_3(i)-R0))/DeltaCompressibilityCoefficient;
%     end
% 
% figure()
% plot(Radius_Z1_3)
% hold on
% plot(h1_Z3,'r')
% title('First step, second way of calculation')

% Autres possibilités d'approximation - 2nd step
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% R0 = R0_prime - max(h1_Z1);
% 
%     for ii = 1:length(z)
%        Radius_Z2_2(ii) = z(ii) * (DeltaCompressibilityCoefficient/CompressibilityCoefficient_Water)*R0;
%        h1_Z2_2(ii) =  (CompressibilityCoefficient_Water*(Radius_Z2_2(ii)-R0))/DeltaCompressibilityCoefficient;
%     end
% figure()
% plot(Radius_Z2_1)
% hold on
% plot(h1_Z2_2,'r')
% title('Second step, based on the first way of calculation for the 1st step')

% R0 = R0_prime - max(h1_Z3);
%     for ii = 1:length(z)
%        alpha = atan((z(ii))/R0);
%        Radius_Z2_3(ii) = R0/cos(alpha);
%        h1_Z2_3(ii) =  (CompressibilityCoefficient_Water*(Radius_Z2_3(ii)-R0))/DeltaCompressibilityCoefficient;
%     end
% figure()
% plot(Radius_Z2_3)
% hold on
% plot(h1_Z2_3,'r')
% title('Second step, based on the second way of calculation for the 1st step')



% 3D design - Revolution du tracé 2D autour de l'axe Y
% [theta,rho] = cart2pol(z,h_Z2);
% 
% xx = bsxfun(@times,rho',cos(theta_rot));
% yy = bsxfun(@times,rho',sin(theta_rot));
% zz = repmat(h_Z2',1,length(theta_rot));
% figure, mesh(xx,yy,zz)
% axis equal
% 
% 
% xx = bsxfun(@times,z',cos(theta_rot));
% yy = bsxfun(@times,z',sin(theta_rot));
% zz = repmat(h_Z2',1,length(theta_rot));
% figure, mesh(xx,yy,zz)
% axis equal


% Passage des coordonnées polaires vers cartésiennes se fait via x =
% r*cos(theta) ; y = r*sin(theta), z = z

% MatRot = [cos(theta_rot) -sin(theta_rot); sin(theta_rot) cos(theta_rot)];
