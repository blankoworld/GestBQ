       program-id. ImportationFichier as "MyFirstCobol.ImportationFichier".
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
       select F-Client
          assign to "/donnees/voitures"
          organization indexed
          access random
          record key codeClient.

       data division.
       file section.
       fd F-Client.
       01 ENR-Client.
          02 codeClient pic X(10).
          02 intitule pic X(10).
          02 prenom pic X(50).
          02 nom pic X(50).
       working-storage section.
       77 reponse pic x.
    
       procedure division.
       principal section.
       LireFichier.

       LireFichier-int.
           open i-o F-Client.
       LireFichier-trt.
       LireFichier-fin.

           accept reponse.
           stop run.
       end program ImportationFichier.
       