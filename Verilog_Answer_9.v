


module fulladder (S, C, A, B, Cin);
       input A, B, Cin;
       output S, C;
       wire [2:0] t;
       xor   #2   G1  (t[0], A, B);
       xor   #2   G2  (S, t[0], Cin);
       and   #2   G3  (t[1], t[0], Cin);
       and   #2   G4  (t[2], A, B);
       or    #2   G5  (C, t[1], t[2]);
endmodule


module pipe_rca4 (Cout, Sum, A, B, Cin, Clk);
       input [3:0] A, B;
       input Cin, Clk;
       output [3:0] Sum;
       output Cout;

       reg [8:0] lev1;
       reg [7:0] lev2;
       reg [6:0] lev3;
       reg [5:0] lev4;
       reg [4:0] lev5;

       wire [3:0] sout;
       wire [3:0] cout;

       fulladder  f1 (sout[0], cout[0], lev1[5], lev1[1], lev1[0]);
       fulladder  f2 (sout[1], cout[1], lev2[4], lev2[1], lev2[0]);
       fulladder  f3 (sout[2], cout[2], lev3[3], lev3[1], lev3[0]);
       fulladder  f4 (sout[3], cout[3], lev4[2], lev4[1], lev4[0]);

       assign {Cout , Sum} = {cout[3], sout[3], lev4[5:3]};

	   always @(posedge Clk)
             begin
                      lev1 <= {A[3:0], B[3:0], Cin};
                      lev2 <= {sout[0], lev1[8:6], lev1[4:2], cout[0]};
                      lev3 <= {sout[1], lev2[7:5], lev2[3:2], cout[1]};
                      lev4 <= {sout[2], lev3[6:4], lev3[2], cout[2]};
             end
endmodule
//Testbench 

module pipe_rca4_test;
	reg [3:0] A, B, A_prev, B_prev;
	reg Cin, Cin_prev, Clk;
	wire [3:0] Sum;
	wire Cout;

        parameter STDIN = 32'h8000_0000;
        integer testid;
        integer ret;
		
	pipe_rca4 DUT (Cout, Sum, A, B, Cin, Clk);
	
	initial
		begin
			Clk = 1'b0;
			#500 $finish;
		end
	always #5 Clk = ~Clk;
	
	initial
	begin 

            ret = $fscanf(STDIN, "%d", testid);

            case(testid)
	        0: begin
                       #2  A = 7; B = 5; Cin = 0;
                       #10 A_prev = A; B_prev = B; Cin_prev = Cin; A = 0; B = 0; Cin = 0;
                       #30; 
                   end
	        1: begin
                       #2  A = 7; B = 5; Cin = 1;
                       #10 A_prev = A; B_prev = B; Cin_prev = Cin; A = 0; B = 0; Cin = 0;
                       #30; 
                   end
	        2: begin
                       #2  A = 10; B = 6; Cin = 0;
                       #10 A_prev = A; B_prev = B; Cin_prev = Cin; A = 0; B = 0; Cin = 0;
                       #30; 
                   end
	        3: begin
                       #2  A = 4; B = 10; Cin = 1;
                       #10 A_prev = A; B_prev = B; Cin_prev = Cin; A = 0; B = 0; Cin = 0;
                       #30; 
                   end
	        4: begin
                       #2  A = 0; B = 6; Cin = 1;
                       #10 A_prev = A; B_prev = B; Cin_prev = Cin; A = 0; B = 0; Cin = 0;
                       #30; 
                   end
	        5: begin
                       #2  A = 0; B = 0; Cin = 0;
                       #10 A_prev = A; B_prev = B; Cin_prev = Cin; A = 2; B = 2; Cin = 2;
                       #30; 
                   end
	        6: begin
                       #2  A = 0; B = 0; Cin = 1;
                       #10 A_prev = A; B_prev = B; Cin_prev = Cin; A = 0; B = 0; Cin = 0;
                       #30; 
                   end
	        7: begin
                       #2  A = 3; B = 0; Cin = 0; 
                       #10 A_prev = A; B_prev = B; Cin_prev = Cin; A = 0; B = 0; Cin = 0;
                       #30; 
                   end
                default: begin
			     $display("Bad testcase id %d", testid);
			     $finish();
			 end
	    endcase
   	    if ((testid == 0 && Sum == 12 && Cout == 0) || (testid == 1 && Sum == 13 && Cout == 0) ||
		(testid == 2 && Sum == 0 && Cout == 1) || (testid == 3 && Sum == 15 && Cout == 0) || 
		(testid == 4 && Sum == 7 && Cout == 0) || (testid == 5 && Sum == 0 && Cout == 0) ||
		(testid == 6 && Sum == 1 && Cout == 0) || (testid == 7 && Sum == 3 && Cout == 0))
			pass();
		else
			fail();
	end


	task fail; 	begin
			  $display("Fail: (A = %d and B = %d and Cin = %b) => (Sum != %d and  Cout != %d)", A_prev, B_prev, Cin_prev, Sum, Cout);
			  $finish();
			end
	endtask

	task pass; 	begin
			   $display("Pass: (A = %d and B = %d and Cin = %b) => (Sum = %d and  Cout = %d)", A_prev, B_prev, Cin_prev, Sum, Cout);
			  $finish();
			end
	endtask
endmodule