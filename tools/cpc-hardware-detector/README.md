# CPC Hardware Detector v0.1

Prototype de détection matérielle Amstrad CPC, en assembleur Z80.

- Source : `DETECT.ASM`
- Adresse d'assemblage : `&8000`
- Lancement : `CALL &8000`
- Affichage : firmware CPC `TXT_OUTPUT` (`&BB5A`)
- Test : présence d'une banque RAM supplémentaire compatible CPC 6128 (bank 4).

**État : prototype non validé dans WinAPE ou sur machine réelle.** La compilation binaire annoncée dans la conversation n'est pas une validation fonctionnelle.

## Précautions
- Le test modifie temporairement l'octet à `&4000` dans deux configurations mémoire, puis restaure ces octets.
- Il suppose une configuration Gate Array standard et remet la configuration `&7FC0`.
- Il réactive les interruptions sans restaurer leur état précédent.
- Ne pas placer code ou pile entre `&4000` et `&7FFF`.
- La présence de bank 4 ne mesure pas la quantité totale de RAM.
- Le test ne couvre pas toutes les extensions ni toutes les configurations matérielles.

Le binaire historique de 286 octets est disponible dans l'archive de travail, mais n'est pas encore intégré ici : assembler le source avec WinAPE avant utilisation.
