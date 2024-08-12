
module div_datapath_ctrl (
  input wire Start,
  output wire LoadN,
  output wire LoadP,
  output wire Clear,
  output wire IncQ,
  output wire Stop,
  input wire Clk,
  input wire PgtN,
  input wire [7:0] Data_in,
  output wire [7:0] Nw,
  output wire [7:0] Qw
);

  reg [7:0] N;
  reg [7:0] P;
  reg [7:0] Q;
  reg [2:0] state;

  always @(posedge Clk) begin
    if (Start)
      state <= 3'b000;
    else if (state == 3'b000 && PgtN)
      state <= 3'b001;
    else if (state == 3'b001 && ~PgtN)
      state <= 3'b010;
    else if (state == 3'b010)
      state <= 3'b011;
    else if (state == 3'b011 && ~PgtN)
      state <= 3'b100;
  end

  always @(posedge Clk) begin
    if (Clear)
      N <= 8'b0;
    else if (LoadN)
      N <= Data_in;
    else if (LoadP)
      P <= Data_in;
    else if (IncQ && PgtN)
      Q <= Q + 1;
    else if (LoadS && PgtN)
      N <= N - P;
  end

  assign Nw = N;
  assign Qw = Q;
  assign LoadN = (state == 3'b000);
  assign LoadP = (state == 3'b010);
  assign Clear = (state == 3'b011);
  assign IncQ = (state == 3'b001) || (state == 3'b011);
  assign Stop = (state == 3'b100);

endmodule

module div_by_sub_test;
  reg Clk;
  reg Start;
  wire PgtN;
  wire LoadN, LoadP, Clear, IncQ, Stop;
  wire [7:0] Data_in;
  wire [7:0] Nw, Qw;

  // Instantiate the divider datapath and controlpath modules
  div_datapath_ctrl DP (
    .Start(Start),
    .LoadN(LoadN),
    .LoadP(LoadP),
    .Clear(Clear),
    .IncQ(IncQ),
    .Stop(Stop),
    .Clk(Clk),
    .PgtN(PgtN),
    .Data_in(Data_in),
    .Nw(Nw),
    .Qw(Qw)
  );

  // Clock generation
  always begin
    #5 Clk = ~Clk;
  end

  // Test case 1: n = 53 and p = 23
  initial begin
    Clk = 0;
    Start = 1;
    Data_in = 53;
    #10 Start = 0;
    #300;
    if (Nw === 7 && Qw === 2 && Stop === 1) begin
      $display("Test Case 1: Passed");
    end else begin
      $display("Test Case 1: Failed");
    end
    $finish;
  end

  // Add test cases for other inputs here

endmodule

//Testbench
module div_by_sub_test;
    reg [7:0] Data_in, N_prev;
    reg Clk, Start;
    wire Stop;
    
    parameter STDIN = 32'h8000_0000;
    integer testid;
    integer ret;

    div_datapath DP (PgtN, LoadN, LoadS, LoadP, Clear, IncQ, Data_in, Clk);
    div_ctrlpath CP (LoadN, LoadS, LoadP, Clear, IncQ, Stop, Clk, PgtN, Start);

    initial Clk = 1'b0;
    always #5 Clk = ~Clk;
      
    initial 
        begin
            ret = $fscanf(STDIN, "%d", testid);
	    case(testid)
	        0: begin
                       #2 Start = 1; #20 Data_in = 53; #10 Data_in = 23; N_prev = DP.Nw;
                       #30; 
                   end
	        1: begin
                       #2 Start = 1; #20 Data_in = 16; #10 Data_in = 3; N_prev = DP.Nw;
                       #60; 
                   end
	        2: begin
                       #2 Start = 1; #20 Data_in = 21; #10 Data_in = 31; N_prev = DP.Nw;
                      #10; 
                   end
	        3: begin
                       #2 Start = 1; #20 Data_in = 234; #10 Data_in = 234; N_prev = DP.Nw;
                       #40; 
                   end
	        4: begin
                       #2 Start = 1; #20 Data_in = 59; #10 Data_in = 11; N_prev = DP.Nw;
                       #60;  
                   end
	        5: begin
                       #2 Start = 1; #20 Data_in = 0; #10 Data_in = 14; N_prev = DP.Nw;
                       #10;
                   end
	        6: begin
                       #2 Start = 1; #20 Data_in = 250; #10 Data_in = 15; N_prev = DP.Nw;
                       #170;  
                   end
	        7: begin
                       #2 Start = 1; #20 Data_in = 15; #10 Data_in = 250; N_prev = DP.Nw;
                       #10;  
                   end
                default: begin
			     $display("Bad testcase id %d", testid);
			     $finish();
			 end
	    endcase
   	    if ((testid == 0 && DP.Qw == 2 && DP.Nw == 7 && Stop == 1) || (testid == 1 && DP.Qw == 5 && DP.Nw == 1 && Stop == 1) ||
		(testid == 2 && DP.Qw == 0 && DP.Nw == 21 && Stop == 1) || (testid == 3 && DP.Qw == 1 && DP.Nw == 0 && Stop == 1) || 
		(testid == 4 && DP.Qw == 5 && DP.Nw == 4 && Stop == 1) || (testid == 5 && DP.Qw == 0 && DP.Nw == 0 && Stop == 1) ||
		(testid == 6 && DP.Qw == 16 && DP.Nw == 10 && Stop == 1) || (testid == 7 && DP.Qw == 0 && DP.Nw == 15 && Stop == 1))
			pass();
		else
			fail();
	end


	task fail; 	begin
			  $display("Fail: (n = %d and p = %d) => (q != %d and  r != %d)", N_prev, DP.Pw, DP.Qw, DP.Nw);
			  $finish();
			end
	endtask

	task pass; 	begin
			  $display("Pass: (n = %d and p = %d) => (q = %d and  r = %d)", N_prev, DP.Pw, DP.Qw, DP.Nw);
			  $finish();
			end
	endtask
endmodule