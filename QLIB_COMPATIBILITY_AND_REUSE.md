# QLIB — compatibilité QBX 7.1 et réutilisation de bibliothèques

## Priorité contractuelle
1. **Comportement attendu de Microsoft BASIC Professional Development System 7.1 / QBX 7.1** : syntaxe, types, ordre d'évaluation, erreurs, formats numériques, données et entrées/sorties.
2. **Portabilité CPC6128** : adapter aux contraintes matérielles sans changer silencieusement le résultat BASIC ; documenter toute exception.
3. **Réutilisation de composants éprouvés** de C, assembleur Z80, firmware Amstrad ou autres BASIC lorsque leur licence, leur interface et leur précision conviennent.
4. **Optimisation mesurée** : temps Z80, coût de changement de ROM, taille ROM/RAM et lisibilité/maintenance de l'ABI.

## Sources candidates à auditer — non intégrées automatiquement
| Source | Candidats | Points à contrôler |
|---|---|---|
| z88dk | stdio, string, stdlib, math, arithmétique Z80 | licence précise par fichier, dépendances, ABI, taille, format des chaînes, système de fichiers |
| z88dk cible CPC | console MODE 0/1/2, cpcrslib, firmware interposer | contention des ROM, accès vidéo, timings, dépendances runtime |
| z88dk CPC maths | fonctions mathématiques utilisant le firmware CPC | précision et conversion par rapport aux types QBX, index IX/IY |
| z88dk MBF32 | mathématiques au format Microsoft | MBF32 n'est pas automatiquement identique à tous les formats QBX 7.1 |
| firmware CPC | console, clavier, cassette/disquette via AMSDOS | état firmware, vecteurs, RAM nécessaire, ROM active |
| routines Z80 open-source | multiplication, division, conversion et dessin | preuve de licence, mesures comparatives et tests |

Références techniques initiales :
- https://github.com/z88dk/z88dk
- https://github-wiki-see.page/m/z88dk/z88dk/wiki/Platform---Amstrad-CPC
- https://github-wiki-see.page/m/z88dk/z88dk/wiki/Classic--Maths-Libraries
- https://www.pcjs.org/documents/books/mspl13/basic/b7lang/

## Pipeline de qualification par routine
1. Décrire les entrées, sorties, cas limites et erreurs selon la référence QBX.
2. Choisir un ensemble de tests différentiels BASIC/QBX puis CPC.
3. Recenser implémentations existantes et leurs licences précises ; ne copier aucun code avant vérification.
4. Adapter ou porter la meilleure candidate, sinon produire une routine Z80 spécifique.
5. Comparer latence, cycles, octets ROM/RAM, coût d'appel inter-ROM, compatibilité.
6. Enregistrer la provenance, version, licence, modifications, bancs mémoire, ABI et résultats de benchmark dans le manifeste QLIB.
7. Publier seulement les primitives vérifiées ; marquer les autres `planned`, `ported_unverified` ou `verified`.

## Interfaces et modules
- QCOMP génère des appels de services QLIB ; seule la sémantique BASIC doit rester visible côté programmeur.
- Bibliothèques thématiques possibles : chaînes, nombres, console, graphismes, son, entrée, fichiers.
- Un vocabulaire interne inspiré de stdio est acceptable ; les fonctions utilisateur restent celles de QBX ou des extensions CPC clairement identifiées.
- Des wrappers de conversion sont autorisés uniquement quand le coût est maîtrisé ; pas de reproduction aveugle d'une libc entière.
- La stratégie de ROM commutable, l'ABI et le modèle de dépendance à QLIB restent à valider sous WinAPE.

## État
Document de conception. Aucune bibliothèque tierce importée ni routine QLIB validée dans cette modification. QEDIT B005 sur main reste inchangé.
