function Y = MfccProcess( xMfcc )
    Y=sum(xMfcc)/size(xMfcc,1);
    Y=Y';
end

