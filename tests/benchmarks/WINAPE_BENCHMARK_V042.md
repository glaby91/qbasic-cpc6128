# Validation du benchmark WinAPE QLIB v0.4.2

Date : 21 octobre 2026. Mesures communiquées par l'utilisateur sous forme de capture d'écran WinAPE.

## Résultats observés

| Mesure | Locomotive BASIC | QLIB Z80 |
| --- | ---: | ---: |
| Multiplications 13 × 17 | 10000 | 10000 |
| Additions 16 bits | 10000 | 10000 |
| Temps écoulé (`TIME` ticks, 300/s) | 9886 | 616 |
| Temps estimé (secondes) | 32.9533 | 2.0533 |
| Résultat multiplication | 221 | 221 |
| Résultat addition | 10000 | 10000 |
| Validation affichée | sortie conforme | MUL8 PASS, ADD16 PASS, RESULTAT PASS |

**Rapport BASIC/QLIB = 9886 / 616 = 16.0487012987**, soit environ **16,05×**. Réduction de durée d'environ **93,77 %**.

## Périmètre et prudence
Comparaison de 10000 évaluations BASIC de 13*17 et 10000 additions BASIC avec deux boucles Z80 natives. Les coûts de boucle et de l'interpréteur BASIC font partie de la mesure ; ne pas interpréter ce chiffre comme une accélération pure du MUL8 ni comme gain général pour toutes les opérations. Mesure ponctuelle non répétée ; pas de benchmark de cycles instruction-par-instruction.

La capture d'écran utilisateur confirme l'exécution correcte de la disquette de benchmark et du RSX `|MRESULT` sur la ROM v0.4.2.
