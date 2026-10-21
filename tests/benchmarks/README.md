# Banc d'essai Locomotive BASIC vs QLIB v0.4.1

## Binaire
GitHub Actions 39647576269 : **compilation réussie**. Binaire `QLIB_UNIFIED_V041_BENCH.ROM` de 16384 octets ; code/données occupés **2044 octets** (14340 octets libres avant remplissage FF).

## Méthode
1. Installer la ROM v0.4.1 à la place de l'ancienne ROM QLIB dans WinAPE, redémarrer.
2. Charger `tests/benchmarks/QLIB_VS_BASIC.BAS`, puis `RUN`.
3. Le programme réserve le tampon `#9000` et au-delà avec `MEMORY &8FFF`.
4. Test BASIC : 10000 itérations de multiplication 13×17 puis 10000 incréments `S%=S%+1`.
5. Test ROM : `|MBENCH`, 10000 appels à la primitive de multiplication Z80 (13×17) puis 10000 appels à l'addition 16 bits, avec résultats écrits en RAM.
6. Chronométrage : `TIME` est lu autour de chaque phase ; conversion théorique 300 ticks = une seconde.
7. Résultats attendus : multiplication 221 ; incrémentation 10000 ; PASS et ratio BASIC/ROM si les résultats de la ROM correspondent.

## Ce qui est mesuré
Le ratio englobe la boucle FOR du BASIC, l'interprétation des expressions, et la boucle Z80 avec son compteur. **Ce n'est ni une mesure isolée de MUL8, ni une comparaison entre deux compilateurs, ni un benchmark de fréquence du Z80.** Les deux chemins n'ont pas exactement le même coût de contrôle de boucle. Répéter les essais et comparer plusieurs tailles pour réduire le bruit.

## Validation
Compilation vérifiée sur GitHub ; **résultats temporels et fonctionnement WinAPE encore à confirmer**. La branche stable QLIB v0.4 et ses 31 PASS ne sont pas modifiées.
