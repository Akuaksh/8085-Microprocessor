************************************************************
8085-Simulator Version 1.0 [SoftWehr] - Freeware - ab Win3.x
************************************************************

Dieses Programm simuliert den Prozessor 8085 von Intel. Es werden
alle wichtigen Befehle unterstützt. Die Programmeingabe in
Assembler erfolgt über einen Mini-Editor. Es stehen eine
Eingabe- sowie 2 Ausgabebaugruppen zur Verfügung. Als besonderes
Extra ist auch eine 7-Segment-Anzeige an die Ausgabebaugruppen
anschliessbar. Das erstellte Assemblerprogramm kann "normal" mit
einstellbarer Pausenzeit (in Millisekunden) oder im STEP-Betrieb
ausgeführt werden. Neben allen Registern (inklusive StackPointer)
wird auch ein virtueller Speicherbereich von 0000H bis 00FFH
simuliert (ich denke für die meisten Anwendungen ausreichend).
Durch die Simulation des StackPointers sind auch verschachtelte
Unterprogrammaufrufe möglich. Es wird nur das Zero- und Carryflag
simuliert, da nur diese für den Programmablauf wichtig sind.
Falls Fehler in der Programmausführung auftreten, wird die
entsprechende Zeile markiert. Im Unterverzeichnis "samples"
befinden sich ein paar Beispielprogramme.

Dieses Programm ist für den PRIVATEN Gebrauch kostenlos.
Es darf ohne mein Einverständnis kopiert werden
(im Internet, CD-ROM usw.). Wichtig ist, dass dies im
Originalzustand, mit allen zusätzlichen Dateien, geschieht.
Ich würde mich aber trotzdem über eine Benachrichtigung
freuen. Obwohl ich hoffe, dass das Programm fehlerfrei ist,
kommt es doch immer wieder zu unvorhersehbaren Bugs.
Falls Sie eventuelle Bugs entdecken, bitte ich darum,
sie mir zu melden. Mich interessiert Feedback jeglicher
Art. Ansonsten wünsche ich viel Spass mit dem Programm...

****************************************
Weitere Informationen zum 8085-Simulator
****************************************

Hinweise zur Programmeingabe
============================
Es ist sehr wichtig, dass die eigentlichen Befehle an der
6. Stelle jeder Zeile beginnen, da sie sonst nicht erkannt
werden. Der Editor unterstützt dabei, indem er bei jedem
Zeilenumbruch gleich mit dem Cursor an diese Stelle springt.
Es ist darauf zu achten, dass die letzte Zeile auch mit einem
Zeilenumbruch abgeschlossen wird, da sie sonst ignoriert wird.
Die ersten 3 Stellen sind für Marken reserviert. Das heisst,
dass Marken 3 Stellen lang sein dürfen. Die Marken sollten dann
mit einem Doppelpunkt abgeschlossen werden. Leerzeilen werden
ignoriert. Ausserdem lassen sich Zeilen oder zusätzliche
Informationen nach einem Befehl durch ein vorangestelltes
Semikolon auskommentieren. Wenn Operanden mit einem Buchstaben
beginnen (z.B. bei FFH), dann ist es nicht zwingend notwendig
eine "0" davor zu schreiben. Der 8085-Simulator arbeitet nur
mit Hexwerten.

Befehlsliste
============
Nachfolgend werde ich alle verfügbaren Befehle im Format 
"Befehl Befehlsargument" auflisten.

Erklärung der Befehlsargumente
==============================
adr   - Adresse
marke - Eine im Programm festgelegte Stelle zu der gesprungen
        werden soll.
n     - 8-Bit-Konstante
nn    - 16-Bit-Konstante
r     - 8-Bit-Register
M     - Der durch das Doppelregister HL adressierte
        8-Bit-Speicherplatz. Da nur ein Speicherbereich von
        0000H bis 00FFH simuliert wird, reicht es nur das
        L-Register für die Adressierung zu verwenden.
rp    - Registerpaar (Doppelregister BD, DE, HL)
        Für die Doppelregister darf nur der erste Buchstabe
        angegeben werden (z.B. für BD nur B). Durch den
        entsprechenden Befehl wird das Doppelregister automatisch
        angesprochen.
PSW   - Prozessor-Status-Wort = Inhalte des Akkus und des
        Flag-Registers.
        Hinweis: Kommt nur im Zusammenhang mit den Befehlen
        Push/Pop zum Tragen.

Hinweis: Mit "Akku" ist das Register A gemeint. Die meisten
======== arithmetischen/logischen Operationen laufen über den
         Akku!


Folgende Befehle werden simuliert:
==================================

>>>>8-Bit-Datentransportbefehle
--> in 01
    Das an der Eingabebaugruppe anliegende Byte wird in den Akku
    geladen.
--> out 02 oder 03
    An der jeweiligen Ausgabebaugruppe wird der Akku-Inhalt 
    ausgegeben.
--> mov r1,r2
    Kopiert den Inhalt des Registers r2 in das Register r1.
    +mov M,r
    Kopiert den Inhalt des Registers r in den Speicherplatz M.
    +mov r,M
    Kopiert den Inhalt des Speicherplatzes M in das Register r.
--> mvi r/M,n
    Es wird die 8-Bit-Konstante n in das Register r oder den
    Speicherplatz M geladen.
--> lda adr
    "Lade den Akku mit den Inhalt des adressierten 
    Speicherplatzes."
--> sta adr
    "Kopiere den Akku-Inhalt in den adressierten Speicherplatz."

>>>>16-Bit-Datentransportbefehle
--> lxi rp,nn
    "Lade das Doppelregister rp mit der 16-Bit-Konstanten nn."
--> push rp
    Den Inhalt des Doppelregisters rp im Stack sichern.
    +push psw
    Die Inhalte des Akkus und des Flag-Registers im Stack sichern.
--> pop rp
    Das Doppelregister rp wird mit den Inhalt des durch den
    StackPointer adressierten Speicherplatzes geladen.
    +pop psw
    Akku und Flagregister werden mit den Inhalt des durch den
    Stackpointer adressierten Speicherplatzes geladen.

>>>>Arithmetikbefehle
--> add r/M
--> adi n
    Der neue Akku-Inhalt ergibt sich aus dem alten Inhalt PLUS
    dem Operanden.
    Es werden alle Flags beeinflusst!
--> sub r/M
--> sui n
    Der neue Akku-Inhalt ergibt sich aus dem alten Inhalt MINUS
    dem Operanden. 
    Es werden alle Flags beeinflusst!   
--> inr r/M
    Das Register r oder der Speicherplatz M wird inkrementiert 
    (um 1 erhöht).
    Es wird nur das Zeroflag beeinflusst!
--> dcr r/M
    Das Register r oder der Speicherplatz M wird dekrementiert 
    (um 1 vermindert).
    Es wird nur das Zeroflag beeinflusst!
--> inx rp
    Das Doppelregister rp wird inkrementiert (um 1 erhöht).
    Es wird kein Flag beeinflusst!
--> dcx rp
    Das Doppelregister rp wird dekrementiert (um 1 vermindert).
    Es wird kein Flag beeinflusst!
--> daa
    Dezimalkorrektur des Akkus.
    Es wird kein Flag beeinflusst!

>>>>Logikbefehle
--> ana r/M
--> ani n
    Bitweise UND-Verknüpfung zwischen dem Akku und dem Operanden.
    Das Carryflag wird auf 0 gesetzt. Das Zeroflag wird entsprechend
    beeinflusst!
--> ora r/M
--> ori n
    Bitweise ODER-Verknüpfung zwischen dem Akku und dem Operanden.
    Das Carryflag wird auf 0 gesetzt. Das Zeroflag wird entsprechend
    beeinflusst!
--> cmp r/M
--> cpi n
    Vergleich zwischen dem Akku und dem Operanden (mittels einer
    Subtraktion). Die Inhalte des Akkus und des Operanden bleiben
    erhalten.
    Es werden alle Flags beeinflusst!
--> cma
    Bitweise Negation des Akkus.
    Es wird kein Flag beeinflusst!

>>>>Rotations- und Schiebebefehle
--> rlc
    Der Inhalt des Akkus wird bitweise nach LINKS verschoben.
    Das ganz links stehende Bit wird wieder rechts angehängt.
    Es wird nur das Carryflag beeinflusst!
--> rrc
    Der Inhalt des Akkus wird bitweise nach RECHTS verschoben.
    Das ganz rechts stehende Bit wird wieder links angehängt.
    Es wird nur das Carryflag beeinflusst!

>>>>Sprungbefehle
--> jmp marke
    Sprung zur angegebenen Marke
    +jz marke
    Sprung zur angegebenen Marke, wenn Zeroflag=1
    +jnz marke
    Sprung zur angegebenen Marke, wenn Zeroflag=0
    +jc marke
    Sprung zur angegebenen Marke, wenn Carryflag=1
    +jnc marke
    Sprung zur angegebenen Marke, wenn Carryflag=0
--> call marke
    Unterprogrammaufruf. Die Zeile des dem Call-Befehl
    folgenden Befehls wird als Rückkehrzeile auf dem
    Stack gespeichert. Danach wird zur angegebenen
    Marke gesprungen.
    +cz
    Unterprogrammaufruf zur angegebenen Marke, wenn Zeroflag = 1
    +cnz
    Unterprogrammaufruf zur angegebenen Marke, wenn Zeroflag = 0
    +cc
    Unterprogrammaufruf zur angegebenen Marke, wenn Carryflag = 1
    +cnc
    Unterprogrammaufruf zur angegebenen Marke, wenn Carryflag = 0
--> ret
    Rücksprung aus dem Unterprogramm in das Hauptprogramm. Die
    Rückkehrzeile wird aus dem Stack geladen.
    +rz
    Rücksprung, wenn Zeroflag = 1 (ansonsten Sprung zum Anfang des
    Unterprogramms)
    +rnz
    Rücksprung, wenn Zeroflag = 0 (ansonsten Sprung zum Anfang des
    Unterprogramms)
    +rc
    Rücksprung, wenn Carryflag = 1 (ansonsten Sprung zum Anfang des
    Unterprogramms)
    +rnc
    Rücksprung, wenn Carryflag = 0 (ansonsten Sprung zum Anfang des
    Unterprogramms)

Hinweise zur 7-Segment-Anzeige
==============================

-->Selektierung der anzusteuernden 7-Segment-Anzeigen

Die 7-Segment-Ansteuerung geschieht über die beiden Ausgabebaugruppen
(Port 02 und Port 03). Mit der Ausgabebaugruppe 03 wird die einzelne
7-Segment-Anzeige selektiert. Liegt an der Ausgabebaugruppe 03 z.B.
der Wert 01H an, wird die 7-Segmentanzeige 1 ausgewählt (ganz rechts).
Liegt der Wert 80H an, wird die letzte 7-Segment-Anzeige selektiert
(ganz links). So lassen sich alle 8 Anzeigen auswählen. Es ist auch
möglich mehrere Anzeigen gleichzeitig zu wählen. Legt man
beispielsweise den Wert FFH an, so können alle Anzeigen gleichzeitig
ausgewählt werden.

-->Ansteuerung der selektierten 7-Segment-Anzeigen

Angesteuert werden die ausgewählten 7-Segment-Anzeigen mit der
Ausgabebaugruppe 02 nach dem üblichen Verfahren. Jedem der 8 einzelnen
Elemente einer 7-Segment-Anzeige (einschliesslich Punkt) wird ein
Bit zugeordnet. Auf diese Weise lassen sich alle Zahlen darstellen.
Die Elemente sind wie folgt angeordnet:

A - Balken oben         --> Bit D0
B - Balken rechts oben  --> Bit D1
C - Balken rechts unten --> Bit D2
D - Balken unten        --> Bit D3
E - Balken links unten  --> Bit D4
F - Balken links oben   --> Bit D5
G - Balken Mitte        --> Bit D6
H - Punkt               --> Bit D7

Legt man zum Beispiel den Wert 80H auf die Ausgabebaugruppe 02, so wird
der Punkt an den selektierten 7-Segment-Anzeigen dargestellt. Nachfolgend
eine kleine Tabelle mit den Hex-Werten für die Zahlen 0 bis 9.

0 - 3FH
1 - 06H
2 - 5BH
3 - 4FH
4 - 66H
5 - 6DH
6 - 7DH
7 - 07H
8 - 7FH
9 - 6FH

Im Unterverzeichnis "samples" befindet sich ein Programm, welches eine
Digitaluhr darstellt und die 7-Segment-Anzeigen entsprechend ansteuert.
Dabei wird das Verfahren des Multiplexens angewendet. Das bedeutet, dass
die einzelnen Anzeigen nacheinander mit dem entsprechendem Werten
angesteuert werden. Die Programmgeschwindigkeit ist selbst bei voller
Geschwindigkeit (Pause = 0) nicht schnell genug, um eine einheitliche
Darstellung zu gewährleisten, doch prinzipiell kann man das Programm
gut testen.

<-===========SoftWehr============->
Email:    christian.wehr@gmx.de
Homepage: http://kickme.to/softwehr
<-===========SoftWehr============->