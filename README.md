# 🚀 QoS Degradation Analysis during UDP Flood (M/M/1/K Model Validation)

##  O projekcie
Projekt polegał na zbadaniu, jak atak wolumetryczny **UDP Flood (DoS)** niszczy jakość usług (QoS) w sieci oraz na udowodnieniu, że praktyczna emulacja sieciowa idealnie pokrywa się z teorią matematyczną. 

W tym celu zbudowałem laboratorium w **GNS3** oparte na realnym systemie **Cisco IOS**, przeprowadziłem symulację ataku, a następnie zweryfikowałem wyniki numerycznie w środowisku **MATLAB**, wykorzystując  model masowej obsługi **M/M/1/K**.

---

## Wykorzystane technologie i narzędzia
* **Emulacja sieci:** GNS3 (Cisco IOS - realne zarządzanie pamięcią i procesorem)
* **Wirtualizacja:** VirtualBox / GNS3 VM
* **Analiza ruchu:** Wireshark (I/O Graphs, głęboka inspekcja pakietów)
* **Obliczenia i analityka:** MATLAB (implementacja teorii masowej obsługi)
* **Protokoły:** IPv4, ICMP (narzędzie pomiarowe), UDP (generowanie ataku), Ethernet (MTU 1500B)

---

## Model Matematyczny vs Realna Sieć
W projekcie sprawdziłem zachowanie routera jako systemu **M/M/1/K**:
* **M (Napływ):** Pakiety legalne i złośliwe wpadają losowo i niezależnie (Strumień Poissona).
* **M (Obsługa):** Czas procesowania ramki zależy od jej wielkości.
* **1 (Serwer):** Jeden interfejs wyjściowy routera stanowiący wąskie gardło (*bottleneck* - 10 Mbps).
* **K (Bufor):** Sprzętowy limit kolejki routera ustawiony sztywno na `hold-queue 50 out`.

---

## Przebieg eksperymentu (3 Fazy)

| Faza | Opis | Stan sieci | Zachowanie bufora | QoS (Ping PC1) |
| **1. Baseline** | Brak ataku, tylko ruch legalny. | **Stabilny** | Pusty (P = 0) | Idealny (~15 ms) |
| **2. Przeciążenie** | Uruchomienie średniego ataku UDP. | **Degradacja** | Formowanie kolejki (Prawo Little'a) | Drastyczny skok opóźnień (~350 ms) |
| **3. Saturation** | Maksymalny atak . | **Blokada (DoS)** | Przepełnienie 100% (*Drop-Tail*) | Całkowita utrata łączności (`timeout`) |

---

## Struktura repozytorium
* `untitled.m` - Skrypt MATLAB generujący teoretyczne krzywe i wykresy porównawcze.
* `AtakDOSv1/` - Pliki konfiguracyjne urządzeń z laboratorium GNS3.
* `PC2_Ethernet0_to_R1_FastEthernet01.pcap` - Plik Wiresharka rejestrujące momenty przeciążenia sieci.
* `Projekt atak UDP Flood a QoS - sprawozdanie.pdf` - Pełna dokumentacja projektowa z analizą .

---
Projekt zrealizowany w celach naukowych, pokazujący praktyczne zastosowanie Teorii Masowej Obsługi (TMO) w inżynierii bezpieczeństwa sieciowego.
