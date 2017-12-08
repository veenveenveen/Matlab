function frq = mel2frq(mel)
%MEL2FRQ  Convert Mel frequency scale to Hertz FRQ=(MEL)


frq=700*(exp(mel/1127.01048)-1);
