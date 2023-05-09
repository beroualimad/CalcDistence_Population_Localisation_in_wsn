% Nombre de nœuds inconnus et de nœuds beacon
numUnknownNodes = 50;
numBeaconNodes = 10;
distBeaconNodes = randi([18, 25]);
popSize = 30; % nombre d'individus dans la population
xMin = 0; % limite inférieure pour les coordonnées x
xMax = 50; % limite supérieure pour les coordonnées x
yMin = 0; % limite inférieure pour les coordonnées y
yMax = 50; % limite supérieure pour les coordonnées y



% Initialisation de la matrice de coordonnées avec des NaN (valeur manquante)
coordinates = NaN(numUnknownNodes + numBeaconNodes, 2);

% Initialisation des coordonnées des nœuds beacon
beaconNodes = [5, 10; 18, 26; 15, 30; 20, 35; 25, 25; 30, 40; 35, 14; 40, 20; 42, 10; 50, 5];

% Insertion des coordonnées des nœuds beacon dans la matrice de coordonnées
coordinates(1:numBeaconNodes, :) = beaconNodes;

% Initialisation des coordonnées aléatoires des nœuds inconnus
for i = (numBeaconNodes+1):(numBeaconNodes+numUnknownNodes)
    % Génération de coordonnées aléatoires comprises entre 1 et 30
    rowCoord = randi([1, 50]);
    colCoord = randi([1, 50]);
    
    % Insertion des coordonnées aléatoires dans la matrice de coordonnées
    coordinates(i, :) = [rowCoord, colCoord];
end

% Affichage des coordonnées des nœuds balises en rouge et des nœuds inconnus en bleu
scatter(coordinates(1:numBeaconNodes, 1), coordinates(1:numBeaconNodes, 2), 'r');
hold on;
scatter(coordinates(numBeaconNodes+1:end, 1), coordinates(numBeaconNodes+1:end, 2), 'b');
title('Coordonnées des nœuds');
xlabel('Ligne');
ylabel('Colonne');
legend('Nœuds balises', 'Nœuds inconnus');

disp(['Coordonnées de la 3ème UnknownNode : (',num2str(coordinates(12,1)),',',num2str(coordinates(12,2)),')']);


for i = (numBeaconNodes+1): (numBeaconNodes+numUnknownNodes)
    TablBeacon = [];
   
    count = 0;
    for j = 1:numBeaconNodes 
       % distanse = sqrt((coordinates(i,1) - coordinates(j,1))^2 + (coordinates(i,2) - coordinates(j,2))^2 );
        distance = calcDistance(coordinates(i,:), coordinates(j,:));

       % disp(sprintf('for node %d with %d ==> %f', i,j, distance));

        if distance < distBeaconNodes 
            count = count+1;
            if count > 3
                break
            end
            TablBeacon(end+1,:) = [coordinates(j,1),coordinates(j,2)];
        end
    end
   % disp(TablBeacon);
    if size(TablBeacon,1) >= 3
       % pop = [rand(popSize,1)*(xMax-xMin)+xMin, rand(popSize,1)*(yMax-yMin)+yMin];
       pop = [randi([xMin, xMax], popSize, 1), randi([yMin, yMax], popSize, 1)];


       % disp(pop);
        errors =[];
        for s = 1:popSize   
            for anchor = 1:size(TablBeacon,1)  
                distance = calcDistance(pop(s,:), TablBeacon(anchor,:));
                Dshp = distance + distance * 0.05;
                err = distance - Dshp;
                errors = vertcat(errors, err); % ajouter la nouvelle valeur
                
            end
            disp(pop(s,1)); 
            %mse = vertcat(s,calcMSE(errors),pop(s,1),pop(s,2));
            mse(s,:) = [calcMSE(errors),pop(s,1),pop(s,2)];
            
        end
       
    end
    % disp(mse); % Affiche la MSE
end

function distance = calcDistance(point1, point2)
    distance = sqrt((point1(1)-point2(1))^2 + (point1(2)-point2(2))^2);
end


function mean_squared_error = calcMSE(errors)
% Calcule la moyenne des carrés des erreurs (MSE)
% errors : vecteur contenant les erreurs individuelles
% mean_squared_error : la MSE

m = length(errors); % Nombre total d'erreurs
sum_squared_error = sum(errors.^2); % Somme des carrés des erreurs
mean_squared_error = sum_squared_error / m; % Moyenne des carrés des erreurs
end



