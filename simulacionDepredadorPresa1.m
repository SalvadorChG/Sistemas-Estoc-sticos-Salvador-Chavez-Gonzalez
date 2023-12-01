function main()
    % Parámetros
    N_L = 5;           % Número inicial de lobos
    N_O = 15;           % Número inicial de ovejas
    worldSize = 50;    % Tamaño del mundo (2∆ × 2∆)
    delta_L = 2;        % Paso máximo de los lobos
    delta_O = 1;        % Paso máximo de las ovejas
    radio_cercania = 5; % Radio de cercanía para encuentro

    % Probabilidades
    p_L_plus = 0.1;     % Probabilidad de que un lobo genere un nuevo lobo
    p_O_plus = 0.2;     % Probabilidad de reproducción de ovejas
    p_L_minus = 0.05;   % Probabilidad de muerte de lobos no cercanos

    % Número de iteraciones
    T = 100;

    % Inicializar posiciones de lobos y ovejas
    posicionesLobos = inicializarPosiciones(N_L, worldSize);
    posicionesOvejas = inicializarPosiciones(N_O, worldSize);

    % Ejecutar simulación
    simulacion(posicionesLobos, posicionesOvejas, delta_L, delta_O, ...
               radio_cercania, p_L_plus, p_O_plus, p_L_minus, T, worldSize);
end

function posiciones = inicializarPosiciones(N, worldSize)
    % Inicializa las posiciones de lobos u ovejas aleatoriamente en el mundo
    posiciones = rand(N, 2) * worldSize;
end

function simulacion(posicionesLobos, posicionesOvejas, delta_L, delta_O, ...
                     radio_cercania, p_L_plus, p_O_plus, p_L_minus, T, worldSize)
    % Función principal que ejecuta la simulación

    % Historial de población
    historialLobos = zeros(T, 1);
    historialOvejas = zeros(T, 1);

    % Bucle principal de iteraciones
    for iteracion = 1:T
        % Movimiento aleatorio de lobos y ovejas
        posicionesLobos = actualizarPosiciones(posicionesLobos, delta_L, worldSize);
        posicionesOvejas = actualizarPosiciones(posicionesOvejas, delta_O, worldSize);

        % Interacciones entre lobos y ovejas
        [posicionesLobos, posicionesOvejas] = interacciones(posicionesLobos, posicionesOvejas, ...
                                                             radio_cercania, p_L_plus, p_O_plus, p_L_minus);

        % Guardar historial de población
        historialLobos(iteracion) = size(posicionesLobos, 1);
        historialOvejas(iteracion) = size(posicionesOvejas, 1);

        % Visualizar el estado del mundo
        visualizarMundo(posicionesLobos, posicionesOvejas, worldSize);
    end

    % Mostrar gráfico de la población en función de la iteración
    graficarPoblacion(historialLobos, historialOvejas, T);
end

function posiciones = actualizarPosiciones(posiciones, delta, worldSize)
    % Actualiza las posiciones de agentes con movimientos aleatorios limitados

    % Generar movimientos aleatorios
    movimientos = (rand(size(posiciones)) - 0.5) * 2 * delta;

    % Actualizar posiciones y aplicar condiciones de contorno
    posiciones = mod(posiciones + movimientos, worldSize);
end

function [nuevasPosicionesLobos, nuevasPosicionesOvejas] = interacciones(posicionesLobos, posicionesOvejas, ...
                                                                          radio_cercania, p_L_plus, p_O_plus, p_L_minus)
    % Maneja las interacciones entre lobos y ovejas

    % Verificar encuentros cercanos y reproducción
    ovejasMuertas = zeros(size(posicionesOvejas, 1), 1);

    for i = 1:size(posicionesOvejas, 1)
        for j = 1:size(posicionesLobos, 1)
            distancia = norm(posicionesOvejas(i, :) - posicionesLobos(j, :));

            if distancia < radio_cercania
                % Oveja muere y lobo puede generar un nuevo lobo
                ovejasMuertas(i) = 1;

                if rand() < p_L_plus
                    posicionesLobos = [posicionesLobos; posicionesLobos(j, :) + rand(1, 2)];
                end
            end
        end
    end

    % Eliminar ovejas muertas
    posicionesOvejas(ovejasMuertas == 1, :) = [];

    % Reproducción de ovejas
    posicionesOvejas = reproducirAgentes(posicionesOvejas, p_O_plus);

    % Muerte de lobos no cercanos
    lobosMuertos = zeros(size(posicionesLobos, 1), 1);

    for i = 1:size(posicionesLobos, 1)
        if rand() < p_L_minus && ~any(vecnorm(posicionesOvejas - posicionesLobos(i, :), 2, 2) < radio_cercania)
            lobosMuertos(i) = 1;
        end
    end

    % Eliminar lobos muertos
    posicionesLobos(lobosMuertos == 1, :) = [];

    % Devolver nuevas posiciones
    nuevasPosicionesLobos = posicionesLobos;
    nuevasPosicionesOvejas = posicionesOvejas;
end

function visualizarMundo(posicionesLobos, posicionesOvejas, worldSize)
    % Visualiza el estado actual del mundo con lobos y ovejas

    clf;

    % Dibujar lobos
    scatter(posicionesLobos(:, 1), posicionesLobos(:, 2), 'r', 'filled');
    hold on;

    % Dibujar ovejas
    scatter(posicionesOvejas(:, 1), posicionesOvejas(:, 2), 'b', 'filled');
    hold off;

    % Configuraciones de la figura
    title('Simulación Depredador-Presa');
    xlabel('Posición X');
    ylabel('Posición Y');
    xlim([0, worldSize]);
    ylim([0, worldSize]);
    axis square;
    drawnow;
end

function graficarPoblacion(historialLobos, historialOvejas, T)
    % Mostrar gráfico de la población en función de la iteración
    figure;
    plot(1:T, historialLobos, 'r', 'LineWidth', 2, 'DisplayName', 'Lobos');
    hold on;
    plot(1:T, historialOvejas, 'b', 'LineWidth', 2, 'DisplayName', 'Ovejas');
    hold off;
% % 
    % Configuraciones del gráfico
    title('Evolución de la Población');
    xlabel('Iteración');
    ylabel('Número de Agentes');
    legend('Location', 'Best');
    grid on;
end

function posiciones = reproducirAgentes(posiciones, probabilidad)
    % Realiza la reproducción de agentes con una cierta probabilidad

    nuevasPosiciones = [];
%
    for i = 1:size(posiciones, 1)
        if rand() < probabilidad
            nuevasPosiciones = [nuevasPosiciones; posiciones(i, :)];
        end
    end

    posiciones = [posiciones; nuevasPosiciones];
end
