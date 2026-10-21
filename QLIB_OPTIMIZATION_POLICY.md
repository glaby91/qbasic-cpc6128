# QLIB — politique d'optimisation Z80 / CPC6128

## Décision architecturale
**QLIB est la bibliothèque unique de référence des comportements BASIC sur CPC6128.** Chaque primitive sera implémentée et optimisée pour son cas d'utilisation réel (CPU Z80, ROM commutable, mémoire CPC6128, firmware, vidéo CRTC/GA et son AY-3-8912). Les noms de stdio peuvent inspirer l'organisation mais ne déterminent ni API ni implémentation.

**Pas de duplication automatique** des routines de bibliothèque dans le compilateur ou dans chaque exécutable. QCOMP génère des appels aux services documentés de QLIB. Les éventuelles spécialisations inline restent des optimisations explicitement justifiées par mesure, pas un modèle de distribution de bibliothèque parallèle.

## Exigences par primitive
1. Définir une sémantique exacte, limites, erreurs, effets de bord et compatibilité QBX 7.1 ou extension CPC.
2. Définir ABI Z80 stable (registres, pile, paramètres, retour, flags, interruptions, préservation des bancs).
3. Comparer les stratégies possibles : appel firmware CPC, routine Z80 directe, éventuelle solution assistée hardware, suivant l'usage.
4. Optimiser **dans cet ordre** : exactitude, temps d'exécution mesuré, coût des commutations ROM, taille et occupation RAM ; documenter les compromis.
5. Inclure des tests de conformité et des microbenchmarks reproductibles sous émulateur puis, si disponible, matériel réel (cycles, octets ROM et RAM, cas limites).
6. Centraliser les primitives et leurs descriptions dans QLIB ; dépendances et appels inter-ROM sûrs, versionnés.
7. Sur les opérations fréquentes (affichage de caractères, chaînes, arithmétique), viser des chemins d'exécution courts, sans abstraction systématique coûteuse.
8. Si une routine dépasse les capacités d'une ROM 16 Kio, envisager plusieurs ROM QLIB thématiques avec ABI commune, sans multiplier la logique métier.
9. Ne pas réécrire une fonction au seul motif qu'elle ressemble à `stdio` ; n'importer ni couche C, ni conventions DOS/PC non pertinentes.

## Lots prioritaires
- Texte écran : caractère, chaîne, nombre entier ; modes CPC et gestion du curseur.
- Mathématiques : opérations entières, signe, conversion texte/nombre, tables ou algorithmes adaptés au Z80.
- Entrées : clavier et joystick.
- Graphismes : pixel, ligne, cercle et remplissage, optimisés par mode.
- Son : AY-3-8912.
- Fichiers AMSDOS, une fois stratégie sûre de sauvegarde/accès disque testée.

## Validation
- Aucune primitive marquée « optimisée » sans mesure vérifiable de vitesse et de taille comparée à une implémentation de référence.
- Les gains et limitations sont versionnés avec les sources.
- QEDIT B005 reste intact et QCOMP/QLIB ne sont pas encore implémentés.
