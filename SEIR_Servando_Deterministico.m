function find_sigma_for_equal_peaks()
    % Parámetros fijos
    beta = 1.8;
    gamma = 0.1;

    % Valores iniciales
    S1 = 4899;
    E1 = 100;
    I1 = 1;
    R1 = 0;

    % Rango de valores de sigma para probar
    sigma_values = 0.01:0.01:1;

    % Almacenar picos de E e I para cada valor de sigma
    peak_values = zeros(length(sigma_values), 2);

    for i = 1:length(sigma_values)
        sigma = sigma_values(i);

        y0 = [S1 E1 I1 R1 beta sigma gamma];
        [tsol, ysol] = ode45(@SEIR_ODE, [0 100], y0);

        % Encontrar el índice del valor pico para E
        [~, idx_peak_E] = max(ysol(:, 2));

        % Encontrar el índice del valor pico para I
        [~, idx_peak_I] = max(ysol(:, 3));

        % Almacenar los valores de los picos
        peak_values(i, 1) = ysol(idx_peak_E, 2);
        peak_values(i, 2) = ysol(idx_peak_I, 3);
    end

    % Encontrar el valor de sigma donde los picos son más cercanos
    [~, idx_min_difference] = min(abs(peak_values(:, 1) - peak_values(:, 2)));
    optimal_sigma = sigma_values(idx_min_difference);

    % Mostrar resultados
    disp(['El valor óptimo de sigma es: ', num2str(optimal_sigma)]);
    disp(['Número pico de personas para E: ', num2str(peak_values(idx_min_difference, 1))]);
    disp(['Número pico de personas para I: ', num2str(peak_values(idx_min_difference, 2))]);

    % Graficar las curvas para el valor óptimo de sigma
    y0_optimal = [S1 E1 I1 R1 beta optimal_sigma gamma];
    [tsol_optimal, ysol_optimal] = ode45(@SEIR_ODE, [0 100], y0_optimal);

    % Graficar las curvas
    plot(tsol_optimal, ysol_optimal(:, 1), 'Color', 'y', 'LineWidth', 2)
    hold on
    plot(tsol_optimal, ysol_optimal(:, 2), 'Color', 'b', 'LineWidth', 2)
    plot(tsol_optimal, ysol_optimal(:, 3), 'Color', 'r', 'LineWidth', 2)
    plot(tsol_optimal, ysol_optimal(:, 4), 'Color', 'g', 'LineWidth', 2)
    legend('Susceptibles', 'Expuestos', 'Infectados', 'Recuperados')
    title('SEIR Determinístico')
    xlabel('Tiempo')
    ylabel('Población')
    hold off
end

function dYdt = SEIR_ODE(t, Y)
    S = Y(1);
    E = Y(2);
    I = Y(3);
    R = Y(4);
    beta = Y(5);
    sigma = Y(6);
    gamma = Y(7);

    N = S + E + I + R;

    dSdt = -beta * S * I / N;
    dEdt = beta * S * I / N - sigma * E;
    dIdt = sigma * E - gamma * I;
    dRdt = gamma * I;

    dYdt = [dSdt; dEdt; dIdt; dRdt; 0; 0; 0];
end
