lambda=78; % heat transfer coefficient
L=0.112;   % wall thickness
ro=7834;   % specific gravity of wall material
c=469;     % specific heat capacity

alfa1=0.01; % heat transfer coefficient at x
a=lambda/c/ro;

N=20; % number of terms in the orthonormal basis expansion, including n=0

NU=2;    % number of inputs 
x=[0 L]; % temperature monitoring points
NY=length(x);  % number of outputs 

s = tf('s');
W = a/L/s * tf(ones(NY,NU));

for n=1:N-1
    for j=1:NY
        W(j,1)=W(j,1) + ...
            2*a/L*cos(n*pi*x(j)/L) * cos(0) / (s+a*(n*pi/L)^2);
        W(j,2)=W(j,2) + ...
            2*a/L*cos(n*pi*x(j)/L) * cos(n*pi) / (s+a*(n*pi/L)^2);
    end
end        
        


