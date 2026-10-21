# QBasic CPC6128

Éditeur QEDIT et futur compilateur QCOMP pour Amstrad CPC6128. Langage cible : Microsoft BASIC PDS 7.1 (QBX) adapté au CPC.

## État actuel
- QEDIT v0.4.2 B005 : 196 tokens, ROM d'extension de 16 Kio, compilation RASM réussie ; WinAPE B005 non encore validée.
- Navigation et WAIT validés sur les builds précédents ; diagnostic minimal des lignes expérimental.
- Sauvegarde Ctrl+S **défectueuse** (redémarrage CPC), volontairement reportée. Éviter toute sauvegarde de données importantes.
- QCOMP (compilation Z80 native) reste à développer.

## Compilation
Utiliser le workflow GitHub Actions ou assembler `editor/QEDIT_ROM.asm` avec RASM depuis le dossier `editor/`.

Documentation : [PROJECT_HANDOFF.md](PROJECT_HANDOFF.md), [LANGUAGE_TARGET.md](LANGUAGE_TARGET.md), [language/README.md](language/README.md).

Projet extrait sans suppression ni modification des branches historiques du dépôt `glaby91/moteur3d`.

## Suivi des versions

Voir [PROJECT_STATUS.md](PROJECT_STATUS.md) pour les branches, les builds GitHub Actions, les versions et les problèmes connus. Les ROM de développement sont conservées sur leurs branches et ne sont pas fusionnées automatiquement dans `main`.
