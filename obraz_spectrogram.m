
function [] = obraz_spectrogram(numofdays,P)
lprob = 96;                             % liczba probek w ci�gu doby
[lw,lk] = size(P);                      % rozmiar wektora obci��e�
xnum = floor(((lw-((numofdays*lprob)+lprob))/lprob)+1);         %liczba par 
ipocz = (numofdays*lprob+1);
R = spectrogram(P(ipocz:-lprob/24:ipocz-numofdays*lprob));
[k,j] = size(R);
sizeu = ceil(5*xnum/6);                 % liczba par ucz�cych
sizet = xnum-sizeu;                     % liczba par testuj�cych
xu = zeros(k,j,1,sizeu);
xt = zeros(k,j,1,sizet);
xtemp = zeros(k,j,1,xnum);              % pary tymczasowe
dtemp = [];
du = [];
dt = [];
count = 1;
for i = (numofdays*lprob+1):lprob:lw-lprob+1          % tworzenie par
    d = P(i:lprob/24:i+lprob-1)';
    s = spectrogram(P(i-1:-lprob/24:i-numofdays*lprob));
    xtemp(:,:,1,count) = abs(s);
    dtemp = [dtemp;d];
    count = count+1;
end
idx = randperm(xnum);                   % wektor losowych warto�ci z przedzia�u 1:xnum
xu = xtemp(:,:,1,idx(1:sizeu));         % tworzenie losowych par ucz�cych i testuj�cych
xt = xtemp(:,:,1,idx(sizeu+1:end));
du = dtemp(idx(1:sizeu),:);
dt = dtemp(idx(sizeu+1:end),:);
siec_cnn_regr(xu,xt,du,dt)              % przej�cie do funkcji, w kt�rej stworzona zosta�a sie� neuronowa
end