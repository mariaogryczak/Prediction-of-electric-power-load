%% Maria Ogryczak

%% Przetwarzanie sygna³u na obraz

%% Dane

% Odczytywanie danych historycznych z pliku xls z danych KSE (Ÿród³o - PSE (pse.pl))

Braw=[];
for r = 2007:2017
plikcsv = sprintf('%d.csv',r);
[num,txt,raw] = xlsread( plikcsv );
Braw = [Braw; raw(2:end,:)];
end

C = Braw(:,4);
S = sprintf('%s*', C{:});
P = sscanf(S, '%f*');   
maxP = max(P);
P = P./maxP;                          % znormalizowany wektor obci¹¿eñ

metoda = 1;                             % numer metody
numofdays = 7;                          % liczba dni wstecz branych do uczenia
N = 10;                                 % liczba falek, na które rozk³adany jest sygna³
falka = 'db16';

    if metoda == 1
        obraz_spectrogram(numofdays,P);
    elseif metoda == 2
        obraz_falki(numofdays,P,N,falka);
    elseif metoda == 3
        macierzA(numofdays,P);
    elseif metoda == 4
        macierzB(numofdays,P);
    elseif metoda == 5
        macierzAp(numofdays,P);
    elseif metoda == 6
        macierzBp(numofdays,P);
    elseif metoda == 7
        macierzC(numofdays,P);
    elseif metoda == 8  
        macierzD(numofdays,P);
    end

