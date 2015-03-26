%% simulate pitch shifting data 

% parameters
gamma = 0.99;
alpha = 0.6;
R = 10;
Q = [100 0 ; 0 0.2];

% transition matrices
H = [1 1];
A{1} = [0 0;0 gamma]; % A if last rendition was escape
A{2} = [0 0;-alpha gamma]; % A if last rendition was hit (white noise delivered)

% threshold
timestamps=1:10000;
N=length(timestamps);
thresh=zeros(1,N);
p_target=500; thr_step=5;
for t=1:6
    thresh(t*1000<=timestamps & timestamps<(t+1)*1000)=p_target+(t-1)*thr_step;
end
thresh=thresh-p_target;

% pitch simulation
y=zeros(1,N); % pitch output
x=zeros(2,N); % state
is_hit = zeros(1,N); % whether or not bird was punished
output_noise = sqrt(R)*randn(1,N);
state_noise = [sqrt(Q(1,1))*randn(1,N) ; sqrt(Q(2,2))*randn(1,N)];
meanSubtractedW = 0;

for t=2:N
    if y(t-1)<thresh(t-1)
        x(:,t) = A{2}*x(:,t-1)+state_noise(:,t);
        is_hit(t-1) = 1;
    else
        x(:,t) = A{1}*x(:,t-1)+state_noise(:,t);
        is_hit(t-1) = 0;
    end
    y(t) = H*x(:,t)+output_noise(:,t);
end

% plot pitch
figure(1);clf;set(gcf,'color','w')
plot(timestamps(y(1:end-1)>=thresh(1:end-1)+1),y(y(1:end-1)>=thresh(1:end-1)+1),'.');hold on;
plot(timestamps(y(1:end-1)<thresh(1:end-1)+1),y(y(1:end-1)<thresh(1:end-1)+1),'.','color',[0 0 200/255]);
plot(timestamps,x(2,:),'g')
plot(timestamps,thresh,'r','LineWidth',2.5);
box off;ylim([-40 70]);
xlabel('rendition');ylabel('mean subtracted pitch')



%% Kalman Filter to estimate state

% change alpha here
A{2} = [0 0;-alpha gamma]; % A if last rendition was hit (white noise delivered)

% initialize
x_est=zeros(2,N); % estimated state
P = zeros(2);

for t=2:N
    
    % Kalman Filter equations (use A{is_hit(t-1)+1} for A)
    


end

% plot pitch
figure(1);clf;set(gcf,'color','w')
plot(timestamps(y(1:end-1)>=thresh(1:end-1)+1),y(y(1:end-1)>=thresh(1:end-1)+1),'.');hold on;
plot(timestamps(y(1:end-1)<thresh(1:end-1)+1),y(y(1:end-1)<thresh(1:end-1)+1),'.','color',[0 0 200/255]);
plot(timestamps,x(2,:),'g')
plot(timestamps,x_est(2,:),'m')
plot(timestamps,thresh,'r','LineWidth',2.5);
box off;ylim([-40 70]);
xlabel('rendition');ylabel('mean subtracted pitch')


