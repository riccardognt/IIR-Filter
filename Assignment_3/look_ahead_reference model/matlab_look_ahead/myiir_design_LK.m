function [bi_LK, ai_LK, bq_LK, aq_LK]=myiir_design_LK(N,nb)
%% function myiir_design(N,nb)
%% N is order of the filter
%% nb is the number of bits
%% bi,ai taps represented as integers
%% bq,aq quantized taps

close all;

f_cut_off = 2000; % 2kHz deve essere più piccola di F_sampling/2
f_sampling = 10000; % 10kHz

f_nyq = f_sampling/2; %% Nyquist frequenc
f0 = f_cut_off/f_nyq; %% Normalized cut-off frequency 
%la butter la accetta solo se normalizzata

[b,a]=butter(N, f0); %% get filter coefficients
%number of coefficients =N+1
%descending powers of z
[h1, w1]=freqz(b,a); %% %% get the transfer function of the designed filter
%Frequency response of digital filter
a_LK=[1,0,a(3)-a(2)*a(2),-a(2)*a(3)];
b_LK=[b(1),b(2)-a(2)*b(1),b(3)-a(2)*b(2),-a(2)*b(3)];
shift=0.5;
bi_LK=floor(b_LK*2^(nb-1)+shift); %% convert b coefficients into nb-bit integers

bq_LK=bi_LK/2^(nb-1); %% convert back b coefficients as nb-bit real values

ai_LK=floor(a_LK*2^(nb-1)+shift); %% convert a coefficients into nb-bit integers

aq_LK=ai_LK/2^(nb-1); %% convert back a coefficients as nb-bit real values

[h2, w2]=freqz(bq_LK,aq_LK); %% get the transfer function of the quantized filter

%% show the transfer functions
plot(w1/pi, 20*log10(abs(h1)));
hold on;
plot(w2/pi, 20*log10(abs(h2)),'r--');
grid on;
xlabel('Normalized frequency');
ylabel('dB');





