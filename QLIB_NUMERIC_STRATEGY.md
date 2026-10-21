# QLIB/QCOMP — stratégie numérique : voie rapide INTEGER 16 bits

## Décision
Sur CPC6128, optimiser d'abord les opérations 16 bits des programmes BASIC usuels, sans sacrifier le support QBX 7.1 des autres types. L'estimation « 90 % des programmes » est un objectif de conception non mesuré, et non un fait établi. La résolution vidéo (MODE 0/1/2) n'impose aucune limite à la précision numérique.

## Modèle
- `INTEGER` : signé 16 bits, -32768..32767, voie rapide par registres Z80 et routines minimalistes.
- `LONG` : signé 32 bits, conservé lorsqu'exigé par le type ou les calculs.
- `SINGLE` et `DOUBLE` : support à fournir avec comportement Microsoft BASIC 7.1 vérifié, pas remplacement implicite par des entiers.
- `CURRENCY` : support à qualifier pour les programmes utilisant le calcul exact à échelle fixe.
- Conserver les règles de promotions, conversions et débordements QBX 7.1 ; optimisation uniquement si équivalence de comportement démontrée.

## Division du travail
- **QCOMP** : résolution des types ; séquences Z80 inline pour les opérations INTEGER courtes quand elles sont réellement plus économiques ; appel QLIB sinon.
- **QLIB_MATH** : une implémentation de référence optimisée pour chaque opération plus complexe (multiplication, division, conversion, 32 bits, flottants), avec tests.
- Ne pas dupliquer les routines complexes dans les binaires : comparer taille des appels, temps CPU et coût des commutations ROM.

## Mesures et acceptation
1. Benchmarks I16 : addition, soustraction, comparaisons, incrémentation, boucles, produit, division et limites.
2. Mesurer cycles, octets de code, RAM, coût d'un appel direct et d'un appel inter-ROM.
3. Tests différentiels QBX : typage, division entière et réelle, dépassements et erreurs.
4. Comparer programmes de graphismes, jeux et calculs, sans inférer l'utilisation 16 bits de la seule définition d'écran.

## État
Décision architecturale documentée uniquement. Pas de code ROM/compilateur supplémentaire dans ce commit.
