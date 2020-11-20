# Clock Domain Crossing
This project is dedicated to the various implementations of clock domain crossing (CDC) solutions available to FPGA design. 

## Inspiration/Bibliography

The following bullet points outline the websites that provided inspiration and information into the topic of "clock domain crossing"

-   [EDN_synch_techniques](https://www.edn.com/electronics-blogs/day-in-the-life-of-a-chip-designer/4435339/Synchronizer-techniques-for-multi-clock-domain-SoCs)
-   [Clock_domain_crossing](https://filebox.ece.vt.edu/~athanas/4514/ledadoc/html/pol_cdc.html)
-   [Understanding_clock_domain_crossing_issues](http://www.gstitt.ece.ufl.edu/courses/eel4712/lectures/metastability/EEIOL_2007DEC24_EDA_TA_01.pdf) pg4B
-   [14_ways_to_fool_your_sync](https://webee.technion.ac.il/~ran/papers/Metastability%20and%20Synchronizers.posted.pdf)
-   ~~work~~

## The Clock Domain Crossing Problem

In digital design there is a requirement to transfer data from one clock domain (source) to another (destination). When the source and destination clock are asynchronous to each other the following problems may occur :- 1. Metastability; 2. Data Loss; 3. Data incoherency. **What does this mean in granularity?** 

***What is data?*** 

Data is the plural of datum. Datum is a piece of information. Therefore in order to hold data a computer needs a data storage element - <u>memory</u>.

 ***How is memory implemented in the world of electronics?***

Back in 1886 Charles Sanders Peirce described how logic operations (logic gates) could be carried out by electrical switching circuits. Over the years electrical switching has been implemented by relays, valves and semiconductors. 

Furthermore we discovered that by combining the logic gates together we were able to create flip flops. Flip flops offered the ability to latch or store information by holding a state because they are sequential logic. Therefore some clever chap saw flip flops potential as a data storage element.

To create some sense of order between all the different data storage elements control inputs were added. The clock input is a control input which keeps an array of data storage elements synchronous to one and each other by allowing <u>changes only at discrete time intervals</u>.

***What happens when the data is changing between  setup/hold times?*** 

When data is transferred from a source clock operating at x Hz to a destination clock domain operating at y Hz. There is a probability that the source domain change from logic :one: to logic :zero: or vice a versa happens when the destination domain is not in a position to receive data. This leads to a setup or hold violation at the destination flip flop. As a result, the destination FF output signal may oscillate for an indefinite amount of time (<u>metastability</u>)

***What happens if this metastability propagates?***

The unstable output could lead to 

1. High current flow & burnout.
2. The various fanouts could be interpreted differently, leading to unexpected behaviour.
3. Settling at incorrect value and introducing latency/propagation delay.

***What happens if source data changes before being resolved in the destination?***

Recall metastability generates an unstable signal in the destination domain that could settle correctly or incorrectly. The source clock needs to hold the signal correct for a long enough period so that the destination clock can sample it correctly. The destination clock can reach the correct signal after either 1 or more clocks and this could change per each transaction. Therefore any change in the source clock that happens faster than a valid sample in the destination clock can lead to <u>data lost</u>.

***What happens when we multiple the signals involved?***

When dealing with a parallel bus, some source domain changes may be captured correctly whereas others might not because of metastability settling on each signal. If this now incorrect destination bus is propagated then the data becomes <u>incoherent</u>.

**SO HOW DO WE PREVENT THESE PROBLEMS?**

Please view CDC techniques listed below. In summary multi-flop synchronisers remove metastability but are still vulnerable to data incoherency. Therefore use multi-flops on scalar signals.

If 




## CDC Techniques

The following tasklist shows the CDC techniques implemented/to be implemented within this repository.

- [x] [FF Synchroniser](./ff_sync)
- [x] Toggle Synchroniser
- [x] Handshake Based Pulse Synchroniser
- [ ] Mesochronous synch
- [ ] Gray Code for multibit pointers/counters
- [ ] Mux Synchroniser
- [ ] Handshake Synchroniser
- [ ] Asynchronous Fifo Synchroniser
eof

