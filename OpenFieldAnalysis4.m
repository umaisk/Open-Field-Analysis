%% 
% Construct Data Cube 1 (red)
for i=1:size(intersectTimes, 1)/2 % rows 1-6 of intersectTimes
    temp = unique(intersectTimes(i, :)); 
    temp = temp(temp > 0);

    for j=1:2:length(temp)-1
        dir1cube{:,j,i} = centered_x(temp(j):temp(j+1));
        dir1cube{:, j+1, i} = centered_y(temp(j):temp(j+1));  
    end    
end


% Construct Data Cube 2 (black)
counter = 1;
for i=((size(intersectTimes, 1)/2)+1):size(intersectTimes, 1) % rows 7-12 of intersectTimes
    temp = unique(intersectTimes(i, :)); 
    temp = temp(temp > 0);

    for j=1:2:length(temp)-1    
        dir2cube{:,j,counter} = centered_x(temp(j):temp(j+1));
        dir2cube{:, j+1, counter} = centered_y(temp(j):temp(j+1));
    end
    counter = counter + 1;

end

% Construct Pairwise Distance Cube
% comparing across all theta pairs
for i=1:size(dir1cube, 3)
    ct1 = 1;
    for j=1:2:size(dir1cube, 2)-1
        temp1 = dir1cube{:,j, i}; % assuming (red) column array
        temp2 = dir1cube{:,j+1,i};
        temp3 = [temp1, temp2];
        meanDisCube(1,ct1,i) = {temp3};    
        
        % comparing two (x,y) red columns against all pairs of black columns (old code below)
        %{
        ct2 = 1; 
        for k=1:2:size(dir2cube, 2)-1
            temp4 = dir2cube{:,k, i}; % assuming (black) column array
            temp5 = dir2cube{:,k+1,i};
            temp6 = [temp4, temp5];
            
            if ~isempty(temp3) && ~isempty(temp6) 
                disMatrix = pdist2(temp3, temp6); % distance result from comparing two (x,y) red columns against one pair of black columns
                meanDisCube(ct2,ct1,i) = mean(disMatrix(:));        
            end
            ct2 = ct2 + 1;
        end
        %} 
        ct2 = 2;
        for k=1:2:size(dir2cube, 2)-1
            temp4 = dir2cube{:,k, i}; % assuming (black) column array
            temp5 = dir2cube{:,k+1,i};
            temp6 = [temp4, temp5];
            
            if ~isempty(temp3) && ~isempty(temp6) 
                disMatrix = pdist2(temp3, temp6); % distance result from comparing two (x,y) red columns against one pair of black columns
                meanDisCube(ct2,ct1,i) = {mean(disMatrix(:))};
                meanDisCube(ct2+1,ct1,i) = {temp6};
            end
            
        ct2 = ct2 + 2;    
        end
    ct1 = ct1+1;     
    end    
end


%% Plot histograms 

figure;
sgtitle('\color{blue}Mean Pairwise Distances')
hold on

for a=1:size(meanDisCube, 3)
    flatMeanDisCube = meanDisCube(:, :, a);

    counter = 1;
    for b=1:length(flatMeanDisCube)
        chk1 = size(flatMeanDisCube{b});
        if sum(chk1) == 2
            extract(counter, 1) = flatMeanDisCube{b};
        end
    counter = counter +1;    
    end

    extract = extract(extract > 0);
    meanDisCubeMatrix(a, :) = {extract};
end


for c=1:3   
    
    subplot(3,1,c);
    temp = cell2mat(meanDisCubeMatrix(1, :));  
    histogram(temp, 30, 'EdgeColor', [0, 0.4470, 0.7410], 'FaceColor', [0, 0.4470, 0.7410]);

    if c== 1
         title('\color{red}0° - 30° \color{black},  180° - 210°')
    elseif c == 2
        title('\color{red}30° - 60° \color{black},  210° - 240°')
        ylabel('Frequency');
    elseif c == 3
        title('\color{red}60° - 90° \color{black},  240° - 270°')
        xlabel('Distance');
    end
end

figure;
sgtitle('\color{blue}Mean Pairwise Distances')
hold on
counter = 1;

for c=4:6   
    
    subplot(3,1,counter);
    temp = cell2mat(meanDisCubeMatrix(1, :));  
    histogram(temp, 30, 'EdgeColor', [0, 0.4470, 0.7410], 'FaceColor', [0, 0.4470, 0.7410]);

    if c == 4
        title('\color{red}90° - 120° \color{black},  270° - 300°') 
    elseif c == 5
        title('\color{red}120° - 150° \color{black},  300° - 330°')
        ylabel('Frequency');
    elseif c == 6
        title('\color{red}150° - 180° \color{black},  330° - 360°')
        xlabel('Distance');
    end
    counter = counter + 1;
end


%}
%% Plot Trajectories
%{
% First 3 Plots
figure;
sgtitle('\color{blue}Trajectories')

for j=1:size(dir1cube, 3)/2
    subplot(3,1,j);

    if j == 1
        title('\color{red}0° - 30° \color{black},  180° - 210°')
    elseif j == 2
        title('\color{red}30° - 60° \color{black},  210° - 240°')
        ylabel('Y-position (cm)');
    elseif j == 3
        title('\color{red}60° - 90° \color{black},  240° - 270°')
        xlabel('X-position (cm)');
    end
    xlim([-40 40]);
    ylim([-40 40])
    hold on 
    
    for k=1:2:size(dir1cube, 2)
        temp1 = dir1cube(:, :, j);
        temp1 = temp1(k:k+1);
        temp1 = cell2mat(temp1);

        if ~isempty(temp1)
            plot(temp1(:,1),temp1(:,2), 'Color', 'Red');
        end
    end
    
    for k=1:2:size(dir2cube, 2)
      
        temp2 = dir2cube(:, :, j);
        temp2 = temp2(k:k+1);
        temp2 = cell2mat(temp2);

        if ~isempty(temp2)
           plot(temp2(:,1),temp2(:,2), 'Color', 'Black');
        end
        
    end
end

% Second 3 Plots
figure;
sgtitle('\color{blue}Trajectories')

counter2 = 1;
for j=(size(dir1cube, 3)/2)+1:size(dir1cube, 3)
    subplot(3,1,counter2);

    if counter2 == 1
        title('\color{red}90° - 120° \color{black},  270° - 300°') 
    elseif counter2 == 2
        title('\color{red}120° - 150° \color{black},  300° - 330°')
        ylabel('Y-position (cm)');
    elseif counter2 == 3
        title('\color{red}150° - 180° \color{black},  330° - 360°')
        xlabel('X-position (cm)');
    end
    xlim([-40 40]);
    ylim([-40 40])
    hold on 
    
    for k=1:2:size(dir1cube, 2)
        temp1 = dir1cube(:, :, j);
        temp1 = temp1(k:k+1);
        temp1 = cell2mat(temp1);

        if ~isempty(temp1)
            plot(temp1(:,1),temp1(:,2), 'Color', 'Red');
        end
      
        temp2 = dir2cube(:, :, j);
        temp2 = temp2(k:k+1);
        temp2 = cell2mat(temp2);

        if ~isempty(temp2)
           plot(temp2(:,1),temp2(:,2), 'Color', 'Black');
        end
    end
    counter2 = counter2 + 1;
end


%}



