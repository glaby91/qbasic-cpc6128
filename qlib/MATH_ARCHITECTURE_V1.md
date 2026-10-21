# QLIB_MATH — Architecture complète cible v1.0

**État** : spécification et plan de réalisation ; seule la branche parent `qlib-unified-math-0.2` contient un prototype de ROM exécuté dans WinAPE (19/19 cas). Ne pas confondre inventaire cible et fonctions déjà codées.

## Règles non négociables
- Sémantique Microsoft BASIC PDS / QBX 7.1 : catégories, typage, arrondis, overflow, domaines, erreurs et `RND`. Les écarts CPC seront déclarés comme extensions.
- Chemins rapides **8 bits internes** lorsqu'ils conservent exactement le résultat observable ; INTEGER BASIC demeure **signé 16 bits** ; LONG 32, SINGLE/DOUBLE/CURRENCY en modules optionnels.
- Bibliothèques ROM optimisées, centralisées et partageables, sans duplication automatique dans chaque programme.
- Contrat binaire QCOMP → QLIB avec gestion sûre des ROM commutables et allocation RAM contrôlée.
- Chaque routine : contrat, source/licence, vecteurs, budget cycles / ROM / RAM, statut `planned|coded|assembled|winape-tested|qualified`.

## Organisation source prévue

```text
qlib/
  unified/               # v0.2.1 référence 19/19 PASS, ne pas modifier
  core/                  # addition, sub, comparaison, signedness, flags
  int/                   # MUL/DIV/MOD 8/16/32 bits, erreurs
  convert/               # CINT CLNG CSNG CDBL VAL STR$, parse/format
  fixed/                 # Q8.8, Q16.16, normalisation/arrondi
  trig/                  # SIN COS TAN ATN et tables de coefficients
  float/                 # SINGLE DOUBLE, SQR LOG EXP, puissance
  currency/              # représentation décimale exacte
  random/                # RND/RANDOMIZE Microsoft
  matrix/                # 2x2, 2x3, 3x3, 4x4, vecteurs et rotations
  abi/                   # table des services et trampoline ROM
tests/
  reference/             # oracle Python et, à terme, capture des résultats QBX
  rom/                   # RSX MALLTEST, résultats par famille
  benchmarks/            # cycles Z80, taille, RAM, comparaison firmware
```

## API prévue

| Domaine | Opérations cibles | Note de compatibilité |
|---|---|---|
| CORE8 | ADD/SUB/CMP/MUL/DIVMOD unsigned/signed | optimisation interne |
| INT16 | ADD/SUB/CMP/MUL/DIVMOD/NEG/ABS/SGN | base INTEGER Microsoft |
| INT32 | ADD/SUB/CMP/MUL/DIVMOD | base LONG |
| CONVERT | CINT/CLNG/CSNG/CDBL, VAL, STR$, conversion bases | conversions et erreur overflow |
| FIXED | Q8.8 et Q16.16 : ADD/SUB/MUL/DIV/ROUND | extensions CPC, pas types QBX |
| TRIG | SIN/COS/TAN/ATN, angle radians, précision documentée | chemins 8.8 optionnels uniquement explicites |
| FLOAT | SINGLE/DOUBLE, SQR, LOG, EXP, puissance, INT, FIX | format et arrondis QBX à confirmer sur référence |
| CURRENCY | calcul à échelle 10000, signe, arrondis, overflow | pas de flottants pour les montants |
| RANDOM | RND/RANDOMIZE | LCG prototype non conforme, ne pas exposer comme RND |
| MATRIX | 2x2, 2x3, 3x3, 4x4, composantes signées, vecteur, rotation, perspective | API spécifique CPC |

## Gestion des erreurs
Codes projet provisoires : `OK=0`, `DIV0=1`, `OVERFLOW=2`, `DOMAIN=3`, `INVALID_ARG=4`, `MISSING_MODULE=5`, `ABI_MISMATCH=6`. La correspondance vers les erreurs réelles BASIC Microsoft appartient à QCOMP/QRUN et sera vérifiée. Pas d'effets de bord indéfinis silencieux.

## Interface QCOMP → QLIB
- Table fixe **descripteur de version** et **identifiants logiques de services** (pas des adresses de routines applicatives dans la ROM active).
- Registres d'arguments selon famille ; octets et pointeurs validés ; statut d'erreur explicite.
- Appel inter-ROM via un **trampoline en RAM** garantissant banque d'origine, pile et interruptions. Ne jamais utiliser `CALL #Cxxx` d'une autre ROM sans sélectionner/restaurer sa banque.
- Détecter la ROM de bibliothèque et la version au chargement ; les services optionnels renvoient `MISSING_MODULE`.
- ABI **non finalisée** : la ROM de test v0.2.1 n'est pas une implémentation de cette interface.

## Vérifications de qualification
1. Tester exhaustivement les couples unsigned 8 bits (256×256) pour addition, soustraction, multiplication et division, y compris DIV0.
2. Tester 16 bits avec les valeurs limites et séries reproductibles, comparer à un oracle signé indépendant.
3. Tester les arrondis et opérations non-entiers contre des résultats **obtenus sur QBX 7.1** et archivés.
4. Matrices : zéro, identité, signe, transpose, dépassement des accumulations, multiplication 2×3/3×3, rotation zéro/quart de tour.
5. Après test de référence sur hôte, exécuter réellement les ROM dans WinAPE ; afficher un **PASS/FAIL pour chaque famille et vecteur**, avec résumé final et version affichée exacte.
6. Collecter une mesure de performance reproductible, puis choisir les chemins Z80 les plus rapides compatibles.

## Jalons
- **v0.3** : MUL/DIV/MOD entiers signés, vecteurs limites, harness de tests, ABI préliminaire.
- **v0.4** : Q8.8 et matrices 2×3/3×3.
- **v0.5** : trigonométrie fixe, tables/approximation testées.
- **v0.6** : analyse des formats SINGLE/DOUBLE et fonctions réelles.
- **v0.7** : conversions, RANDOMIZE/RND et types étendus.
- **v0.8** : ABI inter-ROM réelle, benchmark Z80 et tests CPC.
- **v1.0** : couverture documentée et qualification des fonctions supportées, pas une promesse de compatibilité totale sans preuves.

## Versions et préservation
La ROM v0.2.1 et son rapport WinAPE 19/19 PASS restent dans la branche historique. Aucun code non testé ne doit être annoncé comme stable.
