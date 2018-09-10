Stim = {'TMS' 'TMS_Sham' 'TFUS' 'TFUS_Sham'}; % 1= TMS 2 = TMS_Sham 3= TFUS 4= TFUS_Sham
Direction1 = [12 21 12 21];
Direction2 = [14 41 14 41];
NumberParticipants = 15;

for j = 1:NumberParticipants
    StimShuffled(j,:) = randperm(size(Stim,2));
    Direction1Shuffled(j,:) = randperm(size(Direction1,2));
    Direction2Shuffled(j,:) = randperm(size(Direction2,2));
end

Index1=[1:3:12];
for l=1:length(Stim)
    for m = 1:NumberParticipants
        Map{m,Index1(l)} = Stim{StimShuffled(m,l)};
    end
end
clear m

Index2=[2:3:12];
for n=1:length(Stim)
    for m = 1:NumberParticipants
        Map{m,Index2(n)} = Direction1(Direction1Shuffled(m,n));
    end
end
clear m

Index3=[3:3:12];
for k=1:length(Stim)
    for m = 1:NumberParticipants
        Map{m,Index3(k)} = Direction2(Direction2Shuffled(m,k));
    end
end