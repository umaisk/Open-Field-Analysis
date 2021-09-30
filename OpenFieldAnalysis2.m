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
    ct1 = ct1+1;     
    end    
end
%% 


%% Plot histograms 
mpdFigure1 = figure;
sgtitle('\color{blue}Mean Pairwise Distances')
hold on

for i=1:5   
        subplot(5,1,i);
       
        disMatrixTemp = meanDisCube(:, :, i);
        flatDisMatrix = disMatrixTemp(:);
        flatDisMatrix(flatDisMatrix==0)=[];

        histogram(flatDisMatrix, 30, 'EdgeColor', [0, 0.4470, 0.7410], 'FaceColor', [0, 0.4470, 0.7410]);
        
        if i== 1
             title('\color{red}0° - 20° \color{black},  180° - 200°')
        elseif i == 2
            title('\color{red}20° - 40° \color{black},  200° - 220°')
            ylabel('Frequency');
        elseif i == 3
            title('\color{red}40° - 60° \color{black},  220° - 240°')
        elseif i == 4
            title('\color{red}60° - 80° \color{black},  240° - 260°')       
        elseif i == 5
            title('\color{red}80° - 100° \color{black},  260° - 280°')
            xlabel('Distance');
        end
end

mpdFigure2 = figure;
sgtitle('\color{blue}Mean Pairwise Distances')
hold on
counter = 1;

for i=6:9
        subplot(4,1,counter);
       
        disMatrixTemp = meanDisCube(:, :, i);
        flatDisMatrix = disMatrixTemp(:);
        flatDisMatrix(flatDisMatrix==0)=[];

        histogram(flatDisMatrix, 30, 'EdgeColor', [0, 0.4470, 0.7410], 'FaceColor', [0, 0.4470, 0.7410]);
        if i == 6
            title('\color{red}100° - 120° \color{black},  280° - 300°') 
        elseif i == 7
            title('\color{red}120° - 140° \color{black},  300° - 320°')
            ylabel('Frequency');
        elseif i == 8
            title('\color{red}140° - 160° \color{black},  320° - 340°')
        elseif i == 9
            title('\color{red}160° - 180° \color{black},  340° - 360°')
            xlabel('Distance');
        end
        counter = counter + 1;
end

% Composite Mean Pairwise Distances
mpdFigure3 = figure;
linearMDC = meanDisCube(:); 
linearMDC = linearMDC(linearMDC > 0);
prctileMDC = prctile(linearMDC, 25);

histogram(linearMDC, 50, 'EdgeColor', [0, 0.4470, 0.7410], 'FaceColor', [0, 0.4470, 0.7410])
hold on
plot([prctileMDC prctileMDC],get(gca,'ylim'),'Color', 'blue', 'LineWidth', 2)
title("Composite Mean Pairwise Distances");

%% Plot Trajectories

% First 5 Plots
figure;
sgtitle('\color{blue}Trajectories')

for j=1:5
    subplot(5,1,j);
    
    if j== 1
         title('\color{red}0° - 20° \color{black},  180° - 200°')
    elseif j == 2
        title('\color{red}20° - 40° \color{black},  200° - 220°')
    elseif j == 3
        title('\color{red}40° - 60° \color{black},  220° - 240°')
        ylabel('Y Position');
    elseif j == 4
        title('\color{red}60° - 80° \color{black},  240° - 260°')       
    elseif j == 5
        title('\color{red}80° - 100° \color{black},  260° - 280°')
        xlabel('X Position');
    end
    xlim([-40 40]);
    ylim([-40 40])
    hold on 
    
    for k=1:2:size(dir1cube, 2)-1
        temp1 = dir1cube(:, :, j);
        temp1 = temp1(k:k+1);
        temp1 = cell2mat(temp1);

        if ~isempty(temp1)
            plot(temp1(:,1),temp1(:,2), 'Color', 'Red');
        end
    end
    
    for k=1:2:size(dir2cube, 2)-1
      
        temp2 = dir2cube(:, :, j);
        temp2 = temp2(k:k+1);
        temp2 = cell2mat(temp2);

        if ~isempty(temp2)
           plot(temp2(:,1),temp2(:,2), 'Color', 'Black');
        end
        
    end
end

% Second 4 Plots
figure;
sgtitle('\color{blue}Trajectories')

counter2 = 1;

for j=6:9
    subplot(4,1,counter2);

    if j == 6
        title('\color{red}100° - 120° \color{black},  280° - 300°') 
    elseif j == 7
        title('\color{red}120° - 140° \color{black},  300° - 320°')
        ylabel('Y Position');
    elseif j == 8
        title('\color{red}140° - 160° \color{black},  320° - 340°')
    elseif j == 9
        title('\color{red}160° - 180° \color{black},  340° - 360°')
        xlabel('X Position');
    end
    xlim([-40 40]);
    ylim([-40 40])
    hold on 
    
    for k=1:2:size(dir1cube, 2)-1
        temp1 = dir1cube(:, :, j);
        temp1 = temp1(k:k+1);
        temp1 = cell2mat(temp1);

        if ~isempty(temp1)
            plot(temp1(:,1),temp1(:,2), 'Color', 'Red');
        end
    end

    for k=1:2:size(dir2cube, 2)-1
      
        temp2 = dir2cube(:, :, j);
        temp2 = temp2(k:k+1);
        temp2 = cell2mat(temp2);

        if ~isempty(temp2)
           plot(temp2(:,1),temp2(:,2), 'Color', 'Black');
        end
    end
    counter2 = counter2 + 1;
end

%% Find "close-enough" black and red trajectories

for a=1:size(meanDisCube, 3)
    
    
    disMatrixTemp = meanDisCube(:, :, a);
    disMatrixTemp = round(disMatrixTemp, 4); % round to 4 decimal places
    flatDisMatrix = disMatrixTemp(:);
    flatDisMatrix(flatDisMatrix==0)=[];  
    flatDisMatrix2 = flatDisMatrix(flatDisMatrix <= prctileMDC);
    
    counter = 1;
    for p=1:length(flatDisMatrix2)
        
        [b,r] = find(disMatrixTemp == flatDisMatrix2(p));
        
        temp1 = dir1cube(1, r*2-1, a);
        temp2 = dir1cube(1, r*2, a);
        temp3 = [temp1, temp2];
        trajR(1, counter:counter+1, a) = temp3;

        temp4 = dir2cube(1, b*2-1, a);
        temp5 = dir2cube(1, b*2, a);
        temp6 = [temp4, temp5];
        trajB(1, counter:counter+1, a) = temp6;

        counter = counter +2;
    end
end

%% Plot "close-enough" black and red trajectories

% Plot First 5
figure;
sgtitle('\color{blue}"Close-Enough" Trajectories')
for a=1:5
    
    subplot(5,1,a);
    if a== 1
         title('\color{red}0° - 20° \color{black},  180° - 200°')
    elseif a == 2
        title('\color{red}20° - 40° \color{black},  200° - 220°')
    elseif a == 3
        title('\color{red}40° - 60° \color{black},  220° - 240°')
        ylabel('Y Position');
    elseif a == 4
        title('\color{red}60° - 80° \color{black},  240° - 260°')       
    elseif a == 5
        title('\color{red}80° - 100° \color{black},  260° - 280°')
        xlabel('X Position');
    end
    xlim([-40 40]);
    ylim([-40 40])
    hold on;
    
    redTrajTemp = trajR(1, :, a);
    blackTrajTemp = trajB(1, :, a);

    for s=1:length(redTrajTemp)
        logicalR(s) = ~isempty(redTrajTemp{1, s});
        logicalB(s) = ~isempty(blackTrajTemp{1, s});
    end 
    
    redTrajTemp = redTrajTemp(logicalR);
    blackTrajTemp = blackTrajTemp(logicalB);   

    for h=1:2:length(blackTrajTemp)-1
        blackTrajX = blackTrajTemp{1,h}(:);
        blackTrajY = blackTrajTemp{1, h+1}(:);
        
        plot(blackTrajX(:), blackTrajY(:), 'Color', 'Black');

        redTrajX = redTrajTemp{1,h}(:);
        redTrajY = redTrajTemp{1, h+1}(:);
        plot(redTrajX(:), redTrajY(:), 'Color', 'Red');
    end  
end

% Plot Second 4 
figure;
sgtitle('\color{blue}"Close-Enough" Trajectories')
counter2 = 1;
for a=6:9
    subplot(4,1,counter2);

    if a == 6
        title('\color{red}100° - 120° \color{black},  280° - 300°') 
    elseif a == 7
        title('\color{red}120° - 140° \color{black},  300° - 320°')
        ylabel('Y Position');
    elseif a == 8
        title('\color{red}140° - 160° \color{black},  320° - 340°')
    elseif a == 9
        title('\color{red}160° - 180° \color{black},  340° - 360°')
        xlabel('X Position');
    end
    xlim([-40 40]);
    ylim([-40 40])
    hold on 
    
    redTrajTemp = trajR(1, :, a);
    blackTrajTemp = trajB(1, :, a);

    for s=1:length(redTrajTemp)
        logicalR(s) = ~isempty(redTrajTemp{1, s});
        logicalB(s) = ~isempty(blackTrajTemp{1, s});
    end 
    
    redTrajTemp = redTrajTemp(logicalR);
    blackTrajTemp = blackTrajTemp(logicalB);   

    for h=1:2:length(blackTrajTemp)-1
        blackTrajX = blackTrajTemp{1,h}(:);
        blackTrajY = blackTrajTemp{1, h+1}(:);
        plot(blackTrajX(:), blackTrajY(:), 'Color', 'Black');

        redTrajX = redTrajTemp{1,h}(:);
        redTrajY = redTrajTemp{1, h+1}(:);
        plot(redTrajX(:), redTrajY(:), 'Color', 'Red');
    end
    counter2 = counter2 + 1;
end







