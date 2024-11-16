%% BP is used to adjust the synaptic weights of the neural network
% The input to the neural network does not matter and has a constant value of +1.  
% The outputs determine the amplitude of the step input at a given point in time.

% X - input vector

% W1, W2, W3 - matrices of synaptic weights
% b1, b2, b3 - vectors of biases
% v1, v2, v3 - induced local fields
% y1, y2, y3 - outputs of neural network layers 

% fi(x) - activation function
%% initialization
clear;
createW; % create transfer function for Simulink-model

X=1;
Nout=60; % number of neurons in the output layer
layers = [8 16 Nout];

% initial weights are generated
% matrix sizes are defined at realization of a direct pass
W1=0.3*rand(layers(1),length(X))-0.15;
b1=zeros(layers(1),1);
v1=W1*X+b1;

W2=0.3*rand(layers(2),length(v1))-0.15;
b2=zeros(layers(2),1);
v2=W2*v1+b2;

W3=0.3*rand(layers(3),length(v2))-0.15;
b3=zeros(layers(3),1);
v3=W3*v2+b3;


%% data preparation
load('DataBoiler.mat'); % load real-world process data

% The output data is the response taken from a real object - the change in metal temperature.
% When working with time, we use three variables:	
% - moments of input influence switching: tu,  
% - moments of real data capture: td,  
% - moments of output value capture from the Simulink model: tout (generated during simulation). 

td=Data(:,1);
d= Data(:,3);
tu=linspace(0,td(end),Nout+1);
u=zeros(size(tu));


%% Hyperparameters of trainig algorithm
epochNum=80;
etta=0.002;
uStep=td(end)/Nout; % time interval between the reference points of the vector of control actions

% uStep is used as the unit of measurement for setting parameters:
tAfterEffectMax=10; % maximum duration of aftereffect of the control action
T0Max=12;           % maximum value of attenuation time 

tStepMax=4;         % maximum step by moments of real data capture when forming the error vector

%% Procedure for recovering an unknown input signal by training a neural network
hw=figure('Color','w'); % auxiliary variable to control plotting

for i=1:epochNum
    % initialization of training algorithm parameters for i-th epoch
    tAfterEffect=randi([tAfterEffectMax/5 tAfterEffectMax]); 
    T0=randi([1 T0Max]);
    tStep=randi([1 tStepMax]);

    % Control action generation
    % 1) Forward pass of the neural network
    v1=W1*X+b1;
    y1=tanh(v1);
    v2=W2*y1+b2;
    y2=tanh(v2);
    v3=W3*y2+b3;
    y3=v3;

    % Control is set in the form of steps (zero-order extrapolator)
    u=[y3' y3(end)];
    
    % 2) Model simulation with generated control
    sim('model.slx');
    y=interp1(tout,simout,td);

    % 3) Plotting
    plot(td, Data(:,2),'r', 'Linewidth',1);
    hold on
    plot(td,d,'m', 'Linewidth',2);
    plot(td,y,'b', 'Linewidth',1);
    stairs(tu,u,'k', 'Linewidth',1);
    hold off
    title(sprintf('Epoch %d of %d',i,epochNum));
    legend('Q_2^*(t)','Q_{cm}^*(t)','Q(0,t)','\DeltaQ(t)','Location','East');  
    pause(0.001);
    
    % 4) Training
    for j=1:tStep:length(td) % j - current moment of the real data moments
        % 4.1) Error vector calculation
        Ewindow= d(j:min(j+tAfterEffect-1, length(td))) - ...
                 y(j:min(j+tAfterEffect-1, length(td)));
        [val ind]=max(abs(Ewindow));
        E=Ewindow(ind);
        e=zeros(layers(3),1);
        h=floor(td(j)/uStep); % how many reference points of the control actions remained in the past relative to the j-th moment       
        for k=h:-1:1
            e(k)=E*exp( -(td(j)-(k-1)*uStep)/(T0*uStep));
        end
      
        % 4.2) Backpropagation
        d3=1 * e;
        d2=(1-tanh(v2).^2) .* (W3'*d3);
        d1=(1-tanh(v1).^2) .* (W2'*d2);

        dW=(repmat(d3,1,length(y2)).*repmat(y2',length(d3),1));
        W3=W3+etta*dW;
        b3=b3+etta*d3;

        dW=(repmat(d2,1,length(y1)).*repmat(y1',length(d2),1));
        W2=W2+etta*dW;
        b2=b2+etta*d2;

        dW=(repmat(d1,1,length(X)).*repmat(X',length(d1),1));
        W1=W1+etta*dW;
        b1=b1+etta*d1;
    end
end

msgbox('Operation Completed');
