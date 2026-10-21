# QEDIT B006 — Diagnostic et correctif expérimental CAS (21/10/2026)

**Statut : source modifiée, PAS compilé ni testé sous WinAPE. Ne pas sauvegarder de données importantes.**

## Hypothèse technique
QEDIT s'exécute en ROM supérieure 1, dans #C000-#FFFF. Les appels firmware CAS via jumpblock peuvent désactiver cette ROM à l'entrée. Une instruction exécutée immédiatement après le retour dans cette zone risque alors de lire une autre ROM ou la RAM, causant un crash. En B002 un premier relais RAM avait été essayé sans succès : cela ne suffit pas à prouver le mécanisme, d'où une vérification spécifique de la restauration ROM après chaque appel.

Références :
- https://www.cantrell.org.uk/david/tech/cpc/cpc-firmware/casmng.htm
- https://www.cantrell.org.uk/david/tech/cpc/cpc-firmware/highkern.htm
- https://cpctech.cpcwiki.de/docs/manual/s158se02.pdf

## Modification du code
- `editor/QEDIT_ROM.asm` copie à l'entrée de QEDIT sept mini-stubs dans `#8C00..#8C76`.
- `CAS_IN_OPEN`, `CAS_IN_CLOSE`, `CAS_IN_CHAR`, `CAS_OUT_OPEN`, `CAS_OUT_CLOSE`, `CAS_OUT_CHAR`, `CAS_OUT_ABANDON` sont appelés depuis le code en RAM et non plus directement depuis la ROM.
- Après chaque CAS, le stub sauvegarde AF/BC/DE/HL, appelle `KL ROM SELECT (#B90F)` avec C=1, restaure les registres et les flags du CAS, puis retourne à QEDIT.
- Le RAM bridge suppose explicitement **QEDIT en Upper ROM slot 1** ; il faudra généraliser la sélection et les conditions d'activation.
- Zone RAM `#8C00-#8C76` à protéger contre les collisions futures.

## Plan de validation
1. Exécuter le workflow RASM, vérifier que le binaire fait 16 384 octets, et détecter erreurs d'assemblage/recouvrement.
2. WinAPE : charger la ROM **en emplacement 1**, AMSDOS en 7, `MEMORY &5FFF` puis `|QEDIT`.
3. Sur **une disquette de test dédiée**, essayer `Ctrl+S` avec le document démo ; noter si reset, message d'erreur ou succès.
4. Quitter QEDIT ; avec BASIC, vérifier que `DEMO.BAS` est lisible et inspecter ses octets et lignes. Refaire `Ctrl+O`.
5. En cas de succès, essayer 50 lignes, puis 1 500 lignes modifiées, et comparer octet à octet une lecture exportée/réimportée.
6. Tester les échecs : disquette absente, protégée, pleine, fichier existant, et absence de corruption mémoire.
7. Tester navigation, clavier, WAIT, menu et sorties sans régression.

## Causes alternatives non éliminées
- Registres/flags selon CAS et AMSDOS, interruptions, pile et retour RSX.
- Banc mémoire #4000-#7FFF actif lors de CAS, firmware et routines auxiliaires.
- Conflits entre écran/texte/RAM AMSDOS et tampons.
- Banc ROM physique 1 ou ROM 7 non restauré à un moment différent.
- Formats AMSDOS et traitement des conditions d'erreur.

Il faut tester et instrumenter, pas déclarer le correctif fonctionnel sur simple inspection.
