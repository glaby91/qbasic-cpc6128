# QLIB/QCOMP — stratégie numérique : chemin rapide 8 bits

## Décision du projet
**Priorité d'optimisation : 8 bits → 16 bits → 32 bits / flottants / 64 bits uniquement quand ils sont nécessaires.** La conception doit viser les programmes classiques du CPC6128 et limiter la consommation de cycles, de ROM et de RAM.

## Compatibilité impérative Microsoft BASIC PDS / QBX 7.1
- Le type `INTEGER` de QBX reste **signé 16 bits** ; il ne devient pas un type BASIC 8 bits.
- QCOMP peut utiliser une représentation interne 8 bits ou une séquence Z80 8 bits uniquement si le résultat, les règles de conversion et les erreurs observables sont **identiques** à QBX.
- Les bornes 0..255 (octet non signé) et -128..127 (octet signé) sont distinctes. L'optimiseur ne doit pas confondre signedness, comparaisons, retenues, dépassements ou promotions.
- En cas de doute sur la plage de valeurs ou d'un calcul susceptible de déborder 8 bits, employer la voie 16 bits.
- `LONG`, `SINGLE`, `DOUBLE` et `CURRENCY` restent disponibles dans des modules QLIB adaptés, mais ne sont pas le chemin d'exécution préféré.
- Aucun changement silencieux de résultat ni suppression des erreurs BASIC requises.

## Stratégie technique
1. **8 bits rapide** : états booléens, caractères, tableaux de pixels/attributs, indices prouvés bornés, coordonnées Y (0..199), petits compteurs. Sur Z80, utiliser A/B/C/D/E/H/L et les opérations courtes selon mesure.
2. **16 bits de repli** : `INTEGER` général, coordonnées X jusqu'à 639, adresses et pointeurs, compteurs dépassant 255, opérations à risque de retenue/débordement.
3. **Formats étendus à la demande** : longs compteurs, calculs fractionnaires, trigonométrie, science et monnaie quand la sémantique QBX les exige.
4. **QLIB** centralise les primitives Z80 optimisées, l'ABI et les tests ; **QCOMP** sélectionne le chemin correspondant à la preuve des bornes.
5. Mesurer la taille du code, les cycles, les registres modifiés, l'accès RAM et les coûts d'appels inter-ROM. Une opération 8 bits optimisée ne doit pas être plus coûteuse que l'alternative 16 bits sans bénéfice.

## Cas de validation essentiels
- `I%=200` puis `I%=I%+100` doit donner 300 : aucun troncage à 8 bits.
- `I%=255` puis `I%=I%+1` doit donner 256.
- `I%= -1` ; comparaisons contre 1 et 255 : respect du signe.
- Boucle `FOR I%=0 TO 199` : optimisation 8 bits possible si sa progression et sortie sont prouvées sûres.
- Boucle `FOR I%=0 TO 255` : attention à l'incrément terminal et au passage à 256.
- Pour les graphismes CPC : X en MODE 2 peut atteindre 639, donc pas de supposition « toute coordonnée est un octet ».

## État
Décision de conception, **pas** une implémentation QCOMP/QLIB validée. B005 sur `main` conservée.
