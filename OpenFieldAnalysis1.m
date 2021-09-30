%% Analysis

speedTime = (speed > 7.5); 
idx1 = 1; 
check = true;

for h = bin_size : bin_size : 360    
    thetaTime = (bin_theta == h); 
    intersect  = (speedTime & thetaTime); 
    
    % initialize indexing variables
    idx2 = 1;
    start0 = find(intersect == true, 1); 
    start1 = start0 + 1;
    counter = 0;
    
    while check ~= isempty(start0)
        for i=start1:length(intersect)
            if intersect(i) == true
                counter = counter + 1;
            else
                break;
            end    
        end
        if counter >= 4
            intersectTimes(idx1, idx2) = start0;
            if i == length(intersect) && intersect(i) == 1
                intersectTimes(idx1, idx2 +1) = i;
            else
                intersectTimes(idx1, idx2 +1) = i - 1;
            end
            idx2 = idx2 + 2;
        end
        start1 = i + 1;
        
    % update indexing variables        
        start0 = find(intersect(start1:length(intersect)) == 1, 1) + i;
        start1 = start0 + 1;
        counter = 0;   
    end   
    idx1 = idx1 + 1;
end

%% Plot

figure;
hold on
xlabel('X-position (cm)');
ylabel('Y-position (cm)');
xlim([-40 40]);
ylim([-40 40])

% Movie Plot
%{
for j=1:size(intersectTimes, 1)
    temp = unique(intersectTimes(j, :));
    temp = temp(temp > 0);
    for k=1:2:length(temp)
        scatter(centered_x(temp(k):temp(k+1)), centered_y(temp(k):temp(k+1)), 7, 'MarkerFaceColor', 'blue', 'MarkerEdgeColor', 'blue');
        pause(.08);
    end
end
%}


% Regular Plot
for j=1:size(intersectTimes, 1)
    temp = unique(intersectTimes(j, :)); 
    temp = temp(temp > 0);
         for k=1:2:length(temp)-1
             plot(centered_x(temp(k):temp(k+1)), centered_y(temp(k):temp(k+1)), 'Color', [0, 0.4470, 0.7410]);
         end
end




     



