%% 

% Generate random spiking data
n = 100;
m = length(t);
S = logical(randi([0 1], n,m));

% Generate Position vs Occupancy Time (s)

pbin_size = 5;
EX = -40:pbin_size:40;
EY = -40:pbin_size:40;

% Generate Red X Positions of interest
redTrajTemp = trajR(1, :, 1);

for s=1:length(redTrajTemp)
        logicalR(s) = ~isempty(redTrajTemp{1, s});
end 

redTrajTemp = redTrajTemp(logicalR);

counter = 1;
for h=1:2:length(redTrajTemp)-1
    redTrajTempX{1, counter} = redTrajTemp{1,h}(:);
    counter = counter +1;
end

% initialize redTrajXCOmp
[nrows,~] = cellfun(@size,redTrajTempX);
n = size(redTrajTempX, 2);
m = max(nrows);
redTrajXComp = zeros(n,m);

for p=1:length(redTrajTempX)
    redTrajX = cell2mat(redTrajTempX(1, p));
    redTrajXComp(p, 1:length(redTrajX)) = redTrajX(:);
end
redTrajXCompL = redTrajXComp(redTrajXComp > 0); % X Position Data

% find times when rat was in specified position
for i=1:length(redTrajXCompL) 
    T(i) = find(round(centered_x, 4) == round(redTrajXCompL(i), 4));
end
T = sort(T);

% compute spike counts
counter = 1; 
for i=1:length(T)
    if S(1, T(1,i)) == 1
        spikes(i) = 1;
    else
        spikes(i) = 0;
    end
end
t(2, :) 
[~, spikeBin] = histc(S(1,:), T);



[~, spikeBin] = histc(S(1,:), T);
spikePos = P(spikeBin);
[spikePosSum, ~] = histc(spikePos, EX);
figure;
set(gcf,'name','HW 6 Problem 1b','numbertitle','off');
plot(EX, spikePosSum);
xlabel('Position (cm)');
ylabel('Spike Count');

%%
T = t;
P = centered_x;
E = -40:5:40;
m = 40;
n = length(T);
SRand = randi([0 1], m,n); 

% Compute and plot occupancy time
[posCount, ~] = histc(P, E);
occTime = posCount.*dt; 
figure;
plot(E, occTime);
xlabel('X Position (cm)');
ylabel('Occupancy Time (s)');

for a=1:size(SRand, 1)
    temp = find(SRand(a,:) == 1);
    S(a, 1) = {temp};
end

figure;
for b=1:size(S,1)
    spikePos = P(cell2mat(S(b,1)));
    [spikePosSum, ~] = histc(spikePos, E);
    plot(E, spikePosSum);
    hold on
    xlabel('X Position (cm)');
    ylabel('Spike Count');
end

figure;
for b=1:size(S,1)
    spikePos = P(cell2mat(S(b,1)));
    [spikePosSum, ~] = histc(spikePos, E);
    firingrate = spikePosSum ./ occTime;
    plot(E, firingrate);
    hold on
    xlabel('X Position (cm)');
    ylabel('Firing rate (Hz)');
end










