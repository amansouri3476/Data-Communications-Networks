%% Problem 6
close all

t=0:.00000001:.0005;
message_signal=sin(2*pi*10*1000*t);
carrier=sin(2*pi*4*10^6*t);
for u=0.6:.2:1 % different values of modulation index
%u=0.6;
att=.01; % attenuation 

s_t=(1+u*message_signal).*carrier;

% signal Passed Through Channel
s_in=s_t*att;%20db attenuation

v_snr=30;

snr_in=3:1:30; % SNR Steps
snr_out=snr_in;
i=1;
for v_snr=snr_in

% Adding AWGN to the signal with nonzero power
s_det=awgn(s_in,v_snr,'measured');


s_out=(envelope(s_det)-mean(envelope(s_det)))/att/u;

snr_out(i)=snr(message_signal,s_out-message_signal);
i=i+1;

end


% figure(1)
% plot(t,s_out-s)
figure(1)
hold on
plot(snr_in,snr_out)
end

legend('mu=0.6','mu=0.8','mu=1.0')
xlabel('SNR_{in}')
ylabel('SNR_{out}')
%% Problem 7

close all
dt=0.000000005;
t=0:dt:.0005;
s=sin(2*pi*10*1000*t); % message signal
s_i=cos(2*pi*10*1000*t);


%c=sin(2*pi*4*10^6*t);
b=300;%beta
for b=100:100:400
att=.01;% attenuation

s_t=cos(2*pi*4*10^6*t-b*s_i);% carrier signal


s_in=s_t*att;%20db attenuation

v_snr=20;
snr_in=3:1:30;
snr_out=snr_in;
i=1;
for v_snr=snr_in
% Adding AWGN to the signal    
s_det=awgn(s_in,v_snr,'measured');

% Differentiating
s_mid=diff(s_det);
% Envelope Detection
s_out=envelope(s_mid)/att/b/(2*pi*10*1000*dt);
% DC Block
s_out=s_out-mean(s_out);

snr_out(i)=snr(s(1:end-1),s_out-s(1:end-1));
i=i+1;

end


% figure(1)
% plot(t(1:end-1),s_out,t(1:end-1),s(1:end-1))
figure(1)
hold on
plot(snr_in,snr_out)
end
legend('beta=100','beta=200','beta=300','beta=400')
xlabel('SNR_{in}')
ylabel('SNR_{out}')

%% Part D & E
% Part D
v_snr=15;
s_det=awgn(s_in,v_snr,'measured');


s_mid=diff(s_det);

s_out=envelope(s_mid)/att/b/(2*pi*10*1000*dt);
s_out=s_out-mean(s_out);

figure(2)
plot(abs(fftshift(fft(s_out))).^2)


m = length(s_out);          % Window length
n = pow2(nextpow2(m));  % Transform length
y = fft(s_out,n);           % DFT
f = (0:n-1)*(1/n/dt);     % Frequency range
power = y.*conj(y)/n;   % Power of the DFT
figure(3);
plot(f,power)
xlabel('Frequency (Hz)')
ylabel('Power')
title('{\bf Periodogram}')
y0 = fftshift(y);          % Rearrange y values
f0 = (-n/2:n/2-1)*(1/n/dt);  % 0-centered frequency range
power0 = y0.*conj(y0)/n;   % 0-centered power
figure(4);
plot(f0,power0)
xlabel('Frequency (Hz)')
ylabel('Power')
title('{\bf 0-Centered Periodogram}')
% Part E
v_snr=5;
s_det=awgn(s_in,v_snr,'measured');


s_mid=diff(s_det);

s_out=envelope(s_mid)/att/b/(2*pi*10*1000*dt);
s_out=s_out-mean(s_out);

figure(5)
plot(abs(fftshift(fft(s_out))).^2)

m = length(s_out);          % Window length
n = pow2(nextpow2(m));  % Transform length
y = fft(s_out,n);           % DFT
f = (0:n-1)*(1/n/dt);     % Frequency range
power = y.*conj(y)/n;   % Power of the DFT
figure(6);
plot(f,power)
xlabel('Frequency (Hz)')
ylabel('Power')
title('{\bf Periodogram}')
y0 = fftshift(y);          % Rearrange y values
f0 = (-n/2:n/2-1)*(1/n/dt);  % 0-centered frequency range
power0 = y0.*conj(y0)/n;   % 0-centered power
figure(7);
plot(f0,power0)
xlabel('Frequency (Hz)')
ylabel('Power')
title('{\bf 0-Centered Periodogram}')
