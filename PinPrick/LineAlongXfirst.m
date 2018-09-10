clc;
clear all;

%% Description of the main mouvement

% 1)Stay above the point to stimulate
% 2)Go down
% 3)Stay stable during a while
% 4)Go up
% 5) Go to the next position to stimulate
nbr_trials = 1;
%nbr_mvt=[]; = length(x)
nbr_cycles = [2000 36 525 100 525];
x = [0 0 0 0 0];
y = [0 0 0 0 0];
z = [15 15 0 0 15];
rz = [0 0 0 0 0];

Fx = [0 0 0 0 0];
Fx_control = [0 0 0 0 0];
Fy = [0 0 0 0 0];
Fy_control = [0 0 0 0 0];
Fz = [0 0 0 0 0];
Fz_control =[0 0 0 0 0];

trigger_camera = [0 0 0 0 0];
relative = [1 1 1 1 1];
acceleration = [100000 100000 100000 100000 100000];

%% Difference of heigth between the initial and ending point of the trial
% Z2 is the highest point and we have to put the difference between both
% heigth in negative!
z1 = 0;
z2 = 0;

%% Description of the trial

xnbr_stimuli = 10;
xlength_steps = 1.4; %mm
xnbr_steps = xnbr_stimuli-1;
xstep = linspace(0,xnbr_steps*xlength_steps,xnbr_stimuli);% deplacement en x pour 
xstep_neg = xstep(end:-1:1);

ynbr_stimuli = 1;
ylength_steps = 3; %mm
ynbr_steps = ynbr_stimuli-1;
ystep = linspace(0,ynbr_steps*ylength_steps,ynbr_stimuli);% deplacement en x pour 
ystep_neg = ystep(end:-1:1);

%% Correction for the Z axis-->experiment with the pinprick, applied on the forearm 

zcorr = linspace(z1,z2,xnbr_stimuli)


%% Creation of the structure to use with the Denso Robot
mvt_count = 0;

for i = 1:nbr_trials
       % TO DO : solution pour incrementer le mvt_ count en fonction du nbr de trials
   for j = 1:ynbr_stimuli
     
       for k = 1:xnbr_stimuli     
          
           for l = 1 : length(x)
               mvt_count = mvt_count +1;

               num = mod(mvt_count,length(x));
               if num ==0
                      num = 5;
               end

                per_mvt.TrialNo(mvt_count) = i;
                per_mvt.MovNo(mvt_count) = mvt_count;
                per_mvt.NrOfCycles(mvt_count) = nbr_cycles(num);
               
                if mod(j,2)
                    per_mvt.X(mvt_count) = x(num)+xstep(k);
                else
                    per_mvt.X(mvt_count) = x(num)+xstep_neg(k);
                end
                
                per_mvt.Y(mvt_count) = y(num)+ystep(j); 
                per_mvt.Z(mvt_count) = z(num) - zcorr(k);
                per_mvt.Rz(mvt_count) = rz(num);
                per_mvt.Fx(mvt_count) = Fx(num);
                per_mvt.Fx_control(mvt_count) = Fx_control(num);
                per_mvt.Fy(mvt_count) = Fy(num);
                per_mvt.Fy_control(mvt_count) = Fy_control(num);
                per_mvt.Fz(mvt_count) = Fz(num);
                per_mvt.Fz_control(mvt_count)= Fz_control(num);
                per_mvt.TrigCam(mvt_count) = trigger_camera(num);
                per_mvt.Relative(mvt_count) = relative(num);
                per_mvt.Acc(mvt_count) = acceleration(num);
               
            end
       end
              
   end
   
end
% plot3(per_mvt.X,per_mvt.Y,per_mvt.Z)
 plot(per_mvt.X,per_mvt.Z)


%% Save the structure inside a TSV files

fields = fieldnames(per_mvt);
for f = 1:length(fields)
    per_mvt.(fields{f}) = per_mvt.(fields{f})(:); %Le (:) C'est pour etre sûr que tout est sous forme de colonne
end
l=length(per_mvt.X);

savetable('LineAlongX_Slow100',per_mvt,l);