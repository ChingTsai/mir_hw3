clear;
PATH_DATA_SET='.\audio\train\';
PATH_VAL_DATA = '.\audio\validation';
[listOfvio] = listfile(fullfile(PATH_DATA_SET,'vio'));
[listOfcla] = listfile(fullfile(PATH_DATA_SET,'cla'));
[listOfval] =  listfile(fullfile(PATH_VAL_DATA,''));
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
%%
for j = 0 :0



[rv,rc] = util_SourceSep(listOfval{j*3+2},Template);
%vio
[y,fs,bits,opt_ck] = wavread(listOfval{j*3+3});
idx=find(sum(y,2)==0);
y(idx,:)=[];
figure;
spCorr(y, fs, [],'plot');
figure;
spCorr(rv, fs, [],'plot');
min_length = min(length(y),length(rv));
[SDR,SIR,SAR,perm] = bss_eval_sources(rv(1:min_length),y(1:min_length)' )
audiowrite(['0' int2str(j+1) '_vio_est.wav'],rv,fs);
%cla
[y,fs,bits,opt_ck] = wavread(listOfval{j*3+1});
idx=find(sum(y,2)==0);
y(idx,:)=[];
figure;
spCorr(y, fs, [],'plot');
figure;
spCorr(rc, fs, [],'plot');
min_length = min(length(y),length(rv));
[SDR,SIR,SAR,perm] = bss_eval_sources(rc(1:min_length),y(1:min_length)') 
audiowrite(['0' int2str(j+1) '_vio_est.wav'],rc,fs);

end
