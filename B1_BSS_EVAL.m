a = wavread('audio/validation/01_vio.wav');
b = wavread('audio/validation/01_cla.wav');
c = wavread('audio/validation/01_mix.wav');
n = randn(length(a),1);
%
SDR = zeros(10,2);

SDR(1,:) = bss_eval_sources([c';c']/2,[a';b']);
SDR(2,:) = bss_eval_sources([a';b'],[a';b']);
SDR(3,:) = bss_eval_sources([b';a'],[a';b']);
SDR(4,:) = bss_eval_sources([2*a';2*b'],[a';b']);
SDR(5,1) = bss_eval_sources((a+0.01*n)',a');
SDR(6,1) = bss_eval_sources((a+0.1*n)',a');
SDR(7,1) = bss_eval_sources((a+n)',a');
SDR(8,1) = bss_eval_sources((a+0.01*b)',a');
SDR(9,1) = bss_eval_sources((a+0.1*b)',a');
SDR(10,1) = bss_eval_sources((a+b)',a');
