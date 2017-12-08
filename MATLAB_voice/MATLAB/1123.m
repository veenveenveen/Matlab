
[y, fs, nbits]=wavread('a.wav');
index1=7450;
frameSize=512;
index2=index1+frameSize-1;
segment=y(index1:index2);

subplot(2,1,1);
plot(y); grid on
title('a.wav');
set(gca, 'xlim', [0, length(y)]);
limit=axis;
line(index1*[1 1], limit(3:4), 'color', 'r');
line(index2*[1 1], limit(3:4), 'color', 'r');
subplot(2,1,2);
plot(segment, '.-'); grid on
set(gca, 'xlim', [1, index2-index1+1]);
point=[73, 472];
line(point, segment(point), 'marker', 'o', 'color', 'red');

periodCount=6;
fp=((point(2)-point(1))/periodCount)/fs;
ff=fs/((point(2)-point(1))/periodCount);
pitch=69+12*log2(ff/440);
fprintf('Fundamental period = %g second\n', fp);
fprintf('Fundamental frequency = %g Hertz\n', ff);
fprintf('Pitch = %g semitone\n', pitch);
