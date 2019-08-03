% Script TFA_Analysis_complex
% Author: D.R.Ohm
%
% Loads real-valued Bat data (or any other data) and generates TFA gram 
% using a STFT.
%  
%**************************************************************************
%**************************************************************************
clear all; %close all
[filename,pathname] = uigetfile('*.mat','Select data to load')
pathplusfile = [pathname filename];
load([filename])
whos

data = input(['Data vector/matrix name: ']);
[MM NN] = size(data);
if MM < NN          % Make data a column vector
    data = data';
else
end

Fs = input(['Input sample frequency: ']);
T = 1/Fs; N = length(data); 
fft_length = input(['Input FFT size (suggest 1024): ']);
disp('TFR Method = STFT (Classical Short-Time Fourier Transform)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% STFT TFA-gram 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('COMPUTE AND PLOT TIME-vs-FREQUENCY ANALYSIS OF EXAMPLE SIGNAL')
n_anal=input('What analysis window size (power of 2) in samples to use (suggest 38)? ');
n_step=input('What increment size in samples to center of next analysis window (suggest 1)? ');
n_specdisplay=fix((N-n_anal)/n_step);
gram=zeros(n_specdisplay,n_anal);  % pre-assign 2-D size of gram display
disp(['This choice will generate ',int2str(n_specdisplay),' displayed spectrogram lines.'])
gram=zeros(n_specdisplay,fft_length);  % pre-assign 2-D size of gram display
disp('A Hamming window will be used to suppress the sidelobe artifacts.')
window=hamming(n_anal);
n=1:n_anal;
for k=1:n_specdisplay
    gram(k,:)=fftshift(ifft( (window.*data(n)),fft_length))';
    n=n+n_step;
end
titletext = input(['Type title for TFA color gram: ']);
plot_Bat_color_gram_STFT(gram,data,Fs,n_anal,n_step,titletext)

