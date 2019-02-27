function [falki] = rozklad_na_falki(sig, falka, N);
[C,L]=wavedec(sig,N,falka);
detale=[1:N];
for k=detale   
   up2=wrcoef('d',C,L,falka,k);      
   zwrot(k,:)=up2';
end
zwrot(k+1,:)=wrcoef('a',C,L,falka,N)';
falki = zwrot;