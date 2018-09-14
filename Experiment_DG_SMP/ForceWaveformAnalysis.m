%% Script to analyse forces waveform from the Stimtac & SMP setup
clc;
clear all;
%% Parameters relative to the robot displacement.
% Reminder : one trial = 2 slidings, both are identical about the X-Y and
% timing. The difference is about the normal force applied
robot_command_file = readtable('D:\Documents\CATL\Stimtac_JL\Test_9mvt_NoRand_Acc50000_50.tsv');
robot_command_generation = load('D:\Documents\CATL\Stimtac_JL\Test_9mvt_NoRand_Acc50000_50.mat');
trial_timing = robot_command_file.NrOfCycles(robot_command_file.TrialNo(:)==1);
one_exploration_timing = sum(trial_timing)/2;

%% Import of the data for one sesssion
% One folder contains the files from one subject
data_files_root_dir = uigetdir; % open a GUI to select the folder to open (where are stored the data)
data_files_name = dir(data_files_root_dir); % Variable with all the name inside the folder RootDir
data_files_name(1:2) = []; % delete . and ..
cd(data_files_root_dir) % Change the current folder to the folder where are the data

for a=1:size(data_files_name,1)
    index1= strfind(data_files_name(a).name,'_Acc50000_50_JL_')+16;
    index2= strfind(data_files_name(a).name,'.csv');
    str_value(a) = str2num(data_files_name(a).name(index1:index2));
    [b,c]=sort(str_value);
end
data_files_name = data_files_name(c);

for k=1:size(data_files_name,1)
    trial = importdata(data_files_name(k).name);
    normal_force(:,k) = trial.data(:,11);
end

%% Signal processing
normal_force_baseline = [];
normal_force_condition_1N=[];
normal_force_condition_09N=[];
normal_force_condition_08N=[];
normal_force_condition_07N=[];
normal_force_condition_062N=[];
normal_force_condition_05N =[];
% Filter design
cutoff_frequency = 150;
sampling_frequency = 1000;
[B A] = butter(2,cutoff_frequency/(sampling_frequency/2),'low');

for kk = 1:size(normal_force,2)
        normal_force_filtered(:,kk)= filtfilt(B, A,normal_force(:,kk));
end

for i=1:size(data_files_name,1)
    for n = 1:size(robot_command_file.Fz,1)
        switch robot_command_generation.StimCondition(i,1)
            case 1
                normal_force_baseline(:,i) = normal_force_filtered(1:one_exploration_timing,i);
                if robot_command_file.TrialNo(n)==i & robot_command_file.MovNo(n) ==  14
                    switch robot_command_file.Fz(n)
                        case 1
                            normal_force_condition_1N = [normal_force_condition_1N  normal_force_filtered(one_exploration_timing+1:end,i)];
                        case 0.9
                            normal_force_condition_09N = [normal_force_condition_09N  normal_force_filtered(one_exploration_timing+1:end,i)];
                        case 0.8
                            normal_force_condition_08N= [normal_force_condition_08N  normal_force_filtered(one_exploration_timing+1:end,i)];
                        case 0.7
                            normal_force_condition_07N = [normal_force_condition_07N  normal_force_filtered(one_exploration_timing+1:end,i)];
                        case 0.62
                            normal_force_condition_062N = [normal_force_condition_062N  normal_force_filtered(one_exploration_timing+1:end,i)];
                        case 0.5
                            normal_force_condition_05N = [normal_force_condition_05N  normal_force_filtered(one_exploration_timing+1:end,i)];
                    end
                end
            case 2
                normal_force_baseline(:,i) = normal_force_filtered(one_exploration_timing+1:end,i);
                if robot_command_file.TrialNo(n)==i & robot_command_file.MovNo(n) ==  5
                    switch robot_command_file.Fz(n)
                        case 1
                        normal_force_condition_1N = [normal_force_condition_1N  normal_force_filtered(1:one_exploration_timing,i)];
                        case 0.9
                            normal_force_condition_09N = [normal_force_condition_09N  normal_force_filtered(1:one_exploration_timing,i)];
                        case 0.8
                            normal_force_condition_08N = [normal_force_condition_08N  normal_force_filtered(1:one_exploration_timing,i)];
                        case 0.7
                            normal_force_condition_07N = [normal_force_condition_07N  normal_force_filtered(1:one_exploration_timing,i)];
                        case 0.62
                            normal_force_condition_062N = [normal_force_condition_062N  normal_force_filtered(1:one_exploration_timing,i)];
                        case 0.5
                            normal_force_condition_05N = [normal_force_condition_05N  normal_force_filtered(1:one_exploration_timing,i)];
                    end
                end                 
        end
    end
end

%% Signal analysis

for m = 1 : size(normal_force_baseline,2)
    normal_force_baseline_mean(:,m) = mean(normal_force_baseline(sum(robot_command_generation.NrOfCycles(1:3)):sum(robot_command_generation.NrOfCycles(1:6)),m));
    normal_force_baseline_sd(:,m) = std(normal_force_baseline(sum(robot_command_generation.NrOfCycles(1:3)):sum(robot_command_generation.NrOfCycles(1:6)),m));
end
for j = 1:size(normal_force_condition_1N,2)
    normal_force_condition_1N_mean(:,j) = mean(normal_force_condition_1N(sum(robot_command_generation.NrOfCycles(1:3)):sum(robot_command_generation.NrOfCycles(1:6)),j));
    normal_force_condition_09N_mean(:,j) = mean(normal_force_condition_09N(sum(robot_command_generation.NrOfCycles(1:3)):sum(robot_command_generation.NrOfCycles(1:6)),j));
    normal_force_condition_08N_mean(:,j) = mean(normal_force_condition_08N(sum(robot_command_generation.NrOfCycles(1:3)):sum(robot_command_generation.NrOfCycles(1:6)),j));
    normal_force_condition_07N_mean(:,j) = mean(normal_force_condition_07N(sum(robot_command_generation.NrOfCycles(1:3)):sum(robot_command_generation.NrOfCycles(1:6)),j));
    normal_force_condition_062N_mean(:,j) = mean(normal_force_condition_062N(sum(robot_command_generation.NrOfCycles(1:3)):sum(robot_command_generation.NrOfCycles(1:6)),j));
    normal_force_condition_05N_mean(:,j) = mean(normal_force_condition_05N(sum(robot_command_generation.NrOfCycles(1:3)):sum(robot_command_generation.NrOfCycles(1:6)),j));
    
    normal_force_condition_1N_sd(:,j) = std(normal_force_condition_1N(sum(robot_command_generation.NrOfCycles(1:3)):sum(robot_command_generation.NrOfCycles(1:6)),j));
    normal_force_condition_09N_sd(:,j) = std(normal_force_condition_09N(sum(robot_command_generation.NrOfCycles(1:3)):sum(robot_command_generation.NrOfCycles(1:6)),j));
    normal_force_condition_08N_sd(:,j) = std(normal_force_condition_08N(sum(robot_command_generation.NrOfCycles(1:3)):sum(robot_command_generation.NrOfCycles(1:6)),j));
    normal_force_condition_07N_sd(:,j) = std(normal_force_condition_07N(sum(robot_command_generation.NrOfCycles(1:3)):sum(robot_command_generation.NrOfCycles(1:6)),j));
    normal_force_condition_062N_sd(:,j) = std(normal_force_condition_062N(sum(robot_command_generation.NrOfCycles(1:3)):sum(robot_command_generation.NrOfCycles(1:6)),j));
    normal_force_condition_05N_sd(:,j) = std(normal_force_condition_05N(sum(robot_command_generation.NrOfCycles(1:3)):sum(robot_command_generation.NrOfCycles(1:6)),j));
        
end
%% Plotting the results
Time = 1:size(normal_force_baseline,1);
figure
for mm = 1 : size(normal_force_baseline,2)
    plot(Time,normal_force_baseline(:,mm));
    hold on
    plot(sum(robot_command_generation.NrOfCycles(1:3)),normal_force_baseline(sum(robot_command_generation.NrOfCycles(1:3)),mm),'*r')
    plot(sum(robot_command_generation.NrOfCycles(1:6)),normal_force_baseline(sum(robot_command_generation.NrOfCycles(1:6)),mm),'*r')
end
title('Normal force - baseline [N] - 10 mvt - Acc 100000')
clear mm

Time1 = 1:size(normal_force_condition_1N,1);
figure
for mm = 1 : size(normal_force_condition_1N,2)
    plot(Time1,normal_force_condition_1N(:,mm));
    hold on
    plot(sum(robot_command_generation.NrOfCycles(1:3)),normal_force_condition_1N(sum(robot_command_generation.NrOfCycles(1:3)),mm),'*r')
    plot(sum(robot_command_generation.NrOfCycles(1:6)),normal_force_condition_1N(sum(robot_command_generation.NrOfCycles(1:6)),mm),'*r')
end
title('Normal force - condition 1N - 10 mvt - Acc 100000')
clear mm

figure
for mm = 1 : size(normal_force_condition_09N,2)
    plot(Time1,normal_force_condition_09N(:,mm));
    hold on
    plot(sum(robot_command_generation.NrOfCycles(1:3)),normal_force_condition_09N(sum(robot_command_generation.NrOfCycles(1:3)),mm),'*r')
    plot(sum(robot_command_generation.NrOfCycles(1:6)),normal_force_condition_09N(sum(robot_command_generation.NrOfCycles(1:6)),mm),'*r')
end
title('Normal force - condition 0.9N - 10 mvt - Acc 100000')
clear mm

figure
for mm = 1 : size(normal_force_condition_08N,2)
    plot(Time1,normal_force_condition_08N(:,mm));
    hold on
    plot(sum(robot_command_generation.NrOfCycles(1:3)),normal_force_condition_08N(sum(robot_command_generation.NrOfCycles(1:3)),mm),'*r')
    plot(sum(robot_command_generation.NrOfCycles(1:6)),normal_force_condition_08N(sum(robot_command_generation.NrOfCycles(1:6)),mm),'*r')
end
title('Normal force - condition 0.8N - 10 mvt - Acc 100000')
clear mm

figure
for mm = 1 : size(normal_force_condition_07N,2)
    plot(Time1,normal_force_condition_07N(:,mm));
    hold on
    plot(sum(robot_command_generation.NrOfCycles(1:3)),normal_force_condition_07N(sum(robot_command_generation.NrOfCycles(1:3)),mm),'*r')
    plot(sum(robot_command_generation.NrOfCycles(1:6)),normal_force_condition_07N(sum(robot_command_generation.NrOfCycles(1:6)),mm),'*r')
end
title('Normal force - condition 0.7N - 10 mvt - Acc 100000')
clear mm

figure
for mm = 1 : size(normal_force_condition_062N,2)
    plot(Time1,normal_force_condition_062N(:,mm));
    hold on
    plot(sum(robot_command_generation.NrOfCycles(1:3)),normal_force_condition_062N(sum(robot_command_generation.NrOfCycles(1:3)),mm),'*r')
    plot(sum(robot_command_generation.NrOfCycles(1:6)),normal_force_condition_062N(sum(robot_command_generation.NrOfCycles(1:6)),mm),'*r')
end
title('Normal force - condition 0.62N - 10 mvt - Acc 100000')
clear mm

figure
for mm = 1 : size(normal_force_condition_05N,2)
    plot(Time1,normal_force_condition_05N(:,mm));
    hold on
    plot(sum(robot_command_generation.NrOfCycles(1:3)),normal_force_condition_05N(sum(robot_command_generation.NrOfCycles(1:3)),mm),'*r')
    plot(sum(robot_command_generation.NrOfCycles(1:6)),normal_force_condition_05N(sum(robot_command_generation.NrOfCycles(1:6)),mm),'*r')
end
title('Normal force - condition 0.5N - 10 mvt - Acc 100000')
clear mm
%%
save('Results_Test_9mvt_Acc50000_50')

%%
mean(normal_force_baseline_mean)
mean(normal_force_baseline_sd)
mean(normal_force_condition_1N_mean)
mean(normal_force_condition_1N_sd)
mean(normal_force_condition_09N_mean)
mean(normal_force_condition_09N_sd)
mean(normal_force_condition_08N_mean)
mean(normal_force_condition_08N_sd)
mean(normal_force_condition_07N_mean)
mean(normal_force_condition_07N_sd)
mean(normal_force_condition_062N_mean)
mean(normal_force_condition_062N_sd)
mean(normal_force_condition_05N_mean)
mean(normal_force_condition_05N_sd)