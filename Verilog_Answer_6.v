


module majority16 (Out, Data);
  input [0:15] Data;
  output Out;
  reg [0:4] count, i;

  assign Out = count > 5'b1000 ? 1 : 0;

  always @ (Data) begin
    count = 5'b0;
    for (i=0; i<= 15; i=i+1)
      if (Data[i] == 1) count = count + 1;
  end
endmodule
//Testbench
module majority16_test;
  reg [0:15] Data;
  wire Out;
  
  parameter STDIN = 32'h8000_0000;
  integer testid;
  integer ret;
  
  majority16 m16 (Out, Data);
  

  initial begin
      ret = $fscanf(STDIN, "%d", testid);
      case(testid)
	  0: begin #5 Data=16'b1001000101111101; end 
	  1: begin #5 Data=16'b0101010101010101; end
	  2: begin #5 Data=16'b1111001101010101; end
	  3: begin #5 Data=16'b0010111111011110; end
	  4: begin #5 Data=16'b1111111111111111; end
	  5: begin #5 Data=16'b1111010110101111; end
	  6: begin #5 Data=16'b1111100000110000; end
	  7: begin #5 Data=16'b0; end
       default: begin
	    $display("Bad testcase id %d", testid);
	    $finish();
	  end
      endcase
      #5;
	 if ( (testid == 0 && Out == 1'b1) || (testid == 1 && Out == 1'b0) ||
	      (testid == 2 && Out == 1'b1) || (testid == 3 && Out == 1'b1) || 	
	      (testid == 4 && Out == 1'b1) || (testid == 5 && Out == 1'b1) || 	
	      (testid == 6 && Out == 1'b0) || (testid == 7 && Out == 1'b0))
	  pass();
	else
	  fail();
  end
  task fail; begin
    $display("Fail: Data=%b => Out!=%b", Data, Out);
    $finish();
    end
  endtask
  task pass; begin
    $display("Pass: Data=%b => Out=%b", Data, Out);
    $finish();
    end
  endtask
endmodule