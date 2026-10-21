# QEDIT B006 — Validation et analyse syntaxique

## Étape préalable : validation B005 sous WinAPE
- Installer la ROM B005 dans un emplacement d'extension ROM, lancer `MEMORY &5FFF : |QEDIT`.
- Vérifier une ligne avec tokens historiques : `PRINT "OK"`, `FOR I=1 TO 10`, `NEXT I`.
- Vérifier les nouveaux tokens à codage étendu : `CURRENCY`, `XOR`, `MODE`, `PLOT`, `CHDIR`, `DATE$`.
- Déplacer le curseur, changer de page, aller au début/fin et contrôler que les caractères restent intacts.
- Tester les mots insérés dans des identifiants (ex. `MY_XOR_FLAG`) et le contenu des chaînes (ex. `PRINT "MODE"`).
- Ne pas utiliser Ctrl+S : défaillance connue pouvant redémarrer le CPC.

## B006 — première tranche
1. Lexer indépendant des tokens de stockage : respecter chaînes, commentaires, espaces, identifiants et nombres.
2. Vérifier les délimiteurs de chaîne et les parenthèses.
3. Ajouter les signatures à arguments minimaux : `CIRCLE` exige un rayon, `PSET` une paire de coordonnées ; `FOR` exige `TO`.
4. Associer un code d'erreur et une position à chaque ligne ; réutiliser la marque de marge existante et afficher l'explication en bas.
5. Optimiser l'analyse incrémentale au niveau de la ligne modifiée ; différer l'analyse interlignes à B007.
6. Maintenir la compatibilité des 128 anciens IDs et des tokens étendus préfixés 01h.
7. Compiler la ROM 16 Kio en CI, puis valider au clavier sous WinAPE.

## Critères d'acceptation
- Pas de faux positifs pour une chaîne littérale ou un commentaire.
- Erreurs détectées sur une ligne invalide ; disparition du marqueur dès la correction.
- Navigation et affichage sans régression.
- Au plus 16384 octets de ROM.
- Ctrl+S reste volontairement hors périmètre.

**Statut :** plan de développement ; l'analyseur B006 n'est pas encore implémenté ni validé sous WinAPE.
