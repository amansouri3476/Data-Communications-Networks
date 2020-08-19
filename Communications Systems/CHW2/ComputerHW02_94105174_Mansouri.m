%% Female Voice
close all
% Spectrogram
figure
[yf,fs] = audioread('FHello.wav');
spectrogram(yf);
title('Female Voice Spectrogram','color','r');
% Time Domain Diagram
figure
plot(1/fs:1/fs:length(yf)/fs,yf);
title('Time Domain Signal of Female Voice','color','r')
xlabel('Time','color','b');
ylabel('Amplitude','color','b');

% FFT
% Deriving Single-Sided Fourier Transform of The Signal
L = length(yf);
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(yf,NFFT)/L;
f = fs/2*linspace(0,1,NFFT/2+1);
figure
% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of y(t)','color','r')
xlabel('Frequency (Hz)','color','b')
ylabel('|Y(f)|','color','b')


%% Male Voice
close all

[ym,fs] = audioread('MHello.wav');
% Spectrogram
figure
spectrogram(ym);
title('Male Voice Spectrogram','color','r');
% Time Domain Diagram
figure
plot(1/fs:1/fs:length(ym)/fs,ym);
title('Time Domain Signal of Male Voice','color','r')
xlabel('Time','color','b');
ylabel('Amplitude','color','b');
% FFT
% Deriving Single-Sided Fourier Transform of The Signal
L = length(ym);
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(ym,NFFT)/L;
f = fs/2*linspace(0,1,NFFT/2+1);
figure
% Plot single-sided amplitude spectrum.
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of y(t)','color','r')
xlabel('Frequency (Hz)','color','b')
ylabel('|Y(f)|','color','b')

%% Test Voice
close all

[ytest,fs] = audioread('test.wav');
% Spectrogram
figure
spectrogram(ytest,window);
title('Test Voice Spectrogram','color','r');
% Time Domain Diagram
figure
plot(1/fs:1/fs:length(ytest)/fs,ytest);
title('Time Domain Signal of Test Voice','color','r')
xlabel('Time','color','b');
ylabel('Amplitude','color','b');

% FFT
% Deriving Single-Sided Fourier Transform of The Signal
L = length(ytest);
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(ytest,NFFT)/L;
f = fs/2*linspace(0,1,NFFT/2+1);
% Plot single-sided amplitude spectrum.
figure
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of y(t)','color','r')
xlabel('Frequency (Hz)','color','b')
ylabel('|Y(f)|','color','b')

%% Adjusting Parameters
% The reason for choosing these values is explained in the report

window = 10000;
figure
[ytest,fs] = audioread('test.wav');
spectrogram(ytest,window,5000,10000);
title('Test Voice Final Spectrogram','color','r');









