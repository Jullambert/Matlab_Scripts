%% Script made to realize a pilote experiment with TFUS
% We will deliver 
clc
clear all
%% Parameters of the experiment
ISI_Min = 3;
ISI_Max = 5;

NumberPointsRow = 9; % related to the number of row and column defined in Visor 2
NumberPointsCol = NumberPointsRow;
NumberGridPoints = NumberPointsRow*NumberPointsCol;
MarkerGrid = reshape([1:NumberGridPoints],NumberPointsRow,NumberPointsCol);
NumberTFUSStimulation = 1; % 
NumberShamStimulation = 0;

for i=1:NumberTFUSStimulation+NumberShamStimulation
   Index(:,i) = randperm(NumberGridPoints);
end
StimCondition = [zeros(NumberShamStimulation,1)' ones(NumberTFUSStimulation,1)'];
for j=1:NumberGridPoints 
RandStimCondition(:,j) = StimCondition(randperm(NumberTFUSStimulation+NumberShamStimulation));
end
RandStimCondition = RandStimCondition';
disp('The experiment parameters are set up.')

%% Generation of the experiment itself
SubjectName = input('What is the name of the subject : ','s');
str = input('If ready to start press any key ! ','s');
clc

for k=1:NumberShamStimulation+NumberTFUSStimulation % boucle pour définir le type de condition
    ISI(:,k) = randi([ISI_Min,ISI_Max],NumberGridPoints,1);
    CountGridPoints = 0;
    for l=1:NumberGridPoints % boucle pour parcourir la grille
        disp('_________________')
        pause(ISI(l,k));
        CountGridPoints=CountGridPoints+1;
        [L,C] = find(MarkerGrid == Index(l,k));
%         disp(['Stimulation # ' numdoulair2str(CountGridPoints) ' à la ligne ' num2str(L) ' et à la colonne ' num2str(C)])
        disp(['Stimulation # ' num2str(CountGridPoints) ' marqueur numero ' num2str(Index(l,k))])
        input('If ready, press "Enter" ','s')
        if RandStimCondition(l,k) == 0
            disp('Sham')
        else
            disp('TFUS')
        end
        pause(2)
        SubjectReport{l,k} = input('What did the subject feel? ','s');
        if CountGridPoints == NumberGridPoints
            disp(['Plan #' num2str(k) ' fini'])
        end
    end
end
filename = ['DonneesManipPiloteGrid_' SubjectName];
save(filename)