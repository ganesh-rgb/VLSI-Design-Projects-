
module half_sub (Diff, Bout, X, Y);

  input  X, Y;
  output Diff, Bout;

  assign Diff = X ^ Y;
  assign Bout = (~X) & Y;
endmodule

module full_sub_3bit (Sub, BO, A, B, BI);

  input  [2:0] A, B;
  input BI;

  output [2:0] Sub;
  output BO;
 
  wire [2:0] td; 
  wire [5:0] t;
  wire [1:0] tbo;
 
  half_sub h0 (td[0], t[0], A[0], B[0]);
  half_sub h1 (Sub[0], t[1], td[0], BI);
  or o1 (tbo[0], t[0], t[1]); 
  half_sub h2 (td[1], t[2], A[1], B[1]);
  half_sub h3 (Sub[1], t[3], td[1], tbo[0]);
  or o1 (tbo[1], t[2], t[3]); 
  half_sub h4 (td[2], t[4], A[2], B[2]);
  half_sub h5 (Sub[2], t[5], td[2], tbo[1]);
  or o1 (BO, t[4], t[5]); 
endmodule
//Testbench
module full_sub_3bit_test;

  reg [-1:1] A, B;
  reg BI;
  wire [2:0] Sub;
  wire BO;

  parameter STDIN = 32'h8000_0000;
  integer testid;
  integer ret;

  full_sub_3bit fs (Sub, BO, A, B, BI);
  
  initial begin
      ret = $fscanf(STDIN, "%d", testid);
      case(testid)
	  0: begin #10 A=0; B=4; BI=0; end
	  1: begin #10 A=0; B=2; BI=1; end
	  2: begin #10 A=5; B=1; BI=0; end
	  3: begin #10 A=6; B=3; BI=1; end
	  4: begin #10 A=7; B=7; BI=0; end
	  5: begin #10 A=5; B=5; BI=1; end
	  6: begin #10 A=7; B=0; BI=0; end
	  7: begin #10 A=4; B=3; BI=1; end
       default: begin
	    $display("Bad testcase id %d", testid);
	    $finish();
	  end
      endcase
      #5;
	 if ( (testid == 0 && {BO,Sub} == 4'b1100) || 
	      (testid == 1 && {BO,Sub} == 4'b1101) ||
	      (testid == 2 && {BO,Sub} == 4'b0100) || 	
	      (testid == 3 && {BO,Sub} == 4'b0010) || 	
	      (testid == 4 && {BO,Sub} == 4'b0000) || 	
	      (testid == 5 && {BO,Sub} == 4'b1111) || 	
	      (testid == 6 && {BO,Sub} == 4'b0111) || 	
	      (testid == 7 && {BO,Sub} == 4'b0000))
	  pass();
	else
	  fail();
  end
  task fail; begin
    $display("Fail: A=%b, B=%b, BI=%b, Sub=%b, BO=%b", A, B, BI, Sub, BO);
    $finish();
    end
  endtask
  task pass; begin
    $display("Pass: A=%b, B=%b, BI=%b, Sub=%b, BO=%b", A, B, BI, Sub, BO);
    $finish();
    end
  endtask
endmodule