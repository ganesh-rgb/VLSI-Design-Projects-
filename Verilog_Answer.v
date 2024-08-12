
module demux1to2 (out, in, sel);
  input in, sel;
  output [1:0] out;
  wire t;
  
  not g1 (t, sel);	
  and g2 (out[1], in, t),
      g3 (out[0], in, sel);
endmodule
//Testbench
module demux1to2_test;
    reg in, sel;
    wire [1:0] out;

    parameter STDIN = 32'h8000_0000;
    integer testid;
    integer ret;

    demux1to2 dmx (out, in, sel);

    initial 
        begin
            ret = $fscanf(STDIN, "%d", testid);
	    case(testid)
	        0: begin
                       #5 in = 1; sel = 0; 
                   end
	        1: begin
                       #5 in = 1; sel = 1;
                   end
	        2: begin
                       #5 in = 0; sel = 0;
                   end
	        3: begin
                       #5 in = 0; sel = 1;
                   end
                default: begin
			     $display("Bad testcase id %d", testid);
			     $finish();
			 end
	    endcase
            #5;
		if ( (testid == 0 && out == 2'b10) || (testid == 1 && out == 2'b01) ||
		(testid == 2 && out == 2'b00) || (testid == 3 && out == 2'b00))
			pass();
		else
			fail();
	end


	task fail; 	begin
			  $display("Fail: (in = %b, sel = %b) => out[1:0] != %b", in, sel, out);
			  $finish();
			end
	endtask

	task pass; 	begin
			  $display("Pass: (in = %b, sel = %b) => out[1:0] = %b", in, sel, out);
			  $finish();
			end
	endtask
endmodule