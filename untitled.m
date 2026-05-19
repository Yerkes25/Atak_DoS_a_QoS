% 1. Parametry wejściowe systemu
mu = 130;           %  Przepustowość routera.  K/mu (50/130 = 0.384 s = 384 ms)
K = 50;             %  Rozmiar bufora 
lambda_L = 20;      %  Ruch legalny (pojedynczu ping PC1)

% 2. Wektor ataku (co 10 sek)
lambda_A = 0:10:2000; 
N = length(lambda_A);

% Inicjalizacja tablic na wyniki
P_K = zeros(1, N);      % Prawdopodobieństwo blokady
Delay = zeros(1, N);    % Opóźnienie (czas oczekiwania)

% 3. Pętla obliczeniowa dla każdej intensywności ataku
for i = 1:N
    lambda_total = lambda_L + lambda_A(i);
    rho = lambda_total / mu; % Obciążenie systemu
    
    % Zabezpieczenie przed dzieleniem przez zero dla rho = 1
    if rho == 1
        P_K(i) = 1 / (K + 1);
        L = K / 2;
    else
        % Wzór na prawdopodobieństwo blokady
        P_K(i) = ((1 - rho) / (1 - rho^(K+1))) * rho^K;
        % Wzór na średnią liczbę pakietów w systemie
        L = (rho / (1 - rho)) - ((K + 1) * rho^(K+1) / (1 - rho^(K+1)));
    end
    
    % Obliczenie opóźnienia z Prawa Little'a
    lambda_eff = lambda_total * (1 - P_K(i));
    Delay(i) = L / lambda_eff;
end

% 4. Generowanie Wykresów
figure;

% Wykres 1: Prawdopodobieństwo blokady
subplot(2,1,1);
plot(lambda_A, P_K * 100, 'r', 'LineWidth', 2);
hold on;
% Dodanie punktu pomiarowego z GNS3 
plot(1200, 89.3, 'ko', 'MarkerFaceColor', 'y', 'MarkerSize', 8);
title('Wpływ ataku UDP Flood na prawdopodobieństwo blokady');
xlabel('Intensywność ataku UDP (\lambda_A) [pakiety/s]');
ylabel('Odrzucone pakiety (%)');
legend('Krzywa Teoretyczna', 'Punkt pomiarowy GNS3');
grid on;

% Wykres 2: Średnie opóźnienie w routerze
subplot(2,1,2);
plot(lambda_A, Delay * 1000, 'b', 'LineWidth', 2); 
hold on;
% Dodanie punktu pomiarowego z GNS3 (Atak 1200 pkt/s spowodował opóźnienie ok. 384 ms)
plot(1200, 384, 'ko', 'MarkerFaceColor', 'y', 'MarkerSize', 8);
title('Degradacja QoS: Średni czas przebywania w węźle');
xlabel('Intensywność ataku UDP (\lambda_A) [pakiety/s]');
ylabel('Opóźnienie [ms]');
legend('Krzywa Teoretyczna', 'Pomiar GNS3 (~380 ms)');
grid on;