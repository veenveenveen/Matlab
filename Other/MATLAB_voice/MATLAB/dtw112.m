[x,fs]=wavread('ang.wav');
m = 80;
n = 160;
fs=10000;
l = length(x);
nbFrame = floor((l - n) / m) + 1;
for i = 1:n
    for j = 1:nbFrame
        M(i, j) = x(((j - 1) * m) + i);
    end
end
h = hamming(n);
M2 = diag(h) * M;
for i = 1:nbFrame
    frame(:,i) = fft(M2(:, i));
end
t = n / 2;
tmax = l / fs;
p=20;
f0 = 700 / fs;
fn2 = floor(n/2);
lr = log(1 + 0.5/f0) / (p+1);
bl = n * (f0 * (exp([0 1 p p+1] * lr) - 1));
b1 = floor(bl(1)) + 1;
b2 = ceil(bl(2));
b3 = floor(bl(3));
b4 = min(fn2, ceil(bl(4))) - 1;
pf = log(1 + (b1:b4)/n/f0) / lr;
fp = floor(pf);
pm = pf - fp;
r = [fp(b2:b4) 1+fp(1:b3)];
c = [b2:b4 1:b3] + 1;
v = 2 * [1-pm(b2:b4) pm(1:b3)];
m1=sparse(r, c, v, p, 1+fn2);
n2 = 1 + floor(n / 2);
z = m1 * abs(frame(1:n2, :)).^2;
ref = dct(log(z));

[x,fs]=wavread('a.wav');
m = 80;
n = 160;
fs=10000;
l = length(x);
nbFrame = floor((l - n) / m) + 1;
for i = 1:n
    for j = 1:nbFrame
        M(i, j) = x(((j - 1) * m) + i);
    end
end
h = hamming(n);
M2 = diag(h) * M;
for i = 1:nbFrame
    frame(:,i) = fft(M2(:, i));
end
t = n / 2;
tmax = l / fs;
p=20;
f0 = 700 / fs;
fn2 = floor(n/2);
lr = log(1 + 0.5/f0) / (p+1);
bl = n * (f0 * (exp([0 1 p p+1] * lr) - 1));
b1 = floor(bl(1)) + 1;
b2 = ceil(bl(2));
b3 = floor(bl(3));
b4 = min(fn2, ceil(bl(4))) - 1;
pf = log(1 + (b1:b4)/n/f0) / lr;
fp = floor(pf);
pm = pf - fp;
r = [fp(b2:b4) 1+fp(1:b3)];
c = [b2:b4 1:b3] + 1;
v = 2 * [1-pm(b2:b4) pm(1:b3)];
m1=sparse(r, c, v, p, 1+fn2);
n2 = 1 + floor(n / 2);
z = m1 * abs(frame(1:n2, :)).^2;
test = dct(log(z));

t=test;
r=ref;
n = size(t,1);
m = size(r,1);

% Ö¡Æ¥Åä¾àÀë¾ØÕó
d = zeros(n,m);

for i = 1:n
for j = 1:m
	d(i,j) = sum((t(i,:)-r(j,:)).^2);
end
end

% ÀÛ»ı¾àÀë¾ØÕó
D =  ones(n,m) * realmax;
D(1,1) = d(1,1);

% ¶¯Ì¬¹æ»®
for i = 2:n
for j = 1:m
	D1 = D(i-1,j);

	if j>1
		D2 = D(i-1,j-1);
    else
        D2 = realmax;
	end

	if j>2
		D3 = D(i-1,j-2);
    else
        D3 = realmax;
	end

	D(i,j) = d(i,j) + min([D1,D2,D3]);
end
end

dist = D(n,m);
