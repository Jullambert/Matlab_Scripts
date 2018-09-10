%% Ni USB 6343 Specs
%
% Analog Inputs (AI) : 32
% Max AI Sampling Rate (1-channel) : 500 kS/s
% Max Total AI  Throughput : 500 kS/s
% Analog Outputs (AO) : 4
% Max AO Update Rate : 900 kS/s
% Digital I/O Lines : 48
% Max Digital I/O Rate : 1 MHz
% Triggering : Digital

clc
clear all

%% Params
%--------------------------------------------------------------------------

% Stimulation
High_Tactile_Frequency = 500 ; % [Hz]
Low_Tactile_Frequency = 300 ; % [Hz]
Duration_Vibrotactile_Stimulation = 0.2 ; % [s]

Laser_High_Temp = 52 ; % °C
Laser_Low_Temp = 49 ; % °C
Duration_Laser_Stimulation = 0.2 ; % [s]

Delay_Before_Stimulation = 1 ; % s
Inter_Stimulus_Interval = 8; % [s]

High_Tone_Frequency = 1000 ; %Hz
Low_Tone_Frequency = 500 ; %Hz
Duration_Tone = 0.5; %s

Duration_TTL = 0.1; %s

% Hardware
FrequencyHardware = 4400; %NumberScans/sec <=> Hz

% Experiment
Stop_Laser = false;
Stop_Vibrotactile = false;
Stop_Laser = false;
Stop_Vibrotactile = false;
Bloc_Number_Vibrotactile = 1;
Bloc_Number_Laser = 1;
Familiarisation = 1;
Bloc_Number_Vibrotactile_F = 1;
Bloc_Number_Laser_F = 1;
%% Open text file with the conditions for the familiarisation
%--------------------------------------------------------------------------
A = readtable('C:\Users\Nocions\Desktop\BBOs_DT\Conditions_Familiarisation.txt');
%1=Left_High
%2=Left_Low
%3=Right_High
%4=Right_Low
Number_Of_Blocs_Laser_F = A.Nombre_Stimulation(1)/A.Taille_Bloc(1);
Number_Of_Conditions_Laser_F = A.Nombre_Cible(1)*A.Nombre_Intensite(1);
%Computation for the laser conditions
Laser_Conditions_F = [ones(Number_Of_Blocs_Laser_F,A.Taille_Bloc(1)/Number_Of_Conditions_Laser_F), ones(Number_Of_Blocs_Laser_F,A.Taille_Bloc(1)/Number_Of_Conditions_Laser_F)+1, ones(Number_Of_Blocs_Laser_F,A.Taille_Bloc(1)/Number_Of_Conditions_Laser_F)+2, ones(Number_Of_Blocs_Laser_F,A.Taille_Bloc(1)/Number_Of_Conditions_Laser_F)+3];
for ii=1:Number_Of_Blocs_Laser_F
   Random_Condition_F = Shuffle(Laser_Conditions_F(ii,:));
   while ~Stop_Laser_F
       D_Random_Condition_F = diff(Random_Condition_F);
       D_D_Random_Condition_F = [diff(D_Random_Condition_F) 1];
       Stop_Laser = D_Random_Condition_F' & D_D_Random_Condition_F';
   end
   Laser_Conditions_F(ii,:)= Random_Condition_F;
end
Laser_Conditions_F = Laser_Conditions_F';

%Computation for the laser conditions
Number_Of_Blocs_Vibrotactile_F = A.Nombre_Stimulation(2)/A.Taille_Bloc(2);
Number_Of_Conditions_Vibrotactile_F = A.Nombre_Cible(2)*A.Nombre_Intensite(2);

Vibrotactile_Conditions_F = [ones(Number_Of_Blocs_Vibrotactile_F,A.Taille_Bloc(2)/Number_Of_Conditions_Vibrotactile_F), ones(Number_Of_Blocs_Vibrotactile_F,A.Taille_Bloc(2)/Number_Of_Conditions_Vibrotactile_F)+1, ones(Number_Of_Blocs_Vibrotactile_F,A.Taille_Bloc(2)/Number_Of_Conditions_Vibrotactile_F)+2, ones(Number_Of_Blocs_Vibrotactile_F,A.Taille_Bloc(2)/Number_Of_Conditions_Vibrotactile_F)+3];
for jj=1:Number_Of_Blocs_Vibrotactile_F
   Random_Condition_Vibrotactile_F = Shuffle(Vibrotactile_Conditions_F(jj,:));
   while ~Stop_Vibrotactile_F
       D_Random_Condition_Vibrotactile_F = diff(Random_Condition_Vibrotactile_F);
       D_D_Random_Condition_Vibrotactile_F = [diff(D_Random_Condition_Vibrotactile_F) 6];
       Stop_Vibrotactile_F = D_Random_Condition_Vibrotactile_F' & D_D_Random_Condition_Vibrotactile_F';
   end
   Vibrotactile_Conditions_F(jj,:)= Random_Condition_Vibrotactile_F;
end
Vibrotactile_Conditions_F = Vibrotactile_Conditions_F';


%% Open text file with the conditions for the experiment
%--------------------------------------------------------------------------
B = readtable('C:\Users\Nocions\Desktop\BBOs_DT\Conditions_Expe.txt');
%1=Left_High
%2=Left_Low
%3=Right_High
%4=Right_Low
Number_Of_Blocs_Laser = B.Nombre_Stimulation(1)/B.Taille_Bloc(1);
Number_Of_Conditions_Laser = B.Nombre_Cible(1)*B.Nombre_Intensite(1);
%Computation for the laser conditions
Laser_Conditions = [ones(Number_Of_Blocs_Laser,B.Taille_Bloc(1)/Number_Of_Conditions_Laser), ones(Number_Of_Blocs_Laser,B.Taille_Bloc(1)/Number_Of_Conditions_Laser)+1, ones(Number_Of_Blocs_Laser,B.Taille_Bloc(1)/Number_Of_Conditions_Laser)+2, ones(Number_Of_Blocs_Laser,B.Taille_Bloc(1)/Number_Of_Conditions_Laser)+3];
for i=1:Number_Of_Blocs_Laser
   Random_Condition = Shuffle(Laser_Conditions(i,:));
   while ~Stop_Laser
       D_Random_Condition = diff(Random_Condition);
       D_D_Random_Condition = [diff(D_Random_Condition) 1];
       Stop_Laser = D_Random_Condition' & D_D_Random_Condition';
   end
   Laser_Conditions(i,:)= Random_Condition;
end
Laser_Conditions = Laser_Conditions';

%Computation for the laser conditions
Number_Of_Blocs_Vibrotactile = B.Nombre_Stimulation(2)/B.Taille_Bloc(2);
Number_Of_Conditions_Vibrotactile = B.Nombre_Cible(2)*B.Nombre_Intensite(2);

Vibrotactile_Conditions = [ones(Number_Of_Blocs_Vibrotactile,B.Taille_Bloc(2)/Number_Of_Conditions_Vibrotactile), ones(Number_Of_Blocs_Vibrotactile,B.Taille_Bloc(2)/Number_Of_Conditions_Vibrotactile)+1, ones(Number_Of_Blocs_Vibrotactile,B.Taille_Bloc(2)/Number_Of_Conditions_Vibrotactile)+2, ones(Number_Of_Blocs_Vibrotactile,B.Taille_Bloc(2)/Number_Of_Conditions_Vibrotactile)+3];
for j=1:Number_Of_Blocs_Vibrotactile
   Random_Condition_Vibrotactile = Shuffle(Vibrotactile_Conditions(j,:));
   while ~Stop_Vibrotactile
       D_Random_Condition_Vibrotactile = diff(Random_Condition_Vibrotactile);
       D_D_Random_Condition_Vibrotactile = [diff(D_Random_Condition_Vibrotactile) 6];
       Stop_Vibrotactile = D_Random_Condition_Vibrotactile' & D_D_Random_Condition_Vibrotactile';
   end
   Vibrotactile_Conditions(j,:)= Random_Condition_Vibrotactile;
end
Vibrotactile_Conditions = Vibrotactile_Conditions';
%% Preparing the different stimulation waveforms & initializing the data acquisition card
%--------------------------------------------------------------------------
% Initializing Hardware
[NI, ch] = niconnexion(FrequencyHardware,0,4,0,1);
disp('AI 0 : Temperature Feedback');
disp('AO 0 : Sound - Mono');
disp('AO 1 : Laser LSD - Temperature control');
disp('AO 2 : Vibrotactile - Left');
disp('AO 3 : Vibrotactile - Right');

%voltage_temperature conversion ; 60°C = 8.57 V
NI.V0temp=20;
NI.V10temp=70;
NI.out_slope=10/(NI.V10temp-NI.V0temp);
NI.out_intercept=10-(NI.out_slope*NI.V10temp);


T_ISI = linspace(0,Inter_Stimulus_Interval,Inter_Stimulus_Interval*FrequencyHardware);
T_Stim = linspace(0,Duration_Vibrotactile_Stimulation,Duration_Vibrotactile_Stimulation*FrequencyHardware);
T_Tone = linspace(0,Duration_Tone,Duration_Tone*FrequencyHardware);

High_Tactile_Waveform = zeros(length(T_ISI)+length(T_Stim)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware,1);
Low_Tactile_Waveform = zeros(length(T_ISI)+length(T_Stim)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware,1);

High_Tone_Waveform = zeros(length(T_ISI)+length(T_Stim)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware,1);
Low_Tone_Waveform = zeros(length(T_ISI)+length(T_Stim)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware,1);
TTL = zeros(length(T_ISI)+length(T_Stim)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware,1);
TTL(length(T_ISI)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware+1:length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware+Duration_TTL*FrequencyHardware,1) = 1;

Low_Tactile_Waveform(length(T_ISI)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware+1:end,1) = 5.*sin(Low_Tactile_Frequency*2*pi*T_Stim);
High_Tactile_Waveform(length(T_ISI)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware+1:end,1) = 5.*sin(High_Tactile_Frequency*2*pi*T_Stim)';

High_Tone_Waveform(length(T_ISI)+1:length(T_ISI)+length(T_Tone),1) = 0.15.*sin(High_Tone_Frequency*2*pi*T_Tone);
Low_Tone_Waveform(length(T_ISI)+1:length(T_ISI)+length(T_Tone),1) = 0.15.*sin(Low_Tone_Frequency*2*pi*T_Tone);
% Adding white noise before the tone, during ISI, because it is possible to
% hear the LSD stimulator
High_Tone_Waveform(1:length(T_ISI),1) = 0.1.*(1+2*randn(length(T_ISI),1)); 
Low_Tone_Waveform(1:length(T_ISI),1) =  0.1.*(1+2*randn(length(T_ISI),1));
% Adding white noise after the tone because it is possible to hear the vibrotactile stimulation
High_Tone_Waveform(length(T_ISI)+length(T_Tone)+1:end,1) = 0.1.*(1+2*randn(length(High_Tone_Waveform)-length(T_Tone)-length(T_ISI),1)); 
Low_Tone_Waveform(length(T_ISI)+length(T_Tone)+1:end,1) =  0.1.*(1+2*randn(length(Low_Tone_Waveform)-length(T_Tone)-length(T_ISI),1));

% [data]=LSD_stimulate(NI,base_temperature,stim_temperature,stim_duration,foreperiod_duration,total_duration)
Low_Temp_Laser_Waveform=LSD_temperature_stimulation(NI,20,Laser_Low_Temp,Duration_Vibrotactile_Stimulation,Delay_Before_Stimulation,Duration_Vibrotactile_Stimulation+Duration_Tone+Delay_Before_Stimulation);
Low_Temp_Laser_Waveform = Low_Temp_Laser_Waveform';
High_Temp_Laser_Waveforme=LSD_temperature_stimulation(NI,20,Laser_High_Temp,Duration_Vibrotactile_Stimulation,Delay_Before_Stimulation,Duration_Vibrotactile_Stimulation+Duration_Tone+Delay_Before_Stimulation);
High_Temp_Laser_Waveforme = High_Temp_Laser_Waveforme';

%% Script for the experiment itself
%--------------------------------------------------------------------------
Stimuli = {};

SubjectName = input('Name of the subject \n','s');
if Familiarisation
    for kk=1:Number_Of_Blocs_Laser_F+Number_Of_Blocs_Vibrotactile_F
        if ~mod(kk,2) %Way to test if the number of the bloc is odd or even . 0 = the number of the bloc is even ->Vibro
            input('Ready for the bloc - vibrotactile ?')
            for ll=1:A.Taille_Bloc(2)
                switch Vibrotactile_Conditions_F(ll,Bloc_Number_Vibrotactile_F)
                    case 1  %1=Left_High
                        Tactile_Left = High_Tactile_Waveform;
                        Tactile_Right = zeros(length(T_ISI)+length(T_Stim)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware,1);
                        Tone = Low_Tone_Waveform;
                        LSD_Temp = zeros(length(High_Tactile_Waveform),1);
                        Trigger = TTL;
                        %Stimuli{l,k} = 'Vibrotactile: Left arm - High ';
                        disp(['Trial #' num2str(ll) ' vibrotactile: Left arm - High '])
                    case 2  %2=Left_Low
                        Tactile_Left = Low_Tactile_Waveform;
                        Tactile_Right = zeros(length(T_ISI)+length(T_Stim)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware,1);
                        Tone = Low_Tone_Waveform;
                        LSD_Temp = zeros(length(High_Tactile_Waveform),1);
                        Trigger = TTL;
                        %Stimuli{l,k} = 'Vibrotactile: Left arm - low ';
                        disp(['Trial #' num2str(ll) ' vibrotactile : Left arm - Low '])

                    case 3  %3=Right_High
                        Tactile_Left = zeros(length(T_ISI)+length(T_Stim)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware,1);
                        Tactile_Right = High_Tactile_Waveform;
                        Tone = High_Tone_Waveform;
                        LSD_Temp = zeros(length(High_Tactile_Waveform),1);
                        Trigger = TTL;
                        %Stimuli{l,k} = 'Vibrotactile: Right arm - High ';
                        disp(['Trial #' num2str(l) ' vibrotactile: Right arm - High'])

                    case 4  %4=Right_Low 
                        Tactile_Left = zeros(length(T_ISI)+length(T_Stim)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware,1);
                        Tactile_Right = Low_Tactile_Waveform;
                        Tone = High_Tone_Waveform;
                        LSD_Temp = zeros(length(High_Tactile_Waveform),1);
                        Trigger = TTL;                    
                        Stimuli{l,k} = 'Vibrotactile: Right arm - Low ';
                        disp(['Trial #' num2str(ll) ' vibrotactile: Right arm - Low '])

                end
                queueOutputData(NI.session,[Tone LSD_Temp Tactile_Left Tactile_Right TTL]);
                disp('Data sent to NI');
                prepare(NI.session)
                disp('Trial starts in 5 secondes')
                %pause(8)
                [data,time] = startForeground(NI.session);   
%                [data,time] =NI.session.startForeground();
                %SubjectEvaluation{l,k} = input('Evaluation ','s');
                disp('-----------------------------------------');
            end    
%             Bloc_Number_Vibrotactile = Bloc_Number_Vibrotactile + 1 ;   
        else
            input('Ready for the bloc - laser')
            for mm=1:A.Taille_Bloc(1)
                switch Laser_Conditions_F(mm,Bloc_Number_Laser_F)
                    case 1  %1=Left_High
                        Tactile_Left = zeros(length(T_ISI)+length(T_Stim)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware,1);
                        Tactile_Right = zeros(length(T_ISI)+length(T_Stim)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware,1);
                        Tone = Low_Tone_Waveform;
                        LSD_Temp = High_Temp_Laser_Waveforme;
                        Trigger = TTL;
                        %Stimuli{m,k} = 'Laser: Left arm - High ';
                        disp(['Trial #' num2str(mm) ' laser: Left arm - High'])

                    case 2  %2=Left_Low
                        Tactile_Left = zeros(length(T_ISI)+length(T_Stim)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware,1);
                        Tactile_Right = zeros(length(T_ISI)+length(T_Stim)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware,1);
                        Tone = Low_Tone_Waveform;
                        LSD_Temp = Low_Temp_Laser_Waveform;
                        Trigger = TTL;
                        %Stimuli{m,k} = 'Laser: Left arm - Low ';
                        disp(['Trial #' num2str(mm) ' laser: Left arm - Low '])

                    case 3  %3=Right_High
                        Tactile_Left = zeros(length(T_ISI)+length(T_Stim)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware,1);
                        Tactile_Right = zeros(length(T_ISI)+length(T_Stim)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware,1);
                        Tone = High_Tone_Waveform;
                        LSD_Temp = High_Temp_Laser_Waveforme;
                        Trigger = TTL;
                        %Stimuli{m,k} = 'Laser: Right arm - High ';
                        disp(['Trial #' num2str(mm) ' laser: Right arm - High'])

                    case 4  %4=Right_Low 
                        Tactile_Left = zeros(length(T_ISI)+length(T_Stim)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware,1);
                        Tactile_Right = zeros(length(T_ISI)+length(T_Stim)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware,1);
                        Tone = High_Tone_Waveform;
                        LSD_Temp = Low_Temp_Laser_Waveform;
                        Trigger = TTL;
                        Stimuli{m,k} = 'Laser: Right arm - Low ';
                        disp(['Trial #' num2str(mm) ' laser: Right arm - Low'])

                end

                queueOutputData(NI.session,[Tone LSD_Temp Tactile_Left Tactile_Right TTL]);
                disp('Data sent to NI');
                prepare(NI.session)
                disp('Trial starts in 8 secondes')
                %pause(8)
                [data,time] = startForeground(NI.session);
%                 [data,time] = NI.session.startForeground();
                %SubjectEvaluation{m,k} = input('Evaluation ','s');
                disp('-----------------------------------------');

            end
%         Bloc_Number_Laser = Bloc_Number_Laser+1;
        end
    end    
    
    Familiarisation = 0;
    
else
    input('Ready to start the experiment? ')
    for k=1:Number_Of_Blocs_Laser+Number_Of_Blocs_Vibrotactile
        if ~mod(k,2) %Way to test if the number of the bloc is odd or even . 0 = the number of the bloc is even ->Vibro
            input('Ready for the bloc - vibrotactile ?')
            for l=1:B.Taille_Bloc(2)
                switch Vibrotactile_Conditions(l,Bloc_Number_Vibrotactile)
                    case 1  %1=Left_High
                        Tactile_Left = High_Tactile_Waveform;
                        Tactile_Right = zeros(length(T_ISI)+length(T_Stim)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware,1);
                        Tone = Low_Tone_Waveform;
                        LSD_Temp = zeros(length(High_Tactile_Waveform),1);
                        Trigger = TTL;
                        Stimuli{l,k} = 'Vibrotactile: Left arm - High ';
                        disp(['Trial #' num2str(l) ' vibrotactile: Left arm - High '])
                    case 2  %2=Left_Low
                        Tactile_Left = Low_Tactile_Waveform;
                        Tactile_Right = zeros(length(T_ISI)+length(T_Stim)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware,1);
                        Tone = Low_Tone_Waveform;
                        LSD_Temp = zeros(length(High_Tactile_Waveform),1);
                        Trigger = TTL;
                        Stimuli{l,k} = 'Vibrotactile: Left arm - low ';
                        disp(['Trial #' num2str(l) ' vibrotactile : Left arm - Low '])

                    case 3  %3=Right_High
                        Tactile_Left = zeros(length(T_ISI)+length(T_Stim)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware,1);
                        Tactile_Right = High_Tactile_Waveform;
                        Tone = High_Tone_Waveform;
                        LSD_Temp = zeros(length(High_Tactile_Waveform),1);
                        Trigger = TTL;
                        Stimuli{l,k} = 'Vibrotactile: Right arm - High ';
                        disp(['Trial #' num2str(l) ' vibrotactile: Right arm - High'])

                    case 4  %4=Right_Low 
                        Tactile_Left = zeros(length(T_ISI)+length(T_Stim)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware,1);
                        Tactile_Right = Low_Tactile_Waveform;
                        Tone = High_Tone_Waveform;
                        LSD_Temp = zeros(length(High_Tactile_Waveform),1);
                        Trigger = TTL;                    
                        Stimuli{l,k} = 'Vibrotactile: Right arm - Low ';
                        disp(['Trial #' num2str(l) ' vibrotactile: Right arm - Low '])

                end
                queueOutputData(NI.session,[Tone LSD_Temp Tactile_Left Tactile_Right TTL]);
                disp('Data sent to NI');
                prepare(NI.session)
                disp('Trial starts in 5 secondes')
                %pause(8)
                [Temperature_Feedback(l,k,:),time(l,k,:)] = startForeground(NI.session);
%                [data,time] = NI.session.startForeground();  
                SubjectEvaluation{l,k} = input('Evaluation ','s');
                disp('-----------------------------------------');
            end    
            Bloc_Number_Vibrotactile = Bloc_Number_Vibrotactile + 1 ;   
        else
            input('Ready for the bloc - laser')
            for m=1:B.Taille_Bloc(1)
                switch Laser_Conditions(m,Bloc_Number_Laser)
                    case 1  %1=Left_High
                        Tactile_Left = zeros(length(T_ISI)+length(T_Stim)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware,1);
                        Tactile_Right = zeros(length(T_ISI)+length(T_Stim)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware,1);
                        Tone = Low_Tone_Waveform;
                        LSD_Temp = High_Temp_Laser_Waveforme;
                        Trigger = TTL;
                        Stimuli{m,k} = 'Laser: Left arm - High ';
                        disp(['Trial #' num2str(m) ' laser: Left arm - High'])

                    case 2  %2=Left_Low
                        Tactile_Left = zeros(length(T_ISI)+length(T_Stim)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware,1);
                        Tactile_Right = zeros(length(T_ISI)+length(T_Stim)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware,1);
                        Tone = Low_Tone_Waveform;
                        LSD_Temp = Low_Temp_Laser_Waveform;
                        Trigger = TTL;
                        Stimuli{m,k} = 'Laser: Left arm - Low ';
                        disp(['Trial #' num2str(m) ' laser: Left arm - Low '])

                    case 3  %3=Right_High
                        Tactile_Left = zeros(length(T_ISI)+length(T_Stim)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware,1);
                        Tactile_Right = zeros(length(T_ISI)+length(T_Stim)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware,1);
                        Tone = High_Tone_Waveform;
                        LSD_Temp = High_Temp_Laser_Waveforme;
                        Trigger = TTL;
                        Stimuli{m,k} = 'Laser: Right arm - High ';
                        disp(['Trial #' num2str(m) ' laser: Right arm - High'])

                    case 4  %4=Right_Low 
                        Tactile_Left = zeros(length(T_ISI)+length(T_Stim)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware,1);
                        Tactile_Right = zeros(length(T_ISI)+length(T_Stim)+length(T_Tone)+Delay_Before_Stimulation*FrequencyHardware,1);
                        Tone = High_Tone_Waveform;
                        LSD_Temp = Low_Temp_Laser_Waveform;
                        Trigger = TTL;
                        Stimuli{m,k} = 'Laser: Right arm - Low ';
                        disp(['Trial #' num2str(m) ' laser: Right arm - Low'])

                end

                queueOutputData(NI.session,[Tone LSD_Temp Tactile_Left Tactile_Right TTL]);
                disp('Data sent to NI');
                prepare(NI.session)
                disp('Trial starts in 8 secondes')
                %pause(8)
                [Temperature_Feedback(m,k,:),time(m,k,:)] = startForeground(NI.session);
%                [data,time] = NI.session.startForeground();
                SubjectEvaluation{m,k} = input('Evaluation ','s');
                disp('-----------------------------------------');

            end
        Bloc_Number_Laser = Bloc_Number_Laser+1;
        end
    end
end

%% Saving the data
%--------------------------------------------------------------------------
filename = [SubjectName '_LaserFirst_52_49'];
save(filename,'Stimuli','SubjectEvaluation','Laser_Conditions','Vibrotactile_Conditions','Temperature_Feedback','time')

