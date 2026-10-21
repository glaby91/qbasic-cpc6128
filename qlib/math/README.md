# QLIB_MATH v0.1 — premier prototype assembleur Z80

## Réalisé
ROM supérieure autonome de **16 Kio** avec en-tête extension et primitives internes : `ADD_U8`, `SUB_U8`, `MUL_U8` (résultat 16 bits), `DIVMOD_U8` (quotient/reste), `ADD_I16`, `SUB_I16`, `ABS_I16`, `SGN_I16`, `ISQRT_U16` (racine entière inférieure) et `LCG16_STEP` (générateur non conforme à RND QBX).

## Limites et précautions
**Ce n'est pas encore une bibliothèque mathématique complète QBX 7.1.**
- `MATH_TRIG`, `MATH_FLOAT`, opérations LONG/CURRENCY, puissances et conversions restent à développer/porter et vérifier.
- L'interface inter-ROM QCOMP → QLIB n'est **pas exposée** ; seuls les points d'entrée privés figurent dans la source.
- `ISQRT_U16` a une complexité proportionnelle à la racine : à optimiser et benchmarker.
- `DIVMOD_U8` est une référence par soustractions successives : priorité correction, puis optimisation.
- Le PRNG `LCG16_STEP` n'implémente pas le comportement de `RND` ou `RANDOMIZE` du BASIC Microsoft.
- Les tests Python de référence valident des propriétés mathématiques, **pas l'exécution de la ROM sur CPC**.
- Les conventions de signe/overflow doivent être testées au niveau Z80 avant ABI publique.
- Pas de nouvelle fonctionnalité de sauvegarde QEDIT.

## Tests de qualification suivants
Exécuter les routines Z80 dans WinAPE avec vecteurs sur les cas limites, mesurer leur vitesse et la taille, puis concevoir un trampoline RAM/commutation ROM conforme au firmware.
