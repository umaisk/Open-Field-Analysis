
%{
figure;
histogram(flatDisMatrix, 30, 'EdgeColor', [0, 0.4470, 0.7410], 'FaceColor', [0, 0.4470, 0.7410]);
hold on
percentile25 = round(prctile(flatDisMatrix, 25));
plot([percentile25 percentile25],get(gca,'ylim'),'Color', 'blue', 'LineWidth', 3);
%}

% work backwards now

counter = 1;
for a=1:size(meanDisCube, 3)
    
    disMatrixTemp = meanDisCube(:, :, a);
    flatDisMatrix = disMatrixTemp(:);
    flatDisMatrix(flatDisMatrix==0)=[];
    percentile25 = round(prctile(flatDisMatrix, 25));
    
    flatDisMatrix2 = flatDisMatrix(flatDisMatrix < percentile25);
    
    for p=1:length(flatDisMatrix2)
        [b,r] = find(disMatrixTemp == flatDisMatrix2(p));
        traj25r(:, counter) = {dir1cube(1,r*2-1,a)};
        traj25r(:, counter+1) = {dir1cube(1, r*2, a)};
        traj25b(:, counter) = {dir2cube(1, b*2-1, a)};
        traj25b(:, counter+1) = {dir2cube(1, b*2, a)};
        counter = counter + 2;
    end

end


%% 

figure;
sgtitle('\color{blue}Mean Pairwise Distances')
hold on

for a=1:length(meanDisCube)
    flatMeanDisCube = meanDisCube(:, :, a);

    counter = 1;
    for b=1:length(flatMeanDisCube)
        chk1 = size(meanDisCube2{b});
        if sum(chk1) == 2
            extract(counter, 1) = meanDisCube2{b};
        end
    counter = counter +1;    
    end

    extract = extract(extract > 0);
    meanDisCubeMatrix(a, :) = extract;
end


for c=1:3   
    subplot(3,1,c);

    histogram(meanDisCubeMatrix(c, :), 30, 'EdgeColor', [0, 0.4470, 0.7410], 'FaceColor', [0, 0.4470, 0.7410]);

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
       
        histogram(meanDisCubeMatrix(c, :), 30, 'EdgeColor', [0, 0.4470, 0.7410], 'FaceColor', [0, 0.4470, 0.7410]);

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



