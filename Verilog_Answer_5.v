
primitive udpY (Y, A, B, C, D);
  input A, B, C, D;
  output Y;
 
  //Y = AB'D + BCD' + AC
  table
  // A B C D : Y
     1 ? 1 ? : 1;
     1 0 0 1 : 1;
     0 1 1 0 : 1;
     0 0 ? ? : 0;
     0 1 0 ? : 0;
     1 1 0 ? : 0;
     0 1 1 1 : 0;
     1 0 0 0 : 0;
  endtable
endprimitive
//Testbench
module udpY_test;
  reg A, B, C, D;
  wire Y;
  
  parameter STDIN = 32'h8000_0000;
  integer testid;
  integer ret;
  
  udpY y1 (Y, A, B, C, D);
  
  initial begin
      
      ret = $fscanf(STDIN, "%d", testid);
      case(testid)
	  0: begin #5 A=1; B=0; C=0; D=1; end
	  1: begin #5 A=1; B=1; C=1; D=0; end
	  2: begin #5 A=0; B=1; C=1; D=0; end
	  3: begin #5 A=0; B=1; C=0; D=0; end
	  4: begin #5 A=1; B=1; C=1; D=1; end
	  5: begin #5 A=0; B=0; C=1; D=0; end
	  6: begin #5 A=1; B=0; C=1; D=1; end
	  7: begin #5 A=0; B=1; C=0; D=1; end
       default: begin
	    $display("Bad testcase id %d", testid);
	    $finish();
	  end
      endcase
      #5;
	 if ( (testid == 0 && Y == 1'b1) || (testid == 1 && Y == 1'b1) ||
	      (testid == 2 && Y == 1'b1) || (testid == 3 && Y == 1'b0) || 	
	      (testid == 4 && Y == 1'b1) || (testid == 5 && Y == 1'b0) || 	
	      (testid == 6 && Y == 1'b1) || (testid == 7 && Y == 1'b0))
	  pass();
	else
	  fail();
  end
  task fail; begin
    $display("Fail: A=%b, B=%b, C=%b, D=%b => Y!=%b", A, B, C, D, Y);
    $finish();
    end
  endtask
  task pass; begin
    $display("Pass: A=%b, B=%b, C=%b, D=%b => Y=%b", A, B, C, D, Y);
    $finish();
    end
  endtask
endmodule