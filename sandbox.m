clear all
close all

k=1;
tot=5;
t=0:0.1:100;
G_k = 1/(sqrt(2*pi)*sqrt(tot))*exp(-(t-k).^2/(2*sqrt(tot)^2));
plot(t,G_k)

x = 0.5;
out = conv(G_k,x);
plot(t,G_k,t,out)
