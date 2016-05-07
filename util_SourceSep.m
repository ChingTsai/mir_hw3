function [rv,rc] = util_SourceSep(source,Template)

nfft = 2048;
h = 1024;


[y,fs,bits,opt_ck] = wavread(source);
idx=find(sum(y,2)==0);
y(idx,:)=[];

[Y, f, t] = stft(y,2048,h,nfft,fs);

m = abs(Y);
angl = angle(Y);
shape = size(Y);
inW = Template;
inH = rand(255 , shape(2));
[W,H] = nmf(m,inW,inH,0.00001,20,500,2);
% sep violin
rm = W(:,1:135)*H(1:135,:);
rY = rm.*cos(angl) + i*rm.*sin(angl);

rY = istft(rY, h, nfft, fs);
rv = rY;
rm = W(:,136:end)*H(136:end,:);
rY = rm.*cos(angl) + i*rm.*sin(angl);

rY = istft(rY, h, nfft, fs);
rc = rY;


end