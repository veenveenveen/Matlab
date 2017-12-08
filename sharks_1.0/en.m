function e=en(vec)



% calculates energy of the signal

e=sum(vec.*conj(vec))/length(vec);