% Parámetros
N_L = 10; % Número inicial de lobos
N_O = 20; % Número inicial de ovejas
delta_L = 2; % Paso máximo para lobos
delta_O = 1; % Paso máximo para ovejas
rho = 5; % Radio de cercanía
T = 100; % Iteraciones

% Inicialización de posiciones
positions_L = randi([1, 100], N_L, 2); % Posiciones iniciales de lobos
positions_O = randi([1, 100], N_O, 2); % Posiciones iniciales de ovejas

% Simulación
for iteration = 1:T
    % Movimiento aleatorio de lobos y ovejas
    movements_L = randi([-delta_L, delta_L], N_L, 2);
    movements_O = randi([-delta_O, delta_O], N_O, 2);
    positions_L = positions_L + movements_L;
    positions_O = positions_O + movements_O;

    % Encuentro cercano y reglas del sistema
    for i = 1:N_L
        for j = 1:N_O
            distance = norm(positions_L(i, :) - positions_O(j, :));
            if distance < rho
                % Oveja muere, y el lobo puede generar un nuevo lobo
                positions_O(j, :) = [];
                N_O = N_O - 1;
                if rand() < 0.1
                    positions_L = [positions_L; positions_L(i, :)];
                    N_L = N_L + 1;
                end
                break;
            end
        end
    end

    % Reproducción de ovejas
    for i = 1:N_O
        if rand() < 0.2
            positions_O = [positions_O; positions_O(i, :)];
            N_O = N_O + 1;
        end
    end

    % Muerte de lobos no cercanos a ovejas
    for i = 1:N_L
        if rand() < 0.05 && all(vecnorm(positions_L(i, :) - positions_O, 2, 2) > rho)
            positions_L(i, :) = [];
            N_L = N_L - 1;
            break;
        end
    end

    % Visualización de la población en cada iteración
    scatter(positions_L(:, 1), positions_L(:, 2), 'b', 'filled');
    hold on;
    scatter(positions_O(:, 1), positions_O(:, 2), 'g', 'filled');
    title(['Iteración ', num2str(iteration)]);
    xlabel('Posición X');
    ylabel('Posición Y');
    legend('Lobos', 'Ovejas');
    pause(0.1);
    hold off;
end
