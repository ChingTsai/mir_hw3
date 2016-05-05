clear;
[y,fs,bits,opt_ck] = wavread('audio/train/vio/vio_64.wav');
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

rm = W*H;
rY = rm.*cos(angl) + i*rm.*sin(angl);
visualizeSpec(rY);

fst = W(:,1)*H(1,:);
fst = fst.*cos(angl) + i*fst.*sin(angl);
visualizeSpec(fst);