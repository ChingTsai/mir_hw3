
[y,fs,bits,opt_ck] = wavread('audio/train/cla/cla_64.wav');
idx=find(sum(y,2)==0);
y(idx,:)=[];
nfft = 2048;
h = 1024;
[Y, f, t] = stft(y,2048,h,nfft,fs);

m = abs(Y);
angl = angle(Y);

shape = size(Y);

inW = rand([shape(1),3]);
inH = rand(3 , shape(2));
[W,H] = nmf(m,inW,inH,0.00001,2,1000);

par.logComp = 100;
par.fAxis = f;

visualizeSpec([W, sum(m')'/100],par);
par.tAxis = t;


rm = W*H;
rY = rm.*cos(angl) + i*rm.*sin(angl);
visualizeSpec(rY,par);

fst = W(:,1)*H(1,:);
fst = fst.*cos(angl) + i*fst.*sin(angl);
visualizeSpec(fst,par);

snd = W(:,2)*H(2,:);
snd = snd.*cos(angl) + i*snd.*sin(angl);
visualizeSpec(snd,par);

trd = W(:,3)*H(3,:);
trd = trd.*cos(angl) + i*trd.*sin(angl);
visualizeSpec(trd,par);

fst =  istft(fst, h, nfft, fs);
figure;
spPitchCorr(spCorr(fst, fs, [],'plot'), fs)
snd =  istft(snd, h, nfft, fs);
figure;
spPitchCorr(spCorr(snd, fs, [],'plot'), fs)
trd =  istft(trd, h, nfft, fs);
figure;
spPitchCorr(spCorr(trd, fs, [],'plot'), fs)

rY =  istft(rY, h, nfft, fs);
spPitchCorr(spCorr(rY, fs, [],'plot'), fs)
