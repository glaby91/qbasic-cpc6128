# Audit documentaire CPCrulez — registre initial (21 octobre 2026)

## Périmètre et honnêteté de vérification

Source de départ : https://cpcrulez.fr/coding_menu-cours_et_initiations.htm

Le menu **Cours et Initiations** annonce **37 collections**, mais chacune peut contenir de nombreuses pages. La rubrique ROM/Firmware indexe 79 titres, FDC 53 et AMSLIVE 44 ; ce ne sont **pas des nombres de pages entièrement auditées**.

**Limitation de cette passe** : les requêtes directes vers cpcrulez.fr ont répondu `403 Forbidden`. Les constats ci-dessous proviennent de résultats de recherche contenant des extraits ou du contenu indexé, pas d'une lecture de chaque article en ligne. Les liens qui figurent dans `AUDIT_REGISTER.csv` ont été identifiés ; seulement ceux notés « contenu indexé consulté » ont reçu une vérification initiale de leur contenu. Aucun test sur machine n'a été réalisé à partir de ces documents.

## Constats techniques prioritaires

1. **QEDIT Ctrl+S** : la section CAS de la Bible CPC6128 décrit le buffer de sortie et la gestion d'ouverture/écriture. Revoir les contrats exacts des vecteurs publics CAS_OUT_OPEN / CAS_OUT_CHAR / CAS_OUT_CLOSE, la zone de tampon AMSDOS et la sélection ROM ; **la cause du reset n'est pas prouvée**. Voir https://cpcrulez.fr/codingBOOK_bible6128_2-05-9.htm
2. **Appels inter-ROM** : les tables de vecteurs et routines KL détaillent ROM SELECT, ROM PROBE, ROM DESELECT, SIDE CALL et FAR CALL. Préférer les **vecteurs documentés** aux adresses de routines internes qui varient selon les machines. https://cpcrulez.fr/codingBOOK_bible6128_2-01-1.htm et https://cpcrulez.fr/codingBOOK_bible6128_2-01-2.htm
3. **QEDIT et EDIT firmware** : ne pas confondre notre éditeur de programmes multi-lignes avec l'éditeur de ligne firmware. https://cpcrulez.fr/codingBOOK_bible6128_2-05-A.htm
4. **ROMBOARD QDEV 512** : approfondir comportement de ROM WALK et pagination sur CPC6128, réservations des ROM internes et contention. Les pages logicielles ne valident **pas** le brochage, les temps de propagation, niveaux électriques ni le PCB.
5. **Graphiques et bibliothèque** : Screen Pack décrit les routines du firmware ; AMSLIVE offre des pistes sur CRTC, multiplication, sinus, 3D et audio. Elles nécessitent revue de code, mesures et compatibilité avant réutilisation.

## Registre des pages

Voir [AUDIT_REGISTER.csv](AUDIT_REGISTER.csv) pour chaque URL, statut et intérêt. Le registre est **un échantillon vérifié des références prioritaires**, et non un audit exhaustif du site.

## Prochaines étapes documentaires

- Récupérer légalement les sommaires et pages individuelles (accès humain, archives ou permission du site), puis établir une liste exhaustive par rubrique avec statut `non lu / lu / vérifié / validé expérimentalement`.
- Pour chaque page, relever : titre, date, auteur, URL, variante CPC, instructions/ports/adresses cités, preuves et contradictions, applications QEDIT/QCOMP/QLIB/ROMBOARD.
- Vérifier les détails dans les manuels firmware CPC, schémas de carte mère et essais WinAPE/matériel ; consigner toute divergence.
- Ne pas recopier les articles originaux dans GitHub ; conserver citations courtes, synthèses, métadonnées et liens.
- Ne pas modifier les ROM qualifiées sur la base d'informations non confirmées.

## Statut

**Phase 1 — inventaire initial publié. Audit exhaustif non terminé.**
