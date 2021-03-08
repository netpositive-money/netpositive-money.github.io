---
title: Bitcoin CO2 Footprint Calculator
type: calculator
---

The following graph shows the development of Bitcoin mining total CO2 emissions
in megatons per month. It is derived from electricity consumption data provided
by the [Cambridge Centre for Alternative Finance](https://cbeci.org/) by
multiplication with a factor taken from a [paper by Stoll et al.](sources#thecarbonfootprintofbitcoin).

<co2graph></co2graph>

The second graph shows the total amount of CO2 emitted by Bitcoin miners
obtained by summing up the above data. You can restrict the calculation to a
time interval by clicking and dragging or entering the start and end months
below.
                                   
<co2totalgraph></co2totalgraph>                                   

<inputstart 
 text = "start month: "
>
</inputstart>

<inputend
  text = "end month: "
>
</inputend>

Selected: <selectionstart></selectionstart> to <selectionend></selectionend>

Total CO2 emitted in this time frame: <totalco2></totalco2> Mt.

Per BTC when divided by the total amount of bitcoin in existence at the time: <perbtc></perbtc> t.

<inputbtc
 text="How many bitcoin do you want to offset? "
>
</inputbtc>

<outputtons
 text="This is equivalent to "
>
</outputtons>
Happy offsetting, and don't forget to tell us about it so we can keep count!


The horizontal line at <outputoffset></outputoffset> Mt signifies the amount of CO2 that has already been offset today. Calculated from the Genesis block at January 3, 2009, this means we've offset Bitcoin's history approximately until <offsetdate></offsetdate>.



