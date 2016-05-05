clear;
[y,fs,bits,opt_ck] = wavread('audio/train/vio/vio_64.wav');
nfft = 1024;
h = 512;
[stft, f, t] = stft(y,1024,h,nfft,fs);
S = abs(stft);
f_h =  length(stft(:,1));
for i =1 : f_h
if f(i)>1200
    break
end
end

lz = zeros(i-1,length(stft(1,:)));
S_hp = [lz;stft(i:end,:)];
[x, t] = istft(S_hp, h, nfft, fs);
audiowrite('vio_64_hp.wav',x,fs);
hz = zeros(f_h - i +1,length(stft(1,:)));
S_lp = [stft(1:i-1,:);hz];
[x, t] = istft(S_lp, h, nfft, fs);
audiowrite('vio_64_lp.wav',x,fs);

