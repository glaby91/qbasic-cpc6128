# QLIB — ROM de bibliothèques BASIC pour CPC6128 (proposition d'architecture)

## Objectif
Une ROM d'extension dédiée **QLIB**, distincte de QEDIT et de QCOMP, pour les routines communes Z80 accessibles aux programmes compilés. Ne pas intégrer ces implémentations à l'éditeur.

## Organisation envisagée
- **QEDIT** : édition, tokens et diagnostics.
- **QCOMP** : analyse sémantique, résolution et génération de code machine Z80.
- **QLIB** : bibliothèques exécutables (mathématiques, chaînes, affichage CPC, AY-3-8912, entrée clavier/joystick, fichiers AMSDOS).
- **QRUN** : éventuellement une petite interface runtime ou un chargeur, si nécessaire après tests.

## Contraintes à résoudre avant de coder
1. ROM d'extension CPC de 16 Kio, banque supérieure commutable ; la présence simultanée logique de plusieurs ROM ne signifie pas qu'elles sont toutes mappées au même instant.
2. Ne pas appeler directement une routine à une adresse d'une autre ROM sans mécanisme sûr de sélection, appel, retour et restauration de banque.
3. Définir une ABI stable : identifiant de fonction, conventions registres/pile, paramètres, types, retour, drapeaux, état des interruptions et préservation des registres.
4. Prévoir une table de vecteurs/API versionnée ; gérer proprement l'absence de QLIB et la compatibilité entre versions.
5. Définir clairement quelles bibliothèques sont résidentes (RAM), appelées via firmware/extension ROM, ou liées directement au programme compilé.
6. Tenir compte des ROM système/AMSDOS et de la mémoire RAM déjà occupée par QEDIT.
7. **Ne pas présumer que la ROM QLIB est directement exécutable depuis n'importe quel contexte mémoire** : valider le modèle d'appel sur CPC6128/WinAPE d'abord.

## Lots proposés
- **QLIB 0.1** : définition ABI, détection/version QLIB, 2 ou 3 routines pilotes (entier, chaîne, affichage).
- **QLIB 0.2** : écran MODE 0/1/2, texte et graphismes.
- **QLIB 0.3** : calculs, chaînes, clavier et AY.
- **QLIB 0.4** : accès fichiers compatibles AMSDOS ; tests de cohabitation ROM.

## Décisions
- Pas d'implémentation immédiate : la validation B005 et B006 restent prioritaires.
- Les définitions de symboles et signatures doivent provenir du profil de langage commun (`language/qbx71-cpc-profile.json`) ou d'un manifeste généré.
- Garder `main` B005 intact ; préparer QLIB dans une branche dédiée plus tard.
- **La sauvegarde Ctrl+S de QEDIT reste un bug distinct** : ne pas promettre que QLIB le corrige.

## Questions d'architecture à vérifier
- Numéro de ROM et stratégie de découverte.
- Trampoline en RAM et conventions de commutation/restauration ROM.
- Programme compilé autonome (liaison statique) ou dépendant de la ROM QLIB installée.
- Impact performances et cycles CPU des appels inter-ROM.
