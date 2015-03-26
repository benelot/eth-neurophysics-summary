function [ loglik, x_mean ] = bootstrapParticleFilter( y, particleNumber, theta, is_hit )
%BOOTSTRAPPARTICLEFILTER estimates the hidden state sequence x and the
%loglikelihood for given parameters theta with the Bootstrap filter
%this implementation of the particle filter assumes Gaussian noise with
%covariances theta.R (output noise) and diagonal theta.Q (state noise)

% INPUT
%   y : measurement sequence (one dimensional)
%   particleNumber : number of particles to be used
%   theta : model parameters
%   x0 : initial particles (size = dimension of hidden state x particleNumber)

%OUTPUT
%   loglik : log likelihood 
%   x_mean : estimated hidden state sequence (wheigthed mean of particles)


% Initialize variables
T=length(y);
state_dim=size(theta.Q,1);
loglik=0;
xp = y(1)+sqrt(theta.R)*zeros(state_dim,particleNumber); % particles at current state 
% (initialized at y(1) might be bad for other systems)
weights = ones(1,particleNumber)/particleNumber; % initialize to 1/N
x_mean = zeros(state_dim,T); % mean hidden state
x_mean(:,1) = xp*weights';
% initialize noise for speed
state_noise = zeros(state_dim,particleNumber,T); % initialize noise for speed
for i = 1:state_dim
    state_noise(i,:,:) = sqrt(theta.Q(i,i))*randn(particleNumber,T);
end

for t = 2:T
    
    % propagate particles according to model equations for state transition
    xp = state_transition(t, xp, state_noise(:,:,t), theta, is_hit);
    
    % calculate the wheights (likelihood of y given xp)
    % weights = 
    
    % Compute marginalized loglikelihood
    loglik = loglik + log(mean(weights));
    
    % normalize weights
    weights = weights/sum(weights);
    
    % compute mean hidden state
    x_mean(:,t) = xp*weights';
    
    % Do resampling
    ind = sys_resampling(weights(:),particleNumber);
    xp = xp(:,ind);
    
    if t==500 || t==6500 
        figure(10),set(gcf,'color','w')
        subplot(2,1,1+(t==6500)),plot(weights)
        ylabel('weight'),xlabel('particle'), title(['time step: ',num2str(t)])
    end
    
end

end

function i = sys_resampling(q,N)
    % this function performs the resampling step where 
    % q : are the weights
    % N : number of particles = particleNumber
    % i : index of particles after resampling (new_particles are old_particles(i) )
    % example: i=[1 1 1 3 4 5 5 5]  (corresponds to a case where particle 1
    % and 5 were likely whereas particle 2 had a small wheight.
    % hint: use commands cumsum(q) and histc


end

function x  = state_transition(t, xp, noise, theta, is_hit)
       
A = [0 0;-theta.alpha*(is_hit(t-1)==1) theta.gamma];
x = A*xp + noise;

end

function y = observation_from_state(xp,noise)

y = ones(1,2)*xp + noise;

end