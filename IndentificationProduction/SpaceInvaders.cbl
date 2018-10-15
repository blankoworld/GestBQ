       program-id. SpaceInvaders as "MyFirstCobol.SpaceInvaders".
       author. Guillaume Quintard.
      *Object. Jeu de space invaders.
       date-written. 03/10/2018.

       environment division.
       configuration section.
       source-computer. SFR-EN2-03.
       object-computer. SFR-EN2-03.

       special-names.
           cursor is cursor-position
           crt status is key-status.
       input-output section.
       file-control.

       
       data division.
       file section.
       working-storage section.
       01 cursor-position.
           03 cursor-row                 pic 99.
           03 cursor-column              pic 99.
       77 reponse pic 9 value 0.
       01 flag         pic 9(2) comp-x value 1.
       01 adis-key-control.
           03 user-key-setting      pic 9(2) comp-x.
           03 filler                pic x value "1".
           03 first-user-key        pic 9(2) comp-x.
           03 number-of-keys        pic 9(2) comp-x.
       01 data-item.
           03 data-char                       pic x occurs 2000.
       01 key-status.
           03 key-type     pic x.
           03 key-code-1   pic 9(2) comp-x.
           03 key-code-2   pic 9(2) comp-x.

       procedure division.
       principal section.
       main.
           call x"af" using flag adis-key-control.
           perform testTouche until key-code-1 = 6.
       
       fin.
           accept reponse.
       testTouche.
           accept data-item at 0101.
           if key-type = "2" then
               evaluate key-code-1
                 when 3
                  display "Gauche   " line 5 col 1
                 when 4
                   display "Droite    " line 5 col 1
                 when 5
                  display "Haut     " line 5 col 1
                 when 6
                  display "Bas    " line 5 col 1
               end-evaluate
           end-if.
       end program SpaceInvaders.
       