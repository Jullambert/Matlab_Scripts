%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Script made to analyze the calibration files for several conditions 
% for the Homemade pinprick of 64 mN with the DensoRobot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear all;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Param.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
PeakThreshold = 0.04; %valeur de seuil de detection de pic
PeakThreshold_Ft = 0.02;
Cutoff_Frequency = 50; %[Hz]
Sampling_Frequency = 1000; %[Hz]
[B A] = butter(4,Cutoff_Frequency/(Sampling_Frequency/2),'low');


StartCycleMean = 0;
StopCycleMean = StartCycleMean + 950;

FilterSpecifications = fdesign.notch('N,F0,Q,Ap',6,25,50,1,1000);
NotchFilterDesigned = design(FilterSpecifications);

Notch_Data_Filtering = 0;
Butter_Data_Filtering = 0;


% Params the calib analysis of the datas from the 23 of february 2015 :
% performed on a force and torque sensor Nano43
% PeakThreshold = 0.10; %valeur de seuil de detection de pic
% [B A] = butter(4,10/500,'low');
% Affichage = {'bx' 'go' 'r*' 'k^' 'mp' 'ch' };
% StartCycleMean = 500;
% StopCycleMean = StartCycleMean + 50;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Import Data + Variables + Filtre
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
C = importdata('manual_Emmanuel_64mN_Beep_Calib_0.csv');
c = C.data;
D = importdata('manual_RobotRajeb_64mN_0.csv');
d = D.data;

% Normal Force
Fz_Manual = -c(:,9);% for the calibration on the force sensor
time = (0:length(Fz_Manual)-1);
[ValPic, NumCycle] = findpeaks(Fz_Manual,'MinPeakDistance',3000,'MINPEAKHEIGHT',0.02);
NumCycle_Corr = [22234;36587;57815;75817;99770;122279;139104;156882;177338;198951;217259;236291;253803;270625;288833;309068;325304;348417;365998;383485;402646;421239;438676;456621;476983;493913;511632;530270;554602;571868];
figure
plot(Fz_Manual)
hold on
plot(NumCycle,ValPic,'r*')
plot(NumCycle_Corr,Fz_Manual(NumCycle_Corr),'c*')

Fz_Robot = -d(:,9);% for the calibration on the force sensor
time2 = (0:length(Fz_Robot)-1);
[ValPic_R, NumCycle_R] = findpeaks(Fz_Robot,time2','MinPeakDistance',3000,'MINPEAKHEIGHT',0.02);
NumCycle_R_Corr = [56021;82229;94879;107458;121110;133739;145356;158963;171550;183216;195880;207446;219133;232719;246353;258935;270590;282199;294787;308397;320046;331659;343315;355905;369499;382085;394755;407363;418923];

figure
plot(Fz_Robot)
hold on
plot(NumCycle_R,ValPic_R,'r*')
plot(NumCycle_R_Corr,Fz_Robot(NumCycle_R_Corr),'c*')

% Tangential forces
Fx_Manual = c(:,7);
Fy_Manual = c(:,8);
Ft_Manual = sqrt((Fx_Manual.^2)+(Fy_Manual.^2));

Fx_Robot = d(:,7);
Fy_Robot = d(:,8);
Ft_Robot = sqrt((Fx_Robot.^2)+(Fy_Robot.^2));

figure
plot(Ft_Manual)
hold on
plot(NumCycle_Corr,Ft_Manual(NumCycle_Corr),'*')
plot(Ft_Robot,'r')
plot(NumCycle_R_Corr,Ft_Robot(NumCycle_R_Corr),'*')
hold off

figure
title('Manual Fz')
for i= 1:length(NumCycle_Corr)
   Fz_Manual_Means(i) = mean(Fz_Manual(NumCycle_Corr(i):NumCycle_Corr(i)+950));
   Ft_Manual_Means(i) = mean(Ft_Manual(NumCycle_Corr(i):NumCycle_Corr(i)+950));
   Fz_Manual_Aligned(:,i) = Fz_Manual(NumCycle_Corr(i)-500:NumCycle_Corr(i)+2000);
   Ft_Manual_Aligned(:,i) = Ft_Manual(NumCycle_Corr(i)-500:NumCycle_Corr(i)+2000);
   hold on
   plot(Fz_Manual_Aligned(:,i))
end
hold off
figure
title('Manual Ft')
for i= 1:length(NumCycle_Corr)
   hold on
   plot(Ft_Manual_Aligned(:,i))
end
hold off
figure
title('Robot')
for j= 1:length(NumCycle_R_Corr)
   Fz_Robot_Means(j) = mean(Fz_Robot(NumCycle_R_Corr(j):NumCycle_R_Corr(j)+950));
   Ft_Robot_Means(j) = mean(Ft_Robot(NumCycle_R_Corr(j):NumCycle_R_Corr(j)+950));
   Fz_Robot_Aligned(:,j) = Fz_Robot(NumCycle_R_Corr(j)-500:NumCycle_R_Corr(j)+2000);
   Ft_Robot_Aligned(:,j) = Ft_Robot(NumCycle_R_Corr(j)-500:NumCycle_R_Corr(j)+2000);
   hold on
   plot(Fz_Robot_Aligned(:,j))
end
figure
title('Robot Ft')
for j= 1:length(NumCycle_R_Corr)
   hold on
   plot(Ft_Robot_Aligned(:,j))
end


Mean_Fz_Manual = mean(Fz_Manual_Means);
Std_Fz_Manual = std(Fz_Manual_Means);
Mean_Fz_Robot = mean(Fz_Robot_Means);
Std_Fz_Robot = std(Fz_Robot_Means);

Mean_Ft_Manual = mean(Ft_Manual_Means);
Std_Ft_Manual = std(Ft_Manual_Means);
Mean_Ft_Robot = mean(Ft_Robot_Means);
Std_Ft_Robot = std(Ft_Robot_Means);

%%
xlswrite('Manual_64mN_NormalForce.xls',Fz_Manual_Aligned)
xlswrite('Manual_64mN_NTangentialForce.xls',Ft_Manual_Aligned)
xlswrite('Robot_64mN_NormalForce.xls',Fz_Robot_Aligned)
xlswrite('Robot_64mN_TangentialForce.xls',Ft_Robot_Aligned)
