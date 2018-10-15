       program-id. aVotreEnvie as "MyFirstCobol.Program1".
       author. vous-même.
      *Object. Mouvement des comptes clients.
       date-written. 01/01/1200.
       security. secret-defense.

       environment division.
       configuration section.
       source-computer. SFR-EN2-03.
       object-computer. SFR-EN2-03.

       input-output section.
       file-control.


       data division.
       file section.
       working-storage section.
       77 reponse pic x.
       01 Adresse.
      *    10 Rue.
               20 Numero pic 999 value 49.
               20 Intule pic x(8) value "rue".
               20 NomRue pic x(15) value "Principale".
      *    10 Ville.
               20 NomVille pic x(15) value "Uttenheim".
               20 CodePostal pic 99999 value 67150.
           10 Pays pic x(15) value "France".

       01 Adresse-Imprine.
           10 Rue.
               20 Numero pic zz9.
               20 filler pic x.
               20 Intule pic x(8).
               20 filler pic x(4) value " de ".
               20 NomRue pic x(15).
               20 filler pic x.
           10 Ville.
               20 NomVille   pic x(15).
               20 filler     pic x.
               20 CodePostal pic 99999.
               20 filler     pic x.
           10 Pays pic x(15).
       01 etatCivil.
           10 intitule pic x(8) value "Monsieur".
           10 nom      pic x(50) value "Quintard".
           10 prenom   pic x(50) value "Guillaume".

       77 etatCivilImprime pic x(79).

    
       procedure division.
       principal section.
       debut.
           string
               intitule delimited " "
               space delimited by size
               prenom delimited " "
               space delimited by size
               nom delimited " "
               into etatCivilImprime
           end-string.
           display etatCivilImprime.
           unstring
             etatCivilImprime delimited " "
             into intitule prenom nom
           end-unstring.
           display intitule.
           display prenom.
           display nom.
           accept reponse.
      *    display "**** Adresse ****".
      *    display SPACE.
      *    move corresponding Adresse TO Adresse-Imprine.
      *    display Adresse.
      *    display space.
      *    display Adresse-Imprine.
      *    display "\ Rue /".
      *    display SPACE.
      *    accept Rue.
      *    display Numero.
      *    display NomRue.
      *    display Rue.
      *    display "Numero ".
      *    accept Numero.
      *    display SPACE.
      *    display "Intitulé ".
      *    accept Intule.
      *    display SPACE.
      *    display "Nom ".
      *    accept NomRue.
      *    display SPACE.
      *    display SPACE.
      *    display "\ Ville /".
      *    display SPACE.
      *    display "Code postal ".
      *    accept CodePostal.
      *    display SPACE.
      *    display "Nom ".
      *    accept NomVille.
      *    display SPACE.
      *    display "\ Pays /".
      *    accept Pays.
      *    display SPACE.
      *    display Rue.
      *    display Ville.
      *    display Pays.
           accept reponse.
           stop run.
       end program aVotreEnvie.
       