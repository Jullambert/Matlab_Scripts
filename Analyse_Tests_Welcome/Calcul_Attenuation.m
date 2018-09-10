%% Ref pour la distance focal : frequence @ 350 kHz sans crane: x=1,y=42 <=> (14,42) avec 5�6 mm de distance entre tr et hydro. --> donc 23 � 24 mm de distance focale
% rapport entre valeur avec sans crane � la m�me avec +/-1 pixel en x et y pour comparer
% valeur avec crane : mesures se terminent � 9 mm du tr, -14mm pour
% arriver au poit focal donc mesure at (10,42)

%% Valeur 0.8Vpp
Isppa_Water_250kHz_08Vpp = [22031.3727717687,22915.0299006560,23091.5104406495;25499.2784345554,27016.6174208515,28202.5525513510;20673.0022443695,21815.4900982665,22746.1670419755];
Isppa_Water_350kHz_08Vpp = [24374.1020424282,23795.7217458327,22639.6464174221;37708.9692308050,38635.6055481598,38543.5673228913;30755.2324542992,31658.6297161433,32369.9880988514];
Isppa_Water_500kHz_08Vpp = [3165.80785505013,2916.67827778025,2641.80099505833;6211.44870590646,6075.34129626120,5392.58903149169;3300.96630791423,3280.00510670136,3240.31666292887];

Isppa_Skull_250kHz_08Vpp = [5553.63523259924,5714.00726454516,5898.53345593558;5299.27074761313,5582.26369554729,5804.95615800894;3678.00670291249,3801.85512756155,3971.58332764144];
Isppa_Skull_350kHz_08Vpp = [4536.72895608859,4526.88189133442,4509.43763697247;4952.83512037078,4952.05319868987,4916.37895481245;3248.29936883519,3139.83844910733,3054.19093388198];
Isppa_Skull_500kHz_08Vpp = [846.486093050687,389.178344290218,479.826313134232;445.714230224156,442.403350965135,423.346151829087;205.608929485319,201.483059966667,1.43149302529556];

%% Valeur 1Vpp
Isppa_Water_250kHz_1Vpp = [31672.2437815859,32601.0903849671,33287.5509636297;36140.7236136425,38235.7941847162,39985.2825197624;29106.6657882199,30588.8712735621,31996.9514430875];
Isppa_Water_350kHz_1Vpp = [34348.2683856615,32990.0844153328,31310.6080519336;52545.3880395779,53649.4895211700,53480.4045033628;41182.8077508190,42562.8998147450,43399.0971445544];
Isppa_Water_500kHz_1Vpp = [4728.18907976119,4301.93417232085,3947.70991102355;8569.03405442913,8437.29364181417,7909.36525742844;4395.26603117588,4486.09727828446,4462.37623990726];

Isppa_Skull_250kHz_1Vpp = [7560.95071094364,7878.59486003037,7990.09540028636;7285.21521915007,7652.50669436874,7893.46765442625;5087.95436529598,5307.10772873186,5482.72912951517];
Isppa_Skull_350kHz_1Vpp = [6162.05072582166,6265.85972253852,6269.91006998459;6677.58727479899,6695.69757805174,6603.68215679025;4385.63705382877,4293.44132786021,4124.44709198550];
Isppa_Skull_500kHz_1Vpp = [587.401016166789,574.010858671715,561.853914638243;660.691415474491,662.808772124262,637.306413569349;291.557998978793,294.485629724901,292.138015250170];


%% Val 1.2 Vpp
Isppa_Water_250kHz_12Vpp = [36186.4845134401,37470.2421983042,38226.5544808111;42703.6885770449,45244.9178479087,47593.4191999682;35643.6345955592,38132.0794876267,39963.3295674741];
Isppa_Water_350kHz_12Vpp = [39934.9723765743,38636.5865171233,37114.3530630597;58671.3518011534,59255.6350939538,59088.8705679589;47608.2759666509,49076.2755543456,49678.0202754255];
Isppa_Water_500kHz_12Vpp = [4499.48971887038,4064.82421406636,3680.75965678017;10278.5630782000,10150.5813424209,9539.22980208654;6510.96034222635,6715.41746656140,6621.24060614189];

Isppa_Skull_250kHz_12Vpp = [8511.26221793214,8859.33158039963,9047.74528814585;8159.00144135691,8584.37458243074,8977.12413296558;5681.88541152832,5901.65589979458,6180.66586861228];
Isppa_Skull_350kHz_12Vpp = [6845.86015656716,6911.48108209750,6956.49400797544;7469.25959873511,7502.01974306234,7397.57442102599;4851.44279540138,4794.82428605172,4561.85039614436];
Isppa_Skull_500kHz_12Vpp = [628.195515479356,630.652558063712,634.604964605393;706.871871239941,708.594556791725,674.873408182487;323.868871794298,310.485775134051,291.597482350962];

%% Attenuation
Attenuation_250kHz_08Vpp = 10.*log10(Isppa_Water_250kHz_08Vpp./Isppa_Skull_250kHz_08Vpp);
Attenuation_350kHz_08Vpp = 10.*log10(Isppa_Water_350kHz_08Vpp./Isppa_Skull_350kHz_08Vpp);
Attenuation_500kHz_08Vpp = 10.*log10(Isppa_Water_500kHz_08Vpp./Isppa_Skull_500kHz_08Vpp);

Attenuation_250kHz_1Vpp = 10.*log10(Isppa_Water_250kHz_1Vpp./Isppa_Skull_250kHz_1Vpp);
Attenuation_350kHz_1Vpp = 10.*log10(Isppa_Water_350kHz_1Vpp./Isppa_Skull_350kHz_1Vpp);
Attenuation_500kHz_1Vpp = 10.*log10(Isppa_Water_500kHz_1Vpp./Isppa_Skull_500kHz_1Vpp);

Attenuation_250kHz_12Vpp = 10.*log10(Isppa_Water_250kHz_12Vpp./Isppa_Skull_250kHz_12Vpp);
Attenuation_350kHz_12Vpp = 10.*log10(Isppa_Water_350kHz_12Vpp./Isppa_Skull_350kHz_12Vpp);
Attenuation_500kHz_12Vpp = 10.*log10(Isppa_Water_500kHz_12Vpp./Isppa_Skull_500kHz_12Vpp);