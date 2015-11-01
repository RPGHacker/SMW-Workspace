HP und MP Counter im RPG-Stil Version 1.2
von RPG Hacker


;;;;;;;;;;;;
;Einführung;
;;;;;;;;;;;;

Dieser Patch installiert bei euer Super Mario World ROM einen von alten SNES RPGs wie
Secret of Mana oder Seiken Densetsu 3 inspirierten HP und MP Counter. Ihr könnt maximal
999 HP und 99 MP haben. Ihr könnt es so einstellen, dass bestimmte Aktionen (Feuerbälle
verschießen, Fliegen, Cape-Drehung) MP verbrauchen und ihr sie nicht mehr ausführen könnt,
wenn eure MP zu niedrig sind.

Der Patch verändert auch eure Status Bar. Mario/Luigi, Yoshimünzen, Bonussterne und Leben
werden nicht mehr in der Status Bar angezeigt um Platz für den HP und MP Counter zu schaffen
(sie funktionieren aber alle nach wie vor). Das Status Bar Item wurde außerdem durch
Mario's Kopf ersetzt, sieht so ähnlich aus wie in Secret of Mana (ich habe auch so einen
Rahmen wie bei Secret of Mana hinzugefügt, wenn er euch nicht gefällt, könnt ihr ihn ganz
leicht mit dem SMW Status Bar Editor wieder entfernen). Damit der Kopf fehlerfrei angezeigt
werden kann, wird der Item Fix Patch vewendet. Mario's Kopf ersetzt die Smiley-Münze, da
diese relativ selten verwendet wird, kann aber auch ganz leicht auf eine andere Grafik
verlinkt werden, indem ihr den zweiten Wert unter "ItemTable" verändert.

Wenn ihr diesen Patch verwendet, verliert ihr nicht mehr euer Powerup, sobald ihr getroffen
werdet, sondern nur noch, wenn ihr stirbt (allerdings fängt ihr immer als Super Mario an,
nicht mehr als Small Mario). Außerdem wurden einige Items in ihrer Funktion verändert.
Der Pilz heilt jetzt XXX HP, der 1UP-Pilz XX MP. Sammelt ihr außerdem das selbe Item mehrmals
hintereinander ein, werden bei jedem weiteren mal halb so viele MP regeneriert, wie der
1UP-Pilz regenerieren würde. Ist euer 1UP-Pilz also auf 10 MP eingestellt und ihr sammelt
als Feuer Mario noch eine Blume, so werden euch 5 MP gutgeschrieben.

Ich habe zu diesem Patch auch SRAM-Speicherung hinzugefügt. Eure HP, Max HP, MP, Max MP,
Powerup und Item werden im SRAM gespeichert. Eure Leben werden auch im SRAM gespeichert,
allerdings nur dann, wenn ihr mehr Leben habt als bei einem neuen Spiel.

Beachtet bitte, dass dieser Patch den zweiten Spieler automatisch deaktiviert, deswegen
solltet ihr zweimal nachdenken, bevor ihr ihn benutzt. Außerdem kann es zu kleinen
Slowdowns kommen, wenn viele Sprites auf dem Bildschrim sind (diese sind aber wirklich
nicht sooo schlimm).
Auf jeden Fall gilt:

MACHT EIN BACKUP VON EURER ROM BEVOR IHR DEN PATCH ANWEDET

Benutzt den Patch auf eigene Gefahr, ich bin nicht verantwortlich für Schaden, der
durch ihn verursacht wird. Ich habe erst vor kurzm mit ASM angefangen; das hier ist einer
meiner ersten Patches. Möglicherweise ist der Code ziemlich schlecht geschrieben, enthält
Bugs oder zerstört sogar eure ROM. Auf jeden Fall habe ich aber mein bestes gegeben um
solche Fehler zu vermeiden.

Ach ja, noch etwas: Dieser Patch sollte ohne Probleme mit dem 6 Digit Coin Counter Patch
kompatibel sein. Allerdings müsst ihr den Coin Counter Patch als erstes und diesen Patch
als zweites installieren.

Ihr müsst mir keine Credits geben, wenn ihr diesen Patch verwendet.


;;;;;;;;;;;
;Anwendung;
;;;;;;;;;;;

Zuerst mal solltet ihr die ExGFX-Dateien in eure Hacks einfügen, damit ihr keinen Grafik-Müll
in der Status Bar bekommt.

Danach müsst ihr die ASM-Datei öffnen und einige Startwerte und freien Speicherplatz in
der ROM angeben.


!IntroLevel
Das ist das Intro Level + #$24. Also wenn ihr hier $E9 einstellt, ist C5 euer Intro Level.
Wenn ihr $00 einstellt, wird das Intro Level übersprungen. Das ist allerdings nicht zu
empfehlen, weil es dann einen kleinen Bug auf der Overworld gibt.


!LifesatStart
Das ist die Anzahl der Leben, mit denen ihr startet, minus eins. Wenn ihr mit einem Leben
starten wollt, müsst ihr hier $00 hinschreiben. Außerdem könnt ihr das Erhöhen von Extraleben
verhindern, indem ihr die Semikolons an den Anfängen folgender Zeilen entfernt:

;org $028ACD
;        nop #8

Wenn ihr darüber hinaus den Sternezähler komplett deaktivieren wollt (so, dass ihr auch
nicht mehr ins Bonuslevel kommt), dann müsst ihr die Semikolons an den Anfängen folgender
Zeilen entfernen:

;org $05CF1B
;        nop #3
;
;
;org $009E4B
;        nop #3


!Damage
So viel Schaden erhält ihr von normalen Sprites. Ihr könnt auch bei jedem Sprite einen
individuellen Schaden festlegen. Ich habe dem Patch als Demonstration eine modifizierte
Version von ICB's Poison Goomba hinzugefügt. Anders als mit meinem seinem Patch müsst ihr
mit meinem Patch den Code ÜBER die Mario <-> Sprite Interaction Routine tun. Das war
zumindest die einzige Stelle, wo's für mich funktioniert hat. Ich muss noch hinzufügen,
dass ich noch nie Custom Sprites gemacht habe und davon keine Ahnung habe. Hier ist jedenfalls
der Code:

lda #$02
sta HurtFlag           ;standardweise $0670
lda #DamageHighByte
sta FreeramHighByte    ;standardweise $0061
lda #DamageLow
sta FreeramLow         ;standardweise $0060


!StartMaxHealth
Die maximalen HP, mit denen ihr beginnt. Können maximal 999 ($03E7) sein.


!StartMaxMP
Die maximalen MP, mit denen ihr beginnt. Können maximal 99 ($63) sein.


!RefillMPAfterDeath
Stellt das auf $00 damit eure MP wenn ihr stirbt nicht aufgefüllt werden, ansonsten stellt
ihr eine beliebige andere Zahl ein.


!LosePowerupAfterDeath
Stellt das auf $00 damit ihr euer Powerup behält, wenn ihr stirbt, anderfalls stellt
ihr eine beliebige andere Zahl ein.


!MushroomHeal
So viele HP heilt ein normaler Pilz (in Hex).


!MPHeal
So viele MP regeneriert ein 1UP-Pilz (in Hex).


!FireballMP
So viele MP verbraucht ein Feuerball ($00 zum deaktivieren).


!CapeMP
So viele MP verbraucht Fliegen ($00 zum deaktivieren).


!FloatRequiresMP
Stellt das auf $00 ein, damit Schweben keine MP erfordert. Wenn ihr es auf eine beliebige
andere Zahl einstellt, erfodert Schweben so viele MP, wie unter !CapeMP angegeben
(trotzdem verliert ihr keine MP, wenn ihr schwebt)

 
!SpinMP
So viele MP verbraucht eine Cape-Umdrehung ($00 zum deaktivieren).


!FlyReduceSpeed
Geschwindigkeit, mit der eure MP beim Fliegen sinken. Je höher der Wert, desto langsamer
sinken eure MP. $32 entspricht etwa einer Sekunde.


;;;;;;;;;;;;;;;
;Bekannte Bugs;
;;;;;;;;;;;;;;;

-Wenn ihr ein neues Spiel startet und das Intro überspringt, wird Mario auf der Overworld
 als Game Over angezeigt (das behebt sicher aber von selbst, sobald ihr ein Level bertretet)


;;;;;;;;;;;;;;;
;Zukunftspläne:
;;;;;;;;;;;;;;;

Es gibt noch eine Menge Sachen, die ich ein zukünftigen Versionen des Patches implementieren
will:

-Mit dem Select-Knopf durch Powerups switchen, die man schon mal bekommen hat. Das bietet
 sich besonders an, da das Status Bar Item deaktiviert ist und der Select-Knopf somit
 sowieso keine Verwendung mehr findet. Außerdem würde das das Spiel auch mehr wie ein RPG
 aussehen lassen.
-Noch mehr Sachen hinzufügen, die MP verbrauchen (z.B. Drehsprung, Unbesiegbarkeit,
 Beschwörung von Yoshi usw.)
-Ein EXP-System hinzufügen (Wenn ihr eine bestimmte Anzahl an Monstern getötet habt, erhöhen
 sich eure Max HP und Max MP)
-Toleranzsystem (Der Schaden, den ihr nimmt, variiert in einem Intervall von +/-15%)


;;;;;;;;;
;Kontakt;
;;;;;;;;;

Falls ihr Fragen habt, Anregungen, Kritik, Lob oder Bugs gefunden habt, dann kontaktiert mich
doch einfach!

E-Mail:      markus_wall@web.de
ICQ:         354-382-300
MSN:         rpg_hacker@hotmail.de
SMW Central: RPG Hacker
YouTube:     RPGHacker86


;;;;;;;;;;;;;;;
;Besonder Dank;
;;;;;;;;;;;;;;;

-FPI, dafür, dass er mich seine Status Bar GFX nutzen lässt
-Mert, dafür, dass er mich seinen Mario Kopf nutzen lässt
-Leufte bei SMWC, TMN, SMWH und YouTube, die meinen Patch kommentieren


;;;;;;;;;;;;;;;;;
;Version History;
;;;;;;;;;;;;;;;;;
Version 1.2 - 1.11.2015
-asar (medic)
Version 1.1 - 21.07.2009

-Bowser Bug behoben (verglichter Mario Kopf)
-Iggy/Larry Bug behoben (sofortiger Tod bei Treffer)
-Einige Fehler auf Wii und DS behoben
-"MP werden bei Tod nicht aufgefüllt" Option hinzugefügt
-"Powerup geht beim Tod nicht verloren" Option hinzugefügt
-"Schweben erfordert keine MP" Option hinzugefügt
-Neue GFX Files hinzugefügt
-Introlevel muss jetzt in der ASM-Datei eingestellt werden
-Flugroutine verbessert
-SRAM Support verbessert


Version 1.0 - 19.07.2009

-Release Hauptpatch
