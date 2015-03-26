clc; clear;
n=17; %states (Students in experiment done during the lecture)
p=ones(n)/n; % policy 
T=5000; % steps 
g=0.98; % reward discount parameter (gamma)
l=.95; % lambda return (only used for sarsa(1) )
s=1; % initial state
alpha=0.1; % learning rate
rl=13; % reward latency -> play around with that
rew_state=11;  % rewarded state

verbose=1; % "see more": plot more intermediate steps (makes it slower)

if verbose==1
    N=1;
else
    N=10;
end
for i=1:N
    Q=zeros(n,2); % action value function Q(s,h) zero initially
                  % Q(state,1)=action value function for action +1
                  % Q(state,2)=action value function for action -1
    e=zeros(n,2); % eligibility used for sarsa(1)
    ss=zeros(1,T); % state trajectory
    
    rs=zeros(1,T+rl);  % reward trajectory
    
    figure(1);clf;
    hf2=figure(2);clf; gca2=axes;hp2=plot(0,0,'erasemode','xor');hold on;hp2b=plot([1 2],rew_state*[1 1],'r','erasemode','xor'); set(gca2,'xlim',[0 1],'ylim',[0 n]);
    figure(3);clf;
    gca1=axes;hp3=plot(0,0,'erasemode','xor'); title('Reward trajectory');
    set(gca1,'xlim',[0 1],'ylim',[0 1.2]);
    
    % initial values
    a=1; % action {+1, -1}
    h=2; % action index in Q(s,h) with h={1,2}
    
    for t=1:T
        s_old=s; 
        h_old=h; 
        a_old=a;
        
        s=min(n,max(1,s+a_old));
        
        rs(t+rl)=(s==rew_state);  % distribute reward
        
        is1=rand(1)<exp(Q(s,1))/(eps+exp(Q(s,1))+exp(Q(s,2))); % random exploration (greedy)
        
        if is1
            a=1; h=1;
        else
            a=-1; h=2;
        end
        
        % Sarsa(0)
        display([s_old,a_old,t+rl,s,a]);
        display(rs(t+rl));
       %Q(s_old,h_old)=Q(s_old,h_old)+alpha*(rs(t+rl)+g*Q(s,h)-Q(s_old,h_old));
       %Q(s_old,h_old)=Q(s_old,h_old)+alpha*(rs(t+rl));
       Q(s_old,h_old)=Q(s_old,h_old)+alpha*(-Q(s_old,h_old));
       display(t);
        
        
        ss(t)=s;
        if verbose && rem(t,12)==1
            figure(1);hold off; plot(1:n,Q(:,1),'k');hold on; plot(1:n,Q(:,2),'r'); title('Action-value functions');legend('+1','-1');
            set(hp2,'ydata',ss(1:t),'xdata',1:t);set(hp2b,'xdata',[1 t]); set(gca2,'xlim',[0 t]);%xlim([0 t]);title('State trajectory');
            set(hp3,'xdata',1:t,'ydata',rs(1:t));  set(gca1,'xlim',[0 t]);drawnow
            pause(0.001);
        end
    display('i:');
    display(i);
    end
    ss=ss(1:t); rs=rs(1:t);
    figure(1); clf; plot(1:n,Q(:,1),'k');hold on; plot(1:n,Q(:,2),'r'); title('Action-value functions');
    legend('+1','-1');
    figure(2);clf;plot(ss);hold on; plot([1 t],rew_state*[1 1],'r');ylim([0 n]);title('State trajectory');
    figure(3);clf;patch([1:length(rs) length(rs)],[rs 0],[0 0 0]); ylim([0 1.2]);title('Reward trajectory');
    
    pause(.3);
end
