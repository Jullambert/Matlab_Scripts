filename=['sequence ',strcat(datestr(clock,'yyyy-mm-dd-HHMM'),'m',datestr(clock,'ss'),'s')];
disp(filename);

%%% create seq: sequence, with 1 = "normal trial", 2 = "trial + RATING" %%%
seq=[ones(1,20),(ones(1,10)+1)];

%%% never 2 "trial + RATING" succeding %%%
is_success=0;
while(~is_success)
    is_success=1;
    serie=seq(randperm(length(seq)));
    for consec=2:30
        check_consec=sum(serie(consec-1:consec));
        if(check_consec==4)
            is_success=0;
        end
    end
end

seqfinal=zeros(30,1);
seqfinal([1:30],1)=serie';
seqfinal(30,1)=(seqfinal(30,1))+2;

save(filename,'seqfinal')