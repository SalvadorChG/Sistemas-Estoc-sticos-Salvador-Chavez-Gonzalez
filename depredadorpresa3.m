function depredadorpresa3()

% Parámetros del sistema
delta_L = 1; % Pasos máximos de los lobos
delta_O = 1; % Pasos máximos de las ovejas
N_L = 10; % Número inicial de lobos
N_O = 50; % Número inicial de ovejas
rho = 5; % Radio de cercanía

% Dimensiones del mundo
delta = 50;
worldSize = 2 * delta;

% Número total de iteraciones
T = 100;

% Posiciones iniciales aleatorias de lobos y ovejas
initialWolfPositions = rand(N_L, 2) * worldSize;
initialSheepPositions = rand(N_O, 2) * worldSize;

% Inicializar posiciones y contadores
wolves = initialWolfPositions;
sheep = initialSheepPositions;

% Bucle principal de simulación
for t = 1:T
    % Evaluar interacciones entre lobos y ovejas
    [wolves, sheep] = evaluateInteractions(wolves, sheep, rho);
    
    % Mover lobos y ovejas aleatoriamente
    wolves = moveRandomly(wolves, delta_L);
    sheep = moveRandomly(sheep, delta_O);
    
    % Visualización
    visualizeSimulation(wolves, sheep, worldSize);
end

end

function [wolves, sheep] = evaluateInteractions(wolves, sheep, rho)
    % Evaluación de interacciones entre lobos y ovejas
    newSheep = sheep;
    
    for i = 1:size(wolves, 1)
        for j = 1:size(sheep, 1)
            distance = norm(wolves(i, :) - sheep(j, :));
            
            if distance < rho
                % Si un lobo y una oveja están "cerca", la oveja muere
                newSheep(j, :) = [];
            end
        end
    end
    
    sheep = newSheep;
end

function agents = moveRandomly(agents, delta)
    % Mover agentes aleatoriamente
    randomSteps = (rand(size(agents, 1), 2) - 0.5) * delta;
    agents = agents + randomSteps;
end

function visualizeSimulation(wolves, sheep, worldSize)
    % Visualización de la simulación
    figure;
    hold on;
    
    % Graficar lobos
    scatter(wolves(:, 1), wolves(:, 2), 'r', 'filled', 'MarkerEdgeColor', 'k', 'LineWidth', 1.5);
    
    % Graficar ovejas
    scatter(sheep(:, 1), sheep(:, 2), 'b', 'filled', 'MarkerEdgeColor', 'k', 'LineWidth', 1.5);
    
    title('Simulación Depredador-Presa');
    xlabel('Posición X');
    ylabel('Posición Y');
    legend('Lobos', 'Ovejas');
    grid on;
    axis equal;
    
    xlim([0, worldSize]);
    ylim([0, worldSize]);
    
    hold off;
    
    pause(0.1); % Breve pausa para la visualización
end
