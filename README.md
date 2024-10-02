ASIC DESIGN FLOW



<img src = "https://drive.google.com/file/d/1Xqve1NpeARllZkAo9B23l7xlJ78Ip4-X/view">
 

##1)	Chip Specification:
It is the initial stage of the chip, where the engineer should read the specifications with design guidelines of ASIC and define the features, microarchitecture, functionalities of  whole system.
At this stage, Design engineer is responsible for generating RTL code and Verification Engineer write the Test bench to verify functionality of system.

###2)	 Functional Verification:
At this stage, both Design and Verification Teams perform Behavioral simulation, In this simulation, once the writing of RTL code is completed, a lot of code coverage metrics proposed for HDL. Verification Engineer aim to verify correctness of the code with the help of Test cases and trying to achieve it by 95% coverage Test. This code coverage includes statement coverage, expression coverage, branch coverage, toggle coverage

There are two types of simulation tools:

Functional Simulation tools: These tools are used to verify the logical behavior, and its implementation based on design entry.

Timing simulation tools: These tools are used to verifies whether the design meets the timing requirement and confirms the design is free of signal delays & bugs

####3)	RTL Synthesis/ RTL Function:

 <img src = "https://drive.google.com/file/d/1jScO5kVYxkYLmMC0PE8-l8RpgTQc9e9J/view">
Once the RTL code and Test bench are generated , the RTL engineer works n RTL Description -  they translate the RTL code into a gate level  netlist using  a logical synthesis tool  that meets required timing constraints. Thereafter, a synthesized database of the ASIC design is created in the system. When timing constraints are met with the logic synthesis, the design proceeds to the DFT techniques.
#####4)	Chip Partitioning

At this stage, engineers adhere to the ASIC Design Layout requirements and specifications to construct its structure using EDA tools and established methodologies. This design structure will be verified using high-level languages such as C++ and System C.
After comprehending the design specifications, engineers divide the entire ASIC into multiple functional blocks, considering optimal performance, technical feasibility, and resource allocation in terms of area, power, cost, and time. Once all functional blocks are documented in the architectural plan, engineers need to brainstorm ASIC design partitioning by reusing IPs from previous projects and sourcing them from other parties.


######5)	DFT insertion:

With the ongoing trend of lower technology nodes, there is an increase in SOC variations like size, threshold voltage and wire resistance, Due to these factors, new models and techniques are introduced to high-quality testing.

ASIC design is complex enough at different stages of the design cycle. Telling the customers that the chips have fault when you are already at the production stage is embracing and disruptive . It’s a situation that no engineering team wants to be in. In order to overcome this situation, design for test is introduced with a list of techniques.

•	Scan path insertion: A methodology of linking all registers elements into one long shift register (scan path). This can help to check small parts of design instead of whole design in one go.

•	Memory BIST (Built-in Self-Test):  In the lower technology node, chip memory requires lower area a fast access time. MBIST is a device which is used to check RAMs. It is a comprehensive solution to memory testing errors and self-repair proficiencies.

•	APTG(Automatic Test Pattern Generation): APTG is a method of creating test vector/sequential input patterns to check the design for faults generated within various elements of circuit.

#######6)Floor Planning(Blueprint of chip):
 After DFT, the physica implementation process is to be followed. In physical design, the first step in  RTL-to-GDS-II is floor planning. It is the process of placing blocks in the chip. It includes: block placement, design portioning, pin placement, and power optimization.

Floorplan determines the size of the chip, places the gates and connects them with wires. While connecting, engineers take care of the wire length, and functionality which will ensure signals will not interfere with	near by elements. In the end, simulate the final floor plan with post-layout verification process.

A good floor planning exercise should come across and take care of the below points; otherwise, the life of IC and its cost will blow out;
•	Minimize the total chip area
•	Make routing phase easy(routable)]
•	Improve signal delays
########7)Placement
Placement is the process of placing standard cells in ow. A poor placement requires larger area and also degrades performance. Various factors like the timing requirement, the net lengths and hence the connections of cells, power dissipations should be taken care. It removes timing violation.
#########8) Clock Tree Synthesis:
Clock tree synthesis is a process of building the clock tree and meeting the defined timing ,area and power requirements. It helps in providing the clock connection to the clock pin of a sequential element in the required time and area, with low power consumption.
To avoid high power consumption, increase in delays and a huge number of transitions, certain structures can be used for optimizing CTS structures such as 
•	Mesh
•	H-Tree
•	X-Tree
•	Fishbone
•	Hybrid
With the help of these structures, each flop in the clock tree gets the clock connection. During the optimization, tools insert the buffer to build the CTS structure. Different clock structures will build the clock tree with a minimum buffer insertion and lower power consumption of chips.

##########9)Routing:
There are two  types of routing in ASIC design flow
1)Global Routing: It calculates estimated Values for each net by the delays of fan-out f wire. Global routing is mainly divided into line routing and maze routing.
2)Detailed Routing: It detailed routing, the actual delays of wire is calculated by various optimization, clock tree synthesis etc….
As we are moving towards a lower technology node, engineers face complex design challenges with the need for implanting millions of gates in a small area. In order to make this ASIC design routable, placement density range needs to be followed for better QoR. Placement density analysis is an important parameter to get better outcomes with less number of iterations.

###########10)Final Verification (Physical Verification & Timing)
After routing, ASIC design layout undergoes three steps of physical verification, known as sign off checks. This stage helps to check whether  the layout working the way it was designed to. The following  checks are followed to avoid any errors just before the tape out.

1)Layout Versus Schematic(LVS): is a process of checking hat the geometry/layout matches the schematic /netlist.
2)Design rule checks(DRC)  is the process of checking that the geometry in the GDS file follows the rules given by the foundry.
3)Logical Equivalence Check(LVC): is a process of equivalence check between pre and post design layout.

############11) GDS-II Graphical Data stream information interchange
In the last stage of the tape out, the engineer performs wafer processing, packaging, testing verification and delivery to the physical IC. GDSII is the file produced and used by the semiconductor foundries to fabricate the silicon and handled to client.





      





