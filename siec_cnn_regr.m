function [Bledy]=siec_cnn_regr(xu, xt, du, dt)

[rozmx, rozmy, l_col, l_obr] = size(xu);

layers = [ ...                                          % warstwy sieci konwolucyjnej
    imageInputLayer([rozmx rozmy 1])
    convolution2dLayer(3,55)
    reluLayer
    convolution2dLayer(1,55)
    reluLayer
    fullyConnectedLayer(48)
    reluLayer
    fullyConnectedLayer(24)
    regressionLayer];


options = trainingOptions('sgdm','MaxEpochs', 500);     % opcje uczenia sieci
net = trainNetwork(xu,du,layers,options);               % uczenie sieci

%% testowanie
yu = predict(net,xu);                                   % predykcja
yt = predict(net,xt);

%% przewidywanie dla konkretnego dnia
% Craw=[];                                                % wczytywanie danych potrzebnych do przewidywañ
% 
% plikcsv = sprintf('8-14112017.csv');
% [num,txt,raw] = xlsread( plikcsv );
% Craw = raw(2:end,:);
% 
% D = Craw(:,4);
% T = sprintf('%s*', D{:});
% U = sscanf(T, '%f*');  
% maxP = 2.6231e+04;
% U = U./maxP;  
% disp(U);
% 
% W = spectrogram(U);                                     % tworzenie obrazu
% obraz_test = abs(W);
% 
% ytest = predict(net,obraz_test);                        % predykcja
%  
% disp(ytest(1,:));                                       % wyœwietlenie wyników
% 
% figure(2)
% ytest = ytest*(2.6231e+04);
% xlimits = [0 24];
% ylimits = [13000 26000];
% plot(ytest);
% xlim(xlimits);
% ylim(ylimits);
% title('Chwilowe zapotrzebowanie mocy w Polsce')
% xlabel('godziny');
% ylabel('moc [kWh]');

%% b³êdy

erru = (abs(yu-du)./abs(du))*100;
errt = (abs(yt-dt)./abs(dt))*100;

erru_mean = mean(mean(erru));                            % b³¹d œredni
errt_mean = mean(mean(errt));

erru_max = max(max(erru));                               % b³¹d maksymalny
errt_max = max(max(errt));

eu = abs(yu-du);
et = abs(yt-dt);

erru_mae = mae(eu)*262.31;                              % b³¹d œredni absolutny
errt_mae = mae(et)*262.31;

Bledy = [];
Bledy(1,1) = errt_mean;
Bledy(2,1) = erru_mean;
Bledy(3,1) = errt_max;
Bledy(4,1) = erru_max;
Bledy(5,1) = errt_mae;
Bledy(6,1) = erru_mae;

disp(Bledy);                                            % wyœwietlanie b³êdów

%% porównanie wyników przewidywañ dla dowolnego dnia z wartoœciami rzeczywistymi

figure(1)
yt = yt*(2.6231e+04);
dt = dt*(2.6231e+04);

xlimits = [0 24];
ylimits = [13000 24000];
clf
plot(dt(55,:)),hold on, plot(yt(55,:),'r')
return
xlim(xlimits);
ylim(ylimits);
title('Chwilowe zapotrzebowanie mocy w Polsce')
xlabel('godziny');
ylabel('moc [kWh]');

