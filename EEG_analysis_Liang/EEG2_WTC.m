t = linspace(0,1,1024);
x = -sin(8*pi*t) + 0.4*randn(1,1024);
x = x/max(abs(x));
y = wnoise( 'doppler' ,10);
% wcoh = wcoherence(x,y);

R = corrcoef(x,y)
R(1,2)
cxy = mscohere(x,y)
mean(cxy)
