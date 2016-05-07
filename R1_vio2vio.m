clear;
PATH_DATA_SET='.\audio\train\';
[listOfvio] = listfile(fullfile(PATH_DATA_SET,'vio'));
[listOfcla] = listfile(fullfile(PATH_DATA_SET,'cla'));
listOfFile =[listOfvio,listOfcla];
%%
Template = [];

nfft = 2048;
h = 1024;
par.logComp = 100;


for j = 1 : 85
[y,fs,bits,opt_ck] = wavread(listOfFile{j});
idx=find(sum(y,2)==0);
y(idx,:)=[];

[Y, f, t] = stft(y,2048,h,nfft,fs);

m = abs(Y);
angl = angle(Y);

shape = size(Y);

inW = rand([shape(1),3]);
inH = rand(3 , shape(2));
[W,H] = nmf(m,inW,inH,0.00001,2,500,0);

Template = [Template,W];

end

dicOfvio = Template(:,1:135);
dicOfcla = Template(:,135:end);
%{
par.logComp = 100;
par.fAxis = f;
par.tAxis = 55:99;
visualizeSpec(dicOfvio,par);
par.tAxis = 50:89;
visualizeSpec(dicOfcla,par);
%}
%% vio->vio
[y,fs,bits,opt_ck] = wavread('./audio/validation/01_vio.wav');
idx=find(sum(y,2)==0);
y(idx,:)=[];

[Y, f, t] = stft(y,2048,h,nfft,fs);

m = abs(Y);
angl = angle(Y);
shape = size(Y);

inW = dicOfvio;
inH = rand(135 , shape(2));
[W,H] = nmf(m,inW,inH,0.00001,2,500,2);

rm = W*H;
rY = rm.*cos(angl) + i*rm.*sin(angl);
visualizeSpec(rY,par);
rY = istft(rY, h, nfft, fs);
audiowrite('re_01_vio.wav',rY,fs);

%% vio->cla

[y,fs,bits,opt_ck] = wavread('./audio/validation/01_cla.wav');
idx=find(sum(y,2)==0);
y(idx,:)=[];

[Y, f, t] = stft(y,2048,h,nfft,fs);

m = abs(Y);
angl = angle(Y);
shape = size(Y);

inW = dicOfvio;
inH = rand(135 , shape(2));
[W,H] = nmf(m,inW,inH,0.00001,20,500,2);
visualizeSpec(H,par);


rm = W*H;
rY = rm.*cos(angl) + i*rm.*sin(angl);
visualizeSpec(rY,par);
rY = istft(rY, h, nfft, fs);
audiowrite('re_01_cla.wav',rY,fs);


