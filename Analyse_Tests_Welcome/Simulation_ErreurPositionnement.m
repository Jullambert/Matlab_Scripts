
mu = 0;
sigma = 1.2;
x = size(v,1);
y = size(v,2);


%%

for k=1:1000
    Proba_Placement = normrnd(mu,sigma,[1,y]);
    Yvector_Proba = Yvector.*Proba_Placement;
    for xx = 1:size(v,1)
        for yy =1:size(v,2)
            Proba_Isppa(k,xx,yy) = interpol2(Xvector,Yvector,Isppa,Xvector,Yvector_Proba);
        end
    end
    %
    for xx = 1:size(v,1)
        for yy=1:size(v,2)

          

        end
    end

end

%%

for l=1:1000
    Proba_Placement_Plan(l,:,:) = normrnd(mu,sigma,[x,y]);
    for xx = 1:size(v,1)
        for yy =1:size(v,2)
            Proba_Isppa_Plan(l,xx,yy) = Isppa(xx,yy)*Proba_Placement_Plan(l,xx,yy);
        end
    end
    %
    for xx = 1:size(v,1)
        for yy=1:size(v,2)

        Erreur_Isppa_Plan(l,xx,yy) = abs(Isppa(xx,yy)-Proba_Isppa_Plan(l,xx,yy))/Isppa(xx,yy);   

        end
    end

end

%%
Proba_Erreur_Moyenne_Plan = mean(Erreur_Isppa(:,27,85))
