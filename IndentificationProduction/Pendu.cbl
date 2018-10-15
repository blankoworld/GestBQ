       program-id. Pendu as "MyFirstCobol.Pendu".
       author. Guillaume Quintard.
      *Object. Jeu du pendu.
       date-written. 26/09/2018.

       environment division.
       configuration section.
       source-computer. SFR-EN2-03.
       object-computer. SFR-EN2-03.

       input-output section.
       file-control.


       data division.
       file section.
       working-storage section.
       77 EtatPendu pic 9 value 0.
       01 LettresCliquer.
           10 noLettre pic 99.
           10 filler pic x.
           10 noMlettre pic x OCCURS 26.
       77 Lettre pic x.
       77 motATrouve pic x(15).
       77 chaine PIC X(20) VALUE "mammouth".
       77 chaine-c PIC X(20).
       77 lettres PIC X(26) VALUE "azertyuiopqsdfghjklmwxcvbn".
       77 lettres-p PIC X(26) VALUE ALL "_".
       77 motAffichage pic x(20).
       77 nbLettre pic 99.
       77 nbTiretBas pic 99 value 0.
       77 premierPassage pic 9 value 1.
       77 char PIC X.

       screen section.

       01 ChoixMot.
           10 blank screen.
           10 line 1 col 1 value "Choisir le mot a trouver".
           10 line 2 col 1 value ">".
       01 intEcran.
           10 blank screen.
       01 Pendu0.
           10 line 9 col 1 from motAffichage.
           10 line 13 col 1 value "Lettre ? ".
           10 line 14 col 1 value ">".
       01 Pendu1.
           10 line 7 col 1 value "  ________".
       01 Pendu2.
           10 line 3 col 1 value "|".
           10 line 4 col 1 value "|".
           10 line 5 col 1 value "|".
           10 line 6 col 1 value "|".
           10 line 7 col 1 value " \".
       01 Pendu3.
           10 line 1 col 1 value "  ______".
           10 line 2 col 1 value " /".
       01 Pendu4.
           10 line 2 col 9 value "|".
       01 Pendu5.
           10 line 3 col 9 value "0".
       01 Pendu6.
           10 line 4 col 8 value "/|\".
       01 Pendu7.
           10 line 5 col 8 value "/ \".

       procedure division.
       principal section.
       para_choixMot.
      *  Choix mot caché
           
           display ChoixMot.
           accept motATrouve.
           string
             motATrouve delimited " "
             into motATrouve
           end-string.
           move motATrouve to chaine.
           MOVE chaine TO chaine-c.
           
           display intEcran.
           perform para_affichePendu.
           INSPECT chaine-c CONVERTING lettres TO lettres-p.
           PERFORM TEST AFTER UNTIL chaine = chaine-c
               move 0 to nbTiretBas
               move chaine-c to motAffichage
               perform para_affichePendu
               ACCEPT char line 14 col 2
               INSPECT lettres CONVERTING char TO "_"
               MOVE chaine TO chaine-c
               INSPECT chaine-c CONVERTING lettres TO lettres-p 
               INSPECT chaine-c TALLYING nbTiretBas FOR ALL "_"
               if premierPassage = 1 then
                   move 0 to premierPassage
                   move nbTiretBas to nbLettre
               end-if

               if nbTiretBas <> nbLettre then
                   perform erreur
               end-if
           END-PERFORM.


           stop run.

       para_affichePendu.
           display Pendu0.

       erreur.
           add 1 to EtatPendu.
           subtract 1 from nbLettre.
           evaluate EtatPendu
               when 1
                   display Pendu1
               when 2
                   display Pendu2
               when 3
                   display Pendu3
               when 4
                   display Pendu4
               when 5
                   display Pendu5
               when 6
                   display Pendu6
               when 7
                   display Pendu7
           end-evaluate 
       end program Pendu.
       