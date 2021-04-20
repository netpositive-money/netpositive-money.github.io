---
title: Bitcoin CO2-Fußabdruck-Rechner
type: calculator
---

Die folgende Grafik zeigt die Entwicklung der gesamten CO2-Emissionen des Bitcoin-Minings in Megatonnen pro Monat. Sie wird abgeleitet von Stromverbrauchsdaten, die vom [Cambridge Centre for Alternative Finance](https://cbeci.org/) zur Verfügung gestellt werden, durch Multiplikation mit einem Faktor, der aus einem wissenschaftlichen Aufsatz von [Stoll et al.](de/sources#thecarbonfootprintofbitcoin) stammt.

<co2graph></co2graph>

Die zweite Grafik zeigt die Gesamtmenge an CO2, die von Bitcoin-Minern emittiert wurde, und wird durch Aufsummieren der obigen Daten berechnet. Du kannst die Berechnung auf ein Zeitintervall beschränken, indem Du die Grafik anklickst und mit der Maus ziehst. Alternativ kannst Du unten den Start- und Endmonat eingeben.

<co2totalgraph></co2totalgraph>

<inputstart text="Startmonat: ">
</inputstart>

<inputend text="Endmonat: ">
</inputend>

Ausgewählt: von <selectionstart></selectionstart> bis <selectionend></selectionend>

Gesamter CO2-Ausstoß für den ausgewählten Zeitrahmen: <totalco2></totalco2> Mt

Pro BTC, also geteilt durch die Gesamtmenge der zu diesem Zeitpunkt existierenden Bitcoin: <perbtc></perbtc> t

<inputbtc text="Wieviele Bitcoin willst Du kompensieren? ">
</inputbtc>

<outputtons text="Das entspricht ">
</outputtons>
Viel Spaß beim Kompensieren, und vergiss nicht, uns davon zu berichten, damit wir mitzählen können!


Die horizontale Linie bei <outputoffset></outputoffset> Mt markiert die Menge an CO2, die heute bereits ausgeglichen wurde. Gerechnet vom Genesis-Block am 3. Januar 2009 an bedeutet dies, dass wir die Geschichte von Bitcoin ungefähr bis zum <offsetdate></offsetdate> ausgeglichen haben.



