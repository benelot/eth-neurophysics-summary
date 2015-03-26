

%Load file
[wav_data,sampleRate]=audioread('ZebraFinch.wav');


% Normalize to [-1 1];
wavform = (wav_data-min(wav_data))*2/(max(wav_data)-min(wav_data))-1;
% Control volume
%wavform = wavform * 0.00000000000001;
% Plot
figure(1); clf; 
h1=subplot(2,1,1); 
plot(wavform);
ylabel('Amplitude');

%play sound
%sound(wavform, sampleRate);

window_size = 512;
non_overlap = floor(0.75 * window_size);
NFFT = window_size;
% Get raw data
[raw_spec, freqs, time] = spectrogram(wavform, window_size, non_overlap, NFFT, sampleRate);
% Make it more volume-insensitive by looking at log-power
%spec = 10*log10(abs(raw_spec)+eps);
spec = log(abs(raw_spec)+0.1);
% Plot it
h2=subplot(2,1,2);
surf(time,freqs,spec,'EdgeColor','none');   

axis xy; axis tight; colormap(jet); view(0,90);
axis([0,5,500,3000]);
xlabel('Time [s]');
ylabel('Frequency (Hz)');