clear all
close all

k=10;
t=1:4*k+1;
G_k = 1/(sqrt(2*pi)*sqrt(k))*exp(-(t-(2*k+1)).^2/(2*sqrt(k)^2));
plot(t,G_k)

%x = randn(1,2*k+1);
x = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1];
out = conv(x,G_k,'same');
subplot(3,1,1)
stem(t,G_k)
subplot(3,1,2)
stem(x)
subplot(3,1,3)
stem(out)


