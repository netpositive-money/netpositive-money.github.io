# FAQ

## Isn't Bitcoin useless anyway?

tl;dr: No. Hundreds of millions of people worldwide are finding it useful for a
lot of different use cases. It's a pretty arrogant stance to assume you know
better than all of them.

Bitcoin can be seen as a circuit breaker or relief valve for financial systems
everywhere. It gives people a way to circumvent financial censorship, capital
controls or inflation, and it enables permissionless access to an alternative
financial system. It cannot discriminate against people for whatever reason.
Let's look at some examples:


  * Here's a [thread](https://threadreaderapp.com/thread/1340836877595594752.html) by [Alex
Gladstein](https://twitter.com/gladstein) of the [Human Rights
Foundation](https://hrf.org/) enumerating humanitarian causes that Bitcoin has
been useful for. 
  * [As a prominent
example](https://web.archive.org/web/20201108012753/https://www.forbes.com/sites/rogerhuang/2019/04/26/how-bitcoin-and-wikileaks-saved-each-other/),
Wikileaks probably wouldn't exist anymore if it wasn't for Bitcoin enabling
donations for them when the US government pressured other payment providers into
blocking them.
  * [Here](https://medium.com/open-money-initiative/latin-american-bitcoin-trading-follows-the-heartbeat-of-venezuela-71a28cb86ba0)
    is a fascinating analysis of Bitcoin serving as a vehicle currency in Latin
    America.

If you find Bitcoin useless for yourself, you should call yourself lucky.

## I have read somewhere that every Bitcoin transaction is ["equivalent to the power consumption of an average U.S. household over 22.86 days."](https://digiconomist.net/bitcoin-energy-consumption). Is that true? Isn't that horrible?

tl;dr: Most people don't value Bitcoin as a payment mechanism, and even if they
were, most payments are not recorded on-chain. So calculating the energy cost of
a transaction is as impossible and nonsensical as it would be for gold.

It's true in a similar way that [the lack of pirates is causing global
warming](https://www.forbes.com/sites/erikaandersen/2012/03/23/true-fact-the-lack-of-pirates-is-causing-global-warming/?sh=508707043a67).
Yes, this is a valid estimation of Bitcoin mining's energy use divided by a
valid estimation of on-chain transactions, compared to a probably valid
estimation of household electricity use.

However, connecting these three figures in this way doesn't yield any insight
beyond shock and awe. That's because Bitcoin's primary value is not as a payment
network, so the number of on-chain transactions is not an interesting metric for
it. This can be seen easily: On one hand the [number of onchain
transactions](https://bitinfocharts.com/comparison/bitcoin-transactions.html)
has always been limited --- and that limit has been pretty much hit constantly
since at least 2019. On the other hand, the value of Bitcoin, as well as the
estimated number of its users, has been rising over many orders of magnitude
since 2009. How can this be possible?

  * In recent years, long term store of value has become Bitcoin's main use
    case. That is, people use it more for storing their savings than for paying
    for goods and services.
  * Its current usage is thus more comparable to gold, which is also rarely used
    in transactions. I have never seen anybody calculate the energy cost of gold
    mining plus handling divided by the number of physical gold shipments.
    Probably because that's as misleading a number as the equivalent in Bitcoin.
  * Just as with gold, there are ways to make even small transactions quickly
    and cheaply with Bitcoin. Most real-world transactions use one of these
    off-chain methods. Probably the most popular today are custodial services
    like exchanges. Sending bitcoin from one customer to another on a service
    like this just requires changing two numbers in their database and is the
    equivalent of gold in a bank changing owners. It's hard to say how many such
    transactions there are, since there are many "bitcoin banks" and their
    numbers are proprietary, but it's safe to say they dwarf on-chain
    transactions by orders of magnitude.
  * Unlike gold, there are methods of transacting Bitcoin off-chain that require
    less trust in intermediaries, such as the Lightning Network or Blockstream's
    Liquid federation. With a growing demand in transactions, such alternatives
    are refined and gain popularity, without this being reflected in the above
    numbers. With the Lightning Network, it's even difficult to estimate how
    many transactions are being performed, since there is no central ledger
    recording them all.
  
## But I have read that Visa transactions are much more economical! 
  
That's because these are very different things. Visa transactions are just a few
companies changing a few numbers in their databases. It's basically just a fancy
way of signalling an intent to spend something. It's not final. There might not
be a real transfer of value happening at all (all the "money" is still debt in
the same bank, just on another account). 

On the other hand, a Bitcoin onchain transaction is a real transfer of a bearer
instrument, comparable to a gold shipment from one central bank to another.
Those are also quite expensive, I imagine. It's total overkill if you want to
buy a coffee. For that, it might be enough to just update some numbers in a
(Bitcoin) bank. Or use the Lightning Network.
   

## Will Bitcoin boil the oceans?

tl;dr: No. It does use a lot of energy and this also leads to a lot of Co2
emissions. See the current best estimates on how much
[here](https://netpositive.money/calculator). It's hard to predict how this will
develop in the future, but it will not grow exponentially forever.

## Isn't proof-of-work useless? What is it for?

tl;dr: No. It's a subtle topic.

Adam Gibson wrote a slightly rambling but still quite elegant
[exposition](https://joinmarket.me/blog/blog/pow-a-pictorial-essay/) on this
topic. I recommend reading it. That said, here's me trying to explain it a little more concisely:

Proof-of-work is short data that allows for cheaply verifying the fact that it
was (with overwhelming probability) expensive to obtain. This short data (a 256
bit hash in Bitcoin) can also be referencing other --- often larger --- data
sets, and thus testifies those must have existed when the proof-of-work was
generated. It is serving multiple important functions in Bitcoin. I think these
are the two most irreplacable ones:

Firstly, by looking at the proof-of-work attached to multiple competing versions
of transaction history ("blockchains"), it is easy to see which history has
needed more work to write down. The version of history with most work attached
is deemed the currently valid one by all bitcoin clients. No context or other
prior knowledge is needed to verify this. As long as a client that has been
newly connected to the Bitcoin network is able to get one copy of the correct
history, no amount of falsified histories is going to mislead him, for it is
easy to spot the most expensive one. This is comparable to trusting a bank
because is has skyscrapers and lots of people working in them over any amount of
other "banks" that have just opened a stall in your street. The real bank
wouldn't go to all these lengths just to trick you into giving them your money.
Just like miners wouldn't spend giant amounts of work just to trick you by
giving you made-up version of history in which you received money that in
reality was spent to someone else.
  
Secondly, because it is very expensive to make, proof-of-work is the fairest
distributed way of distributing a new asset that we know of. In the limit,
miners spend as many dollars on hardware, energy and work as the bitcoin are
worth that they receive in return. But because there is a lot of uncertainty in
the process --- hard-to-forecast things like the number of competitors, the
price of electricity, hardware improvements and the bitcoin price can change
mining profitability drastically --- there is a often premium to be earned over
the pure cost, which keeps miners interested.

## Couldn't we just use something else like proof-of-stake or proof-of-anything-else?

tl;dr: As far as we know, there is no free lunch here. 

Proof-of-stake is very similar in concept to perpetual motion: It tries securing
an asset by making it expensive in the asset itself to forge multiple new
histories while rewarding honest behavior with the asset itself. There is no
indication that this is possible, in spite of many market participants making
claims to the contrary, just like with perpetual motion.

One popular misleading approach is making the system so complex that it is not
at all clear even to experts what security properties are even being tried to
achieve. It's possible to just define all practical problems away in theory.
When these systems are finally built, and inevitably attacks are surfacing, the
system is simply made even more complex, which might rule out one concrete
attack, but opens up several others. Notice that this slight of hand wouldn't
even be possible in a truly decentralized system like Bitcoin, because the
system [can't simply be changed](#cant-we-just-change-bitcoin) by a few insiders.

Notice too, that even if securing the ledger with proof-of-stake were feasible,
that wouldn't solve the distribution problem at all.

As for more exotic proof-of-something, there have been many claims made of "the
better Bitcoin" here as well, but alas, something has always prevented those
from making real progress. Of course, just because so many extraordinary claims
have been made and serious researchers have failed to come up with a better
system for 12 years now, doesn't mean it's impossible. Just not something we can
rely on for now.

## Can't we just change Bitcoin?
  
No. Bitcoin's most cherished value proposition is its resistance to
changing central economic properties. Proof-of-work is an important economic
principle, even if there were a technical alternative. But most importantly,
there aren't any known alternatives with similar properties.

## Can't we just ban Bitcoin?

No. It was designed to withstand opposition from state level adversaries.
Banning it would require a global totalitarian regime. Do you really want that?

## How could Bitcoin be a net positive force for the environment? 

tl;dr: It could help finance renewable energy developments, replace legacy
environmental hazards such as gold mining, incentivize people to save instead of
spend, and maybe even be the foundation of a more sustainable economic system.

Many Bitcoiners have written passionate pieces full of conviction about this
topic. Here's a [twitter thread full of
them.](https://twitter.com/mtcbtc/status/1346813481257984001?s=2) What I don't
like about most of these pieces is the utter conviction that feels really
inappropriate.

There are indeed all kinds of arguments why Bitcoin might be a net positive
force in the fight against climate change. They reach from speculative to very
speculative IMHO, but that doesn't mean they can't come true. Here's a
selection:

  * Bitcoin miners are seeking out the cheapest forms of electric energy on the planet, pretty much independent of location, and are guaranteeing a minimum price for it. 
    
    This can have many interesting consequences: It builds more market demand for research and deployment of new energy sources. But without regulatory oversight, this might also make fossil energy sources even more profitable.
        
    So far, we have seen tentative examples of both: Miners have been used to [finance overprovisioning of renewable energy](https://www.forbes.com/sites/christopherhelman/2020/05/21/how-this-billionaire-backed-crypto-startup-gets-paid-to-not-mine-bitcoin/?sh=2a5016a87596) as well as [reactivating formerly unprofitable oil fields](https://www.upstreamdata.ca/post/saving-stranded-gas-distributed-bitcoin-mining-to-the-rescue).
    
  * Bitcoin might replace parts of the legacy financial system including gold mining. 
    
    Gold mining is an environmentally hazardous process and might become less profitable if Bitcoin takes over part of the market premium that gold commands now. 
    
  * Bitcoin is implementing the idea of sound money. That is, the Bitcoin supply is scarce (even more predictably than gold). This implies that it should always become more valuable over time. Therefore, saving Bitcoin is more appealing than saving fiat money, which tends to become less valuable over time. 
    
    In order not to depreciate, fiat money always has to be invested. But every investment carries both risk and environmental costs. Bitcoin might become an alternative that is both less risky (in the long run) and less environmentally problematic than the average investment. Thus, people might be incentivized to hold Bitcoin over longer time frames, and this holding time might be, say, less carbon intensive, than having the same amount of buying power being spent potentially multiple times in the economy.
        
  * From it's inception, Bitcoin has been a counter movement to the legacy banking system built on credit expansion. Many people see this system of money production as a key driver for inequality, unlimited economic growth and environmental hazards. Bitcoin might be the foundation of a different system that could address some of these problems differently.

## If Bitcoin could be eventually helpful against climate change, why do you want to do anything at all?
  
Notice the COULD. It means these visions are both uncertain and certainly not
realized today. Climate change is a problem today and needs to be addressed
ASAP. Even if Bitcoiners' visions of a better world through better money come
true, it certainly won't be overnight, and it might be too late. In the
meantime, there is no question that Bitcoin mining does contribute to climate
change today.
That's why we want to act now.  

## How could we help fight against climate change?
  
Bitcoin is money. Bitcoiners --- hodlers, miners, exchanges, businesses --- are
making money. Money can help solve problems. So we want to encourage you to give
some of that money to causes that you believe can make a difference in the fight
against climate change. And tell us about it, so we can count it, and one day
tell the world that we are sure that Bitcoin is a net positive money.
  
## Where can I donate?

We do not want to take your money. In the spirit of Bitcoin, this is a voluntary
and decentralized effort. So ideally, you select the cause and the amount you
want to give, estimate the amount of Co2 offset, and report that to us, as
anonymously or publicly as you want. In order to make that easier for you, we are
curating a list of charities that we believe are helpful and that work with us to
automatically report the numbers so we can measure our impact as bitcoiners. And
we have made the [calculator page](https://netpositive.money/calculator) to give
you an idea of how much Co2 you might want to offset.

In general, we'd recommend indexing risk by donating (as a community) to a wide
array of initiatives with different approaches. You can just select those that
you find most appealing. If they aren't on our list, just contact us to let us
know that you want to give to them. If they meet our standards for inclusion,
we'll gladly add your contribution to the total and maybe even add them to our
recommendation list.

## How much money are we talking about?

Looking at the [calculator page](https://netpositive.money/calculator), the
current estimate of total Co2 emitted by bitcoin mining in its lifetime is close
to 100 Mt. Classical offsetting measures or carbon credits would price this at
about \$20 per ton of Co2 or \$2 billion. Which is less than 0.4% of the current
value of all bitcoins in existence, or about $120 per Bitcoin.

However, as you can see on our list of charities, there are initiatives that
promise a much higher impact per dollar invested, to the tune of far less than
\$1 per ton of Co2. These tend to be a little more speculative in nature, in
that there is more variance in the expected amount offset, which should be OK if
we don't put all our eggs in one basket.

So it does seem reasonable that we might reach our goal of Bitcoin being a
certified net positive money with less than \$100 million in total donations.
Which is less than 0.02% of the value of all bitcoins, or about $6 per Bitcoin.

Annual figures tend to be at about a third of the total lifetime amount at the
current growth rate.

## Is that a lot?

Not really, considering that fiat money is losing value at a rate of at least 2%
per year. Or that Bitcoiners are already giving [\$300 million per
year](https://www.thegivingblock.com/) to nonprofits.

