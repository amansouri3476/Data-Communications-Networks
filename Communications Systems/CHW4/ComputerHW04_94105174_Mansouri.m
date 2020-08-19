%% part 2
close all
clc
dt = 1e-9;
t = dt : dt : 1e-2;
f_c = 120e6;
f1 = 2e3;
f2 = 5e3;
beta_1 = 15;
beta_2 = 6;
x_c = cos(2*pi*f_c.*t + beta_1*sin(2*pi*f1.*t)+beta_2*sin(2*pi*f2.*t));
fs = dt^-1;
m = length(x_c);          % Window length
n = pow2(nextpow2(m));  % Transform length
y = fft(x_c,n);           % DFT
f = (0:n-1)*(fs/n);     % Frequency range
y0 = fftshift(y);          % Rearrange y values
f0 = (-n/2:n/2-1)*(fs/n);  % 0-centered frequency range
power0 = y0.*conj(y0)/n;   % 0-centered power
figure();
plot(f0,power0)
xlabel('Frequency (Hz)')
ylabel('Power')
title('{\bf 0-Centered Periodogram}')
i = find(power0>0.01*max(power0));
j = max(i);
Bandwidth = 2*(f0(j)-1.2e8);
display(Bandwidth);
%% part 3
close all
clc
dt = 1e-9;
t = dt : dt : 1e-2;
f_c = 120e6;
f1 = 3e3;
f2 = 5e3;
beta_1 = 10;
beta_2 = 6;
x_c = cos(2*pi*f_c.*t + beta_1*sin(2*pi*f1.*t)+beta_2*sin(2*pi*f2.*t));
fs = dt^-1;
m = length(x_c);          % Window length
n = pow2(nextpow2(m));  % Transform length
y = fft(x_c,n);           % DFT
f = (0:n-1)*(fs/n);     % Frequency range
y0 = fftshift(y);          % Rearrange y values
f0 = (-n/2:n/2-1)*(fs/n);  % 0-centered frequency range
power0 = y0.*conj(y0)/n;   % 0-centered power
figure();
plot(f0,power0)
hold on
a = zeros(1,length(f0));
a(1,:) = 0.01*max(power0);
plot(f0,a);
xlabel('Frequency (Hz)')
ylabel('Power')
title('{\bf 0-Centered Periodogram}')
i = find(power0>0.01*max(power0));
j = max(i);
Bandwidth = 2*(f0(j)-1.2e8);
display(Bandwidth);
%% part 4
close all
clc
dt = 1e-9;
t = dt : dt : 1e-2;
f_c = 120e6;
f1 = 10e3;
f2 = 5e3;
beta_1 = 3;
beta_2 = 6;
x_c = cos(2*pi*f_c.*t + beta_1*sin(2*pi*f1.*t)+beta_2*sin(2*pi*f2.*t));
fs = dt^-1;
m = length(x_c);          % Window length
n = pow2(nextpow2(m));  % Transform length
y = fft(x_c,n);           % DFT
f = (0:n-1)*(fs/n);     % Frequency range
y0 = fftshift(y);          % Rearrange y values
f0 = (-n/2:n/2-1)*(fs/n);  % 0-centered frequency range
power0 = y0.*conj(y0)/n;   % 0-centered power
figure();
plot(f0,power0)
hold on
a = zeros(1,length(f0));
a(1,:) = 0.01*max(power0);
plot(f0,a);
xlabel('Frequency (Hz)')
ylabel('Power')
title('{\bf 0-Centered Periodogram}')
i = find(power0>0.01*max(power0));
j = max(i);
Bandwidth = 2*(f0(j)-1.2e8);
display(Bandwidth);