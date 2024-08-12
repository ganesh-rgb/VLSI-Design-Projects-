



module dlock (unlock, b_in, clear, clk);
   input b_in, clear, clk;
   output reg unlock;
      
   reg [2:0] state; // The machine states 
   parameter S0=3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100, S5=3'b101, S6=3'b110, S7=3'b111; 
      
   always @(negedge clk or clear) begin
        if (clear == 0) state <= S0;
        else case (state)
            S0: state <= b_in ? S1 : S7;
 	        S1: state <= b_in ? S7 : S2;
	        S2: state <= b_in ? S3 : S7;
 	        S3: state <= b_in ? S4 : S7;
	        S4: state <= b_in ? S7 : S5;
	        S5: state <= b_in ? S7 : S6;
	        S6: state <= S6;
	        S7: state <= S7;
                default: state <= S0;
        endcase
   end
   always @(state) begin  
      case (state)
            S0, S1, S2, S3, S4, S5, S7: unlock = 0;
            S6: unlock = 1;
      endcase
   end
endmodule
//Testbench
module dlock_test;
    reg b_in, clear, clk;
    reg [5:0] seq;
    wire unlock;
    reg [3:0] cycles;
    parameter STDIN = 32'h8000_0000;
    integer testid;
    integer ret;

    dlock dut (unlock, b_in, clear, clk);

    initial clk = 1'b0;
    always #5 clk = ~clk;
      
    initial 
        begin
            ret = $fscanf(STDIN, "%d", testid);
	    case(testid)
	        0: begin
                       #5 seq = 6'b110100; clear = 0; 
                       #5 clear = 1; b_in = 1'b1; #10 b_in = 1'b1; #10 b_in = 1'b0; #10 b_in = 1'b1; #10 b_in = 1'b0; #10 b_in = 1'b0; 
                       cycles = $time/ 10;
                   end
	        1: begin
                       #5 seq = 6'b101100; clear = 0; 
                       #5 clear = 1; b_in = 1'b1; #10 b_in = 1'b0; #10 b_in = 1'b1; #10 b_in = 1'b1; #10 b_in = 1'b0; #10 b_in = 1'b0; 
                       cycles = $time/ 10;
                   end
	        2: begin
                       #5 seq = 6'b101100; clear = 0; 
                       #5 b_in = 1'b1; #10 b_in = 1'b0; #10 b_in = 1'b1; #10 b_in = 1'b1; #10 b_in = 1'b0; #10 b_in = 1'b0; 
                       cycles = $time/ 10;
                   end
	        3: begin
                       #5 seq = 6'b111111; clear = 0; 
                       #5 clear = 1; b_in = 1'b1; #50; 
                       cycles = $time/ 10; 
                   end
	        4: begin
                       #5 seq = 6'b101101; clear = 0; 
                       #5 clear = 1; b_in = 1'b0; #10 b_in = 1'b0; #10 b_in = 1'b1; #10 b_in = 1'b1; #10 b_in = 1'b0; #10 b_in = 1'b1; 
                       cycles = $time/ 10;
                   end
	        5: begin
                       #5 seq = 6'b000000; clear = 0; 
                       #5 clear = 1; b_in = 1'b0; #50; 
                       cycles = $time/ 10; 
                   end
	        6: begin
                       #5 seq = 6'b001101; clear = 0; 
                       #5 clear = 1; b_in = 1'b0; #10 b_in = 1'b0; #10 b_in = 1'b1; #10 b_in = 1'b1; #10 b_in = 1'b0; #10 b_in = 1'b1; 
                       cycles = $time/ 10;
                   end
	        7: begin
                       #5 seq = 6'b111111; clear = 0; 
                       #5 clear = 1; b_in = 1'b1; #10 b_in = 1'b1; #10 b_in = 1'b1; #10 b_in = 1'b1; #10 b_in = 1'b1; #10 b_in = 1'b1; 
                       cycles = $time/ 10;
                   end
                default: begin
			     $display("Bad testcase id %d", testid);
			     $finish();
			 end
	    endcase
            #5;
		if ( (testid == 0 && unlock === 1'b0) || (testid == 1 && unlock === 1'b1) ||
		(testid == 2 && unlock === 1'b0) || (testid == 3 && unlock === 1'b0) || 
		(testid == 4 && unlock === 1'b0) || (testid == 5 && unlock === 1'b0) ||
		(testid == 6 && unlock === 1'b0) || (testid == 7 && unlock === 1'b0))
			pass();
		else
			fail();
	end


	task fail; 	begin
			  $display("Fail: (clock cycles=%d input = %b, clear=%b) =>  unlock != %b", cycles, seq, clear, unlock);
			  $finish();
			end
	endtask

	task pass; 	begin
			  $display("Pass: (clock cycles=%d input = %b, clear=%b) =>  unlock = %b", cycles, seq, clear, unlock);
			  $finish();
			end
	endtask
endmodule