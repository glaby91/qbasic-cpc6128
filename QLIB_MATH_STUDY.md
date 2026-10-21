# QLIB_MATH — étude technique initiale v0.1 (21/10/2026)

## Contrat
Compatibilité observable avec Microsoft BASIC PDS/QBX 7.1 prioritaire sur les choix d'implémentation. Aucune routine tierce copiée ou validée à cette étape.

## Types fondamentaux, par degré de difficulté
| Type QBX | Stockage attendu | Travail |
|---|---|---|
| INTEGER | 16 bits signé | arithmétique, conversions, overflow |
| LONG | 32 bits signé | arithmétique + conversions |
| SINGLE | 32 bits flottant | déterminer précisément le format et la sémantique QBX visés avant portage |
| DOUBLE | 64 bits flottant | déterminer précisément le format et la sémantique QBX visés avant portage |
| CURRENCY | entier signé à échelle 10 000 sur 64 bits (à confirmer à la source de référence) | opérations décimales exactes, erreurs et arrondis |
| Types utilisateurs | selon TYPE | hors QLIB_MATH 0.1 |

**Ne pas confondre MBF32, flottants natifs CPC sur 5 octets et IEEE binary32.** Ne pas promettre une compatibilité numérique bit à bit sans vérification sur QBX 7.1.

## Routines candidates à qualifier
| Groupe | Primitive QLIB | Famille BASIC | Priorité |
|---|---|---|---|
| I16 | QLM_I16_ADD, SUB, MUL, DIVMOD, CMP | opérateurs entiers | P0 |
| I32 | QLM_I32_ADD, SUB, MUL, DIVMOD, CMP | LONG | P1 |
| Conversions | QLM_PARSE_I16, PRINT_I16, CINT, CLNG | VAL, STR$, CINT, CLNG | P0 |
| FP | QLM_FP_ADD, SUB, MUL, DIV, SQRT | SINGLE/DOUBLE | P2 |
| Fonctions | QLM_ABS, SGN, INT, FIX | fonctions QBX | P1 |
| Trigo | QLM_SIN, COS, TAN, ATN | fonctions QBX | P3 |
| Décimal | QLM_CUR_ADD, SUB, MUL, DIV | CURRENCY | P3 |

## Bibliothèques et méthodes à comparer
1. **Z80 fait maison et microbenchmarks** : référence pour I16 / I32 et conversions.
2. **z88dk cpc maths** : exploitation du package flottant natif CPC (5 octets), candidat performance/ROM à comparer ; utilise IX et IY.
3. **z88dk MBF32/MBF64** : bibliothèque Microsoft potentiellement utile à la compatibilité, mais formats et précision à qualifier.
4. **z88dk math32** : IEEE binary32, candidat vitesse, mais pas nécessairement compatible QBX sans adaptation.
5. **Firmware CPC** : peut réduire drastiquement le code embarqué ; coûts de passage, états ROM/firmware et précision à évaluer.

Liens d'étude :
- https://github-wiki-see.page/m/z88dk/z88dk/wiki/Classic--Maths-Libraries
- https://www.z88dk.org/wiki/doku.php?id=platform%3Aamstradcpc
- https://www.pcjs.org/documents/books/mspl13/basic/b7lang/

## ABI provisoire pour microbenchmarks
- Aucune ABI ROM définitive tant que les commutations de banque ne sont pas testées.
- Convention prototype I16 : HL = opérande A, DE = opérande B ; résultat HL, statut carry/overflow documenté par primitive.
- Conserver explicitement IX/IY pour routines utilisant le firmware flottant, si nécessaire.
- Distinguer sémantique BASIC des erreurs de machine Z80.

## Corpus de tests indépendant du stockage QEDIT
- Addition : 0+0 ; 1+(-1) ; 32767+1 ; -32768-1.
- Multiplication : -1*-1 ; 32767*2 ; -32768*1.
- Division : 7/3 ; -7/3 ; 7/-3 ; -32768/-1 ; division par zéro.
- Conversion : espaces ; +0 ; -0 ; 32767 ; -32768 ; débordement ; caractères invalides.
- Flottant futur : 0, -0, bornes, précision de 1+epsilon, arrondi, domaine de SQR(-1), valeurs trigonométriques.
- Relever pour chaque cas le résultat de QBX 7.1 réel ; ne pas inventer les réponses non vérifiées.

## Livrables vérifiables avant QLIB_MATH 0.1
- Table des comportements QBX démontrés, sources et cas d'incertitude.
- Code source séparé sous `qlib/math/`, avec provenance/licence de chaque module.
- Microbenchmarks dans `tests/math/` : cycles estimés et mesurés, taille Z80, RAM transitoire et coût d'appel inter-ROM.
- Appels firmware et changements ROM validés sur WinAPE avant distribution d'une ROM QLIB.
- Versionnement indépendamment de QEDIT B005.

**Statut : étude / cahier technique uniquement. Les routines QLIB, tests matériels et ROM QLIB ne sont pas encore réalisés.**
