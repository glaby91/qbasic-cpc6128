# Test de QLIB_MATH depuis Locomotive BASIC sous WinAPE

## Fichiers
- `qlib/math/QLIB_MATH_ROM.asm` : ROM de mathématiques v0.1.1 et commande de diagnostic `|MTEST`.
- `tests/math/QLIB_MATH_TEST.BAS` : petit programme en BASIC qui appelle `|MTEST`.
- Build ZIP : https://github.com/glaby91/qbasic-cpc6128/actions/runs/39635927655/artifacts/12360574059

## Mise en route
1. Installer **QLIB_MATH_V011_TEST.ROM** dans un emplacement de ROM d'extension (par exemple ROM 3) dans WinAPE. Ne pas remplacer AMSDOS.
2. Réinitialiser le CPC6128 pour que le firmware découvre les commandes RSX.
3. Depuis Locomotive BASIC, taper directement `|MTEST`, ou saisir/charger puis exécuter `QLIB_MATH_TEST.BAS`.
4. Relever chaque `PASS`/`FAIL`, et toute erreur BASIC `Unknown command` / plantage / affichage anormal.
5. Reporter les résultats, le numéro de ROM et la version du CRTC.

## Portée réelle des tests
Les cinq contrôles sont effectués par **du code Z80 effectivement exécuté dans QLIB_MATH**, et non simulés par le BASIC. Les résultats attendus sont : 46, 221, 100/7=(14,2), racine 144=12, LCG16(100)=501.

Le workflow GitHub confirme **l'assemblage et la taille de 16384 octets** (476 octets de code/données). Cela ne constitue pas une exécution validée sous WinAPE. Le prototype `|MTEST` réalise des tests de fonctionnement mais ne couvre pas encore les bornes, erreurs, la totalité des paramètres ni la compatibilité QBX 7.1.

## Notes techniques
La branche de test inclut également un point d'entrée expérimental à adresse fixe `#C040` pour étude d'une future interface. Il **ne faut pas l'appeler depuis une autre ROM supérieure** sans commutation fiable via une routine placée en RAM. Pour l'instant, le programme BASIC utilise uniquement la commande RSX `|MTEST`, que le firmware sait dispatcher vers la ROM enregistrée.

`main` et `qlib-math-0.1` ne sont pas modifiées par ce test.
