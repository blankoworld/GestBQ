       program-id. GestionBanque as "MyFirstCobol.GestionBanque".
       author. Quintard Guillaume.
       date-written. 27/09/2018.

       environment division.
       configuration section.
       source-computer. SRF-EN2-03.
       object-computer. SRF-EN2-07.
       input-output section.
       file-control.
       select FichierClient
          assign to "C:\Users\Olivier\Documents\Cl� USB Stagiaire\Client.csv"
          organization is line sequential access sequential.
       select FichierRIB
          assign to "C:\Users\Olivier\Documents\Cl� USB Stagiaire\RIB.txt"
          organization is line sequential
          file status is ListeRubErrone-Status.

       data division.
       file section.
       fd FichierClient record varying from 0 to 255.
       01 EnrFichierClient pic x(255).
       fd FichierRIB record varying from 0 to 255.
       01 EnrFichierRIB pic x(255).
       working-storage section.
       77 choixMenu pic 9.
       77 choix pic x.
       77 CouleurFond pic 99 value 15.
       77 CouleurCaractere pic 99 value 0.
       77 finFichier pic 9 value 0.
       01 DateSysteme.
           10 Annee pic 99.
           10 Mois pic 99.
           10 Jour pic 99.
       01 Client.
           10 codeClient pic x(36).
           10 intitule sql char-varying(10).
           10 prenom sql char-varying(50).
           10 nom sql char-varying(50).
           10 nomPrenom sql char-varying(50).
           10 codePostal sql char-varying(20).
           10 Ville sql char-varying(50).
       01 Compte.
           10 codeBanque sql char(5).
           10 codeGuichet sql char(5).
           10 racineCompte sql char(9).
           10 typeCompte sql char(2).
           10 cleRib sql char(2).
           10 solde sql char-varying(30).
           10 credit pic 9(11)9v99.
           10 debit pic 9(11)9v99.
           10 strCredit sql char-varying(15).
           10 strDebit sql char-varying(15).
           10 codeClient pic x(36).
       01 CompteCalc.
           10 codeCompte pic 9(12).
           10 codeBanque pic 9(5).
           10 codeGuichet pic 9(5).
           10 cleRib pic 9(2).
           10 statut pic x(15).
       01 Banque.
           10 codeBanque sql char(5).
           10 nom sql char-varying(170).
       01 CalculRIB.
           10 rep1 pic 9(15).
           10 rep2 pic 9(15).
           10 rep3 pic 9(15).
           10 repT pic 9(15).
       01 EtatControlCleRIBLigneDetail.
           10 yolo pic x.
       77 LigneBanque pic x(78).
       77 nbLigneBanque pic 999.
       77 noLigneCompte pic 999.
       77 noLigneRIB pic 999.
       77 listeBanque-EOF pic 9 value 0.
       77 listeCompte-EOF pic 9 value 0.
       77 valeurRIB pic 99.
       77 NbLigne pic 99.
       77 NbPage pic 99.
       77 div pic 9(15).
      * Variables GestClient
       77 NomClient PIC X(50) VALUE ALL SPACE.
       77 finSelectionCpte PIC 9 VALUE 0.
       77 IndexCompte PIC 99 VALUE 0.
       77 MaxCompte PIC 99 VALUE 0.
       77 GestClient-NoLigneCompte PIC 99 VALUE 0.
       77 NoLigneEfface PIC 99.
       77 ChoixGestion PIC X.

       01 LeCompte.
           10 CodeBanque SQL char(5).
           10 NomBanque SQL char-varying(170).
           10 CodeGuichet SQL char(5).
           10 RacineCompte SQL char(5).
           10 TypeCompte SQL char(5).
           10 CleRIB SQL char(2).
           10 Debit PIC 9(15)V99.
           10 Credit PIC 9(15)V99.

      * Structure du compte m�moris� de la s�lection du client
       01 LAncienCompte.
            10 CodeBanque    SQL CHAR(5).
            10 NomBanque     sql CHAR-VARYING(50).
            10 CodeGuichet   SQL CHAR(5).
            10 RacineCompte  SQL CHAR(9).
            10 TypeCompte    SQL CHAR(2).
            10 CleRIB        SQL CHAR(2).
            10 Debit         PIC 9(12)V99.
            10 Credit        PIC 9(12)V99.

       01 LesComptes occurs 15 times.
           05 AncienCompte.
               10 CodeBanque SQL char(5).
               10 NomBanque SQL char-varying(170).
               10 CodeGuichet SQL char(5).
               10 RacineCompte SQL char(9).
               10 TypeCompte SQL char(2).
               10 CleRIB SQL char(2).
               10 Debit PIC 9(12)V99.
               10 Credit PIC 9(12)V99.
           05 NouveauCompte.
               10 CodeBanque SQL char(5).
               10 NomBanque SQL char-varying(170).
               10 CodeGuichet SQL char(5).
               10 RacineCompte SQL char(9).
               10 TypeCompte SQL char(2).
               10 CleRIB SQL char(2).
               10 Debit PIC 9(12)V99.
               10 Credit PIC 9(12)V99.

       77 ListeRubErrone-Status PIC 99.
       
       77 CNXDB string.
           exec sql
               include SQLCA
           end-exec.
           exec sql
               include SQLDA
           end-exec.

       screen section.
       01 Menu foreground-color is CouleurCaractere background-color is CouleurFond.
           10 blank screen.
           10 line 3 col 30 value "GESTION DE LA BANQUE".
           10 line 6 col 2 value "Date systeme : ".
           10 line 6 col 17 from Jour of DateSysteme.
           10 line 6 col 19 value "/".
           10 line 6 col 20 from Mois of DateSysteme.
           10 line 6 col 22 value "/20".
           10 line 6 col 25 from Annee of DateSysteme.
           10 line 6 col 70 value "Option : ".
           10 line 6 col 79 from choixMenu.
           10 line 10 col 5 value "- 1 - Importation des comptes ..................................... :".
           10 line 11 col 5 value "- 2 - Liste des banques ........................................... :".
           10 line 12 col 5 value "- 3 - Liste des comptes ........................................... :".
           10 line 13 col 5 value "- 4 - Controle des cles RIB ....................................... :".
           10 line 14 col 5 value "- 5 - Gestion des clients ......................................... :".
           10 line 16 col 5 value "- 0 - Retour au menu appelant ..................................... :".
       01 SBanque foreground-color is CouleurCaractere background-color is CouleurFond. 
           10 blank screen.
           10 line 3 col 30 value "LISTE DES BANQUES".
           10 line 1 col 1 value "Page [S]uivante - Retour au [M]enu : " background-color is 0 foreground-color is 7.
           10 line 5 col 1 pic x(80) value all space background-color is 0 foreground-color is 8.
           10 line 5 col 1 value " Code   Nom de la banque" background-color is 0 foreground-color is 8.
       01 SCompte foreground-color is CouleurCaractere background-color is CouleurFond.
           10 blank screen.
           10 line 3 col 30 value "LISTE DES COMPTES".
           10 line 1 col 1 value "Page [S]uivante - Retour au [M]enu : " background-color is 0 foreground-color is 7.
           10 line 5 col 1 pic x(80) value all space background-color is 0 foreground-color is 8.
           10 line 5 col 1 value "Nom Client          Nom Banque        Guichet  Racine    Type Debit  Credit" background-color is 0 foreground-color is 8.
       01 SLigneCompte.
           10 line noLigneCompte col 1 from nomPrenom of Client size 18.
           10 line noLigneCompte col 20 from nom of Banque size 18.
           10 line noLigneCompte col 40 from codeGuichet of Compte size 5.
           10 line noLigneCompte col 47 from racineCompte of Compte size 9.
           10 line noLigneCompte col 59 from typeCompte of Compte size 2.
           10 line noLigneCompte col 63 from strDebit of Compte size 8.
           10 line noLigneCompte col 72 from strCredit of Compte size 8.
       01 SRIB foreground-color is CouleurCaractere background-color is CouleurFond.
           10 blank screen.
           10 line 3 col 30 value "LISTE DES COMPTES".
           10 line 1 col 1 value "Page [S]uivante - Retour au [M]enu : " background-color is 0 foreground-color is 7.
           10 line 5 col 1 pic x(80) value all space background-color is 0 foreground-color is 8.
           10 line 5 col 1 value "Code Banque | Code Guichet | Code Compte | Cle RIB | Status" background-color is 0 foreground-color is 8.
       01 SLigneRIB.
           10 line noLigneCompte col 1 from codeBanque of CompteCalc size 18.
           10 line noLigneCompte col 20 from codeGuichet of CompteCalc size 18.
           10 line noLigneCompte col 40 from codeCompte of CompteCalc size 5.
           10 line noLigneCompte col 47 from cleRIB of CompteCalc size 9.
           10 line noLigneCompte col 55 from statut of CompteCalc size 9.
       01 SGestClient.
           10 blank screen.
           10 line 3 col 30 value "GESTION DES CLIENTS".
      * Info client
           10 line 5 col 2 value  "Nom ........... : ".
           10 line 5 col 45 value "Prenom ... : ".
           10 line 6 col 2 value  "Code postal ... : ".
           10 line 6 col 45 value "Ville .... : ".
      * Ent�te des colonnes
           10 line 8 col 1  PIC X(80) VALUE ALL SPACE background-color is CouleurCaractere.
           10 line 8 col 1  VALUE "No"
               foreground-color is CouleurFond
               background-color is CouleurCaractere.
           10 line 8 col 4  VALUE "Banque"
               foreground-color is CouleurFond
               background-color is CouleurCaractere.
           10 line 8 col 35 VALUE "Guichet"
               foreground-color is CouleurFond
               background-color is CouleurCaractere.
           10 line 8 col 44 VALUE "Compte"
               foreground-color is CouleurFond
               background-color is CouleurCaractere.
           10 line 8 col 52 VALUE "Type"
               foreground-color is CouleurFond
               background-color is CouleurCaractere.
           10 line 8 col 57 VALUE "Cle"
               foreground-color is CouleurFond
               background-color is CouleurCaractere.
           10 line 8 col 62 VALUE "Debit"
               foreground-color is CouleurFond
               background-color is CouleurCaractere.
           10 line 8 col 71 VALUE "Credit"
               foreground-color is CouleurFond
               background-color is CouleurCaractere.
      * Affichage d'un "trait" aux deux tiers de l'�cran environ
           10 line 20 col 1 PIC X(80) VALUE ALL "_".
      * Affichage des donn�es du client (ent�te)
       01 M-Donnees-Client.
           10 line 5 col 20 from nom of Client pic X(25).
           10 line 5 col 58 from prenom of Client pic X(20).
           10 line 6 col 20 from codePostal of Client pic X(25).
           10 line 6 col 58 from Ville of Client pic X(20).
       01 SLigneClient.
           10 line GestClient-NoLigneCompte col 1  pic 99 from IndexCompte.
           10 line GestClient-NoLigneCompte col 4 from CodeBanque
               of NouveauCompte of LesComptes(IndexCompte).
           10 line GestClient-NoLigneCompte col 10 from NomBanque
               of NouveauCompte of LesComptes(IndexCompte) PIC X(26).
           10 line GestClient-NoLigneCompte col 36 from CodeGuichet
               of NouveauCompte of LesComptes(IndexCompte).
           10 line GestClient-NoLigneCompte col 43 from RacineCompte
               of NouveauCompte of LesComptes(IndexCompte).
           10 line GestClient-NoLigneCompte col 53 from TypeCompte
               of NouveauCompte of LesComptes(IndexCompte).
           10 line GestClient-NoLigneCompte col 57 from CleRIB
               of NouveauCompte of LesComptes(IndexCompte).
           10 line GestClient-NoLigneCompte col 60 from Debit
               of NouveauCompte of LesComptes(IndexCompte) PIC Z(5)9V,99.
           10 line GestClient-NoLigneCompte col 69 from Credit
               of NouveauCompte of LesComptes(IndexCompte) PIC Z(5)9V,99.

       01 M-QuestionCreation.
           10 line 1 col 1 value "Voulez-vous creer le client [O]ui/[N]on ?".

      * Phrase pour quitter la consultation des comptes d'un client
       01 SgestionClientOption.
           10 line 1 col 1 value "Voulez-vous [C]onsulter, [m]odifier ou [s]upprimer ce client :"
               background-color is CouleurCaractere foreground-color is CouleurFond.

       01 SgestionClientLineOneClear foreground-color is CouleurCaractere background-color is CouleurFond.
           10 line 1 col 1 PIC X(80) VALUE ALL SPACE.

       01 SgestionClientSuppression.
           10 line 1 col 1 value "Etes-vous sur de vouloir supprimer ce client ? [O]ui / [N]on"
               background-color is 4 foreground-color is CouleurFond.

       01 SGestClientEdition.
           10 line 21 col 1  value "-1-Ajout d'un compte .............:".
           10 line 21 col 37 value "-4-Modification de l'entete :".
           10 line 22 col 1  value "-2-Modification compte ligne No   :".
           10 line 22 col 37 value "-A-Annulation ............. :".
           10 line 23 col 1  value "-3-Suppression compte ligne No   .:".
           10 line 23 col 37 value "-V-Validation ............. :".
           10 line 23 col 68 value "Option :".

       procedure division.
       principal section.
       main-menu.
           perform menu-init.
           perform menu-trt until choixMenu = 0.
           perform menu-fin.
           
       menu-init.
           move "Trusted_Connection=yes;Database=Cigales;server=SRF-EN2-07\SQLEXPRESS;factory=System.Data.SqlClient;" to CNXDB.
           exec sql
               Connect using :CNXDB
           end-exec.
           exec sql
               set autocommit on
           end-exec.
           accept DateSysteme from date.
           move -1 to choixMenu.
           display Menu.
       menu-trt.
           move 0 to choixMenu.
           display Menu.
           accept choixMenu line 6 col 79.
           evaluate choixMenu
               when 1 perform importationComptes
               when 2 perform listeBanques
               when 3 perform listeComptes
               when 4 perform controleClesRIB
               when 5 perform gestionClients
           end-evaluate.
       menu-fin.
           stop run.

       importationComptes.
           perform importationComptes-ini.
           perform importationComptes-trt until finFichier = 1.
           perform importationComptes-fin.

       importationComptes-ini.
           open input FichierClient.
           move 0 to finFichier.
           read FichierClient.
       importationComptes-trt.
           read FichierClient
               at end move 1 to finFichier
               not at end perform trtLigne
           end-read.
       importationComptes-fin.
           close FichierClient.
           accept choixMenu.
           perform main-menu.

       trtLigne.
           perform trtLigne-ini.
           perform trtLigne-trt.
           perform trtLigne-fin.
       trtLigne-ini.
           
       trtLigne-trt.
           unstring
               EnrFichierClient delimited by ";"
               into
               codeBanque of Compte
               codeGuichet of Compte
               racineCompte of Compte
               typeCompte of Compte
               cleRib of Compte
               intitule of Client
               prenom of Client
               nom of Client
               solde of Compte
           end-unstring.
           unstring solde
               delimited by "-" or " " into
               credit of Compte
               debit of Compte
           end-unstring.
           divide 100 into debit of Compte.
           divide 100 into credit of Compte.
      *    ****Enregistrement dans la BD.****
           exec sql
               SELECT newid() into :Client.codeClient
           end-exec.
           exec sql
               INSERT INTO dbo.Client
                   (codeClient
                   ,intitule
                   ,prenom
                   ,nom)
               VALUES
                   (:Client.codeClient
                   ,:Client.intitule
                   ,:Client.prenom
                   ,:Client.nom)
           end-exec.
           exec sql
               INSERT INTO dbo.Compte
                   (codeBanque
                   ,codeGuichet
                   ,racineCompte
                   ,typeCompte
                   ,cleRib
                   ,soldeCrediteur
                   ,soldeDebiteur
                   ,codeClient)
               VALUES
                   (:Compte.codeBanque
                   ,:Compte.codeGuichet
                   ,:Compte.racineCompte
                   ,:Compte.typeCompte
                   ,:Compte.cleRib
                   ,:Compte.credit
                   ,:Compte.debit
                   ,:Client.codeClient)
           end-exec.
       trtLigne-fin.

       listeBanques.
           perform listeBanques-ini.
           perform listeBanques-trt until listeBanque-EOF = 1.
           perform listeBanques-fin.
       listeBanques-ini.
           display SBanque.
           move "s" to choix.
           exec sql
               DECLARE curBanque CURSOR FOR
                   SELECT codeBanque, nomBanque FROM Banque ORDER BY nomBanque ASC
           end-exec.
           exec sql
               OPEN curBanque
           end-exec.
           move 6 to nbLigneBanque.
           move 0 to listeBanque-EOF.
       listeBanques-trt.
           exec sql
               FETCH curBanque into :Banque.codeBanque, :Banque.nom
           end-exec.
           if SQLCODE = 100 or SQLCODE = 101 then
               move 1 to listeBanque-EOF
      *        display "fin"
               move "m" to choix
               accept choix line 1 col 39 background-color is 0 foreground-color is 7
           else
               perform banqueAffichage
           end-if.
           
      *    display nom of Banque.
       listeBanques-fin.
           exec sql
               CLOSE curBanque
           end-exec.

       banqueAffichage.
           string
               codeBanque of Banque delimited " "
               space delimited by size
               space delimited by size
               space delimited by size
               nom of Banque
               into LigneBanque
           end-string.
           display LigneBanque line nbLigneBanque col 2.
           add 1 to nbLigneBanque.
           if nbLigneBanque > 24 then
               accept choix line 1 col 39 background-color is 0 foreground-color is 7
               evaluate choix
                   when "s"
                       move 6 to nbLigneBanque
                       display SBanque
                   when "m" move 1 to listeBanque-EOF
               end-evaluate
           end-if.
       
       listeComptes.
           perform listeComptes-ini.
           perform listeComptes-trt until listeCompte-EOF = 1.
           perform listeComptes-fin.
       listeComptes-ini.
           display SCompte.
           move "s" to choix.
           exec sql
               DECLARE curCompte CURSOR FOR
                   SELECT nomPrenom, nomBanque, codeGuichet, racineCompte, typeCompte, soldeDebiteur, soldeCrediteur FROM listeCompte ORDER BY nomPrenom ASC
           end-exec.
           exec sql
               OPEN curCompte
           end-exec.
           move 6 to noLigneCompte.
           move 0 to listeCompte-EOF.
       listeComptes-trt.
           exec sql
               FETCH curCompte into :Client.nomPrenom, :Banque.nom, :Compte.codeGuichet, :Compte.racineCompte, :Compte.typeCompte, :Compte.strDebit, :Compte.strCredit
           end-exec.
           if SQLCODE = 100 or SQLCODE = 101 then
               move 1 to listeCompte-EOF
               move "m" to choix
               accept choix line 1 col 39 background-color is 0 foreground-color is 7
           else
               perform compteAffichage
           end-if.
       listeComptes-fin.
           exec sql
               CLOSE curCompte
           end-exec.

       CompteAffichage.
           display SLigneCompte.
           add 1 to noLigneCompte.
           if noLigneCompte > 24 then
               accept choix line 1 col 39 background-color is 0 foreground-color is 7
               evaluate choix
                   when "s"
                       move 6 to noLigneCompte
                       display SCompte
                   when "m" move 1 to listeCompte-EOF
               end-evaluate
           end-if.

      *  RIB = 97 - % (89 * codeBanque + 15 * codeGuichet + 3 * numCompte ; 97)
       controleClesRIB.
           perform controleClesRIB-ini.
           perform controleClesRIB-trt until listeCompte-EOF = 1.
           perform controleClesRIB-fin.
       controleClesRIB-ini.
           exec sql
               DECLARE curRIB CURSOR FOR
                   SELECT codeBanque, codeGuichet, codeCompte, cleRib FROM Compte ORDER BY codeCompte ASC
           end-exec.
           exec sql
               OPEN curRIB
           end-exec.
           open output FichierRIB.
           move 0 to listeCompte-EOF.
           move "s" to choix.
           move 6 to noLigneRIB.
           move 66 to NbLigne.
           move 0 to NbPage.
           
           display SRIB.
       controleClesRIB-trt.
           exec sql
               FETCH curRIB into :CompteCalc.codeBanque, :CompteCalc.codeGuichet, :CompteCalc.codeCompte, :CompteCalc.cleRib
           end-exec.
           if SQLCODE = 100 or SQLCODE = 101 then
               move 1 to listeCompte-EOF
           else
               perform verifRIB
           end-if.
       controleClesRIB-fin.
           exec sql
               CLOSE curCompte
           end-exec.
           if NbPage > 0 then
               perform ImpressionPiedDePage
               close FichierRIB
           end-if.
       
       verifRIB.
           move 0 to repT.
           multiply 89 by codeBanque of CompteCalc giving rep1.
           multiply 15 by codeGuichet of CompteCalc giving rep2.
           multiply 3 by codeCompte of CompteCalc giving rep3.
           add rep1 rep2 rep3 to repT.
           divide repT by 97 giving div remainder valeurRIB.
           subtract 97 from valeurRIB.
           move 'OK' to statut of CompteCalc
           if valeurRIB <> cleRib of CompteCalc then
               move 'Valeur change' to statut of CompteCalc
               exec sql
                 UPDATE Compte SET cleRib = format(:valeurRIB,'00') WHERE codeCompte = :CompteCalc.codeCompte
               end-exec
           end-if.
           perform RIBAfficher.

       RIBAfficher.
           display SLigneRIB.
           add 1 to listeCompte-EOF.
           if noLigneRIB > 24 then
               accept choix line 1 col 39 background-color is 0 foreground-color is 7
               evaluate choix
                   when "s"
                       move 6 to noLigneRIB
                       display SRIB
                   when "m" move 1 to listeCompte-EOF
               end-evaluate
           end-if.
       ImpressionRIB.
           if NbLigne > 60 then
               if NbPage > 0 then
                   open output FichierRIB
               else
                   perform ImpressionPiedDePage
               end-if
               perform ImpressionEnTete
           end-if.
           write EnrFichierRIB from EtatControlCleRIBLigneDetail.
       ImpressionPiedDePage.
       ImpressionEnTete.

      **********************************
      * Gestion des clients
      **********************************
      * Cr�ation client, consultation, modification compte, suppression compte
       gestionClients.
           perform gestionClients-init.
           perform gestionClients-trt until NomClient = SPACE.
           perform gestionClients-fin.

       gestionClients-init.
           MOVE '0' TO NomClient.

       gestionClients-trt.
           MOVE SPACE to NomClient.
           DISPLAY SGestClient.
           ACCEPT NomClient line 5 col 20 SIZE 24.
           IF NomClient <> space then perform gestionClients-SelectionCpte.

       gestionClients-fin.
           continue.

       gestionClients-SelectionCpte.
           perform gestionClients-SelectionCpte-Init.
           perform gestionClients-SelectionCpte-Trt until finSelectionCpte = 1.
           perform gestionClients-SelectionCpte-Fin.

       gestionClients-SelectionCpte-Init.
           MOVE 0 to finSelectionCpte.
           exec sql
             DECLARE curSelectionCpte CURSOR FOR
               SELECT [codeBanque]
               ,[nomBanque]
               ,[codeGuichet]
               ,[racineCompte]
               ,[typeCompte]
               ,[cleRib]
               ,[soldeDebiteur]
               ,[soldeCrediteur]
               ,[nom]
               ,[prenom]
               ,[codePostal]
               ,[Ville]
               FROM [CIGALES].[dbo].[listeCompte]
               WHERE nom = :NomClient
               ORDER BY codeBanque, codeGuichet, racineCompte, typeCompte
           end-exec.
           exec sql
             open curSelectionCpte
           end-exec.
      * Indice de gestion du tableau des comptes et de la ligne
      * d'affichage     
           MOVE 0 to IndexCompte.
           MOVE 0 to MaxCompte.
           MOVE 8 to GestClient-NoLigneCompte.
           MOVE 0 to NoLigneEfface.

       gestionClients-SelectionCpte-Trt.
           exec sql
               FETCH curSelectionCpte into
               :LeCompte.codeBanque
               ,:LeCompte.nomBanque
               ,:LeCompte.codeGuichet
               ,:LeCompte.racineCompte
               ,:LeCompte.typeCompte
               ,:LeCompte.cleRib
               ,:LeCompte.debit
               ,:LeCompte.credit
               ,:Client.nom
               ,:Client.prenom
               ,:Client.codePostal
               ,:Client.Ville
           end-exec.
           if sqlcode = 0 or sqlcode = 1
               perform gestionClients-Affichage
           else
                move 1 to finSelectionCpte
           end-if.

       gestionClients-Affichage.
           add 1 to IndexCompte.
           move IndexCompte to MaxCompte.
           move corresponding LeCompte to AncienCompte of LesComptes(IndexCompte).
           move AncienCompte of LesComptes(IndexCompte) to NouveauCompte of LesComptes(IndexCompte).
           move LeCompte to LAncienCompte.

      * Affichage des donn�es du client (dans l'ent�te)     
           if IndexCompte = 1 display M-Donnees-Client.

      * Incr�mentation du num�ro de ligne
           ADD 1 to GestClient-NoLigneCompte.
           DISPLAY SLigneClient.

       gestionClients-SelectionCpte-Fin.
           exec sql
               close curSelectionCpte
           end-exec.

           if MaxCompte = 0 then
               display M-QuestionCreation
               move "N" to ChoixGestion
               accept ChoixGestion line 1 col 43
               if ChoixGestion = "o" then
                   move "O" to ChoixGestion
               end-if
           else
               display SgestionClientOption
               move "C" to ChoixGestion
               accept ChoixGestion line 1 col 65
               if ChoixGestion = "m" then
                   move "M" to ChoixGestion
               end-if
               if ChoixGestion = "s" then
                   move "S" to ChoixGestion
               end-if
           end-if.

      * On efface la question  
           move 1 to NoLigneEfface.
           display SgestionClientLineOneClear.
      * Traitement en fonction du choix de l'utilisateur ets i l'option
      * est effectivement affich�e
           evaluate ChoixGestion
               when "O"
                   move NomClient to nom of Client
                   display M-Donnees-Client
                   if MaxCompte = 0 then perform MajClient
               when "M"
                   if MaxCompte > 0 perform MajClient
               when "S"
                   if MaxCompte > 0 perform SuppressionClient
           end-evaluate.

       MajClient.
           continue.

       SuppressionClient.
           continue.

       end program GestionBanque. 
