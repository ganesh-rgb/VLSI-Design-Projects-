

module jk_ms_ff (Q, Qb, J, K, Clk, Set, Rst);
  input J, K, Clk, Set, Rst;
  output Q, Qb;
  wire [6:0] t;
  
  not g1 (t[0], Clk);

  nand g2(t[1], Qb, J, Clk),
       g3(t[2], Q, K, Clk),
       g4(t[3], t[1], t[4]),
       g5(t[4], t[2], t[3]),
       g6(t[5], t[3], t[0]),
       g7(t[6], t[4], t[0]),
       g8(Q, t[5], Qb, Set),
       g9(Qb, t[6], Q, Rst);

endmodule
//Testbench
module jk_ms_ff_test;
    reg J, K, Clk, Set, Rst, Q_P, Qb_P;
    wire Q, Qb;

    parameter STDIN = 32'h8000_0000;
    integer testid;
    integer ret;

    jk_ms_ff jk (Q, Qb, J, K, Clk, Set, Rst);

    initial Clk = 1'b0;
    always #5 Clk = ~Clk;

    initial 
        begin
            ret = $fscanf(STDIN, "%d", testid);
	    case(testid)
	        0: begin
                       Q_P = Q; Qb_P = Qb; Set = 1; Rst = 0; 
                       #5 J = 1; K = 0; 
                   end
	        1: begin
                       Q_P = Q; Qb_P = Qb; Set = 0; Rst = 1; 
                       #5 J = 0; K = 1; 
                   end
	        2: begin
                       Set = 1; Rst = 0; 
                       #5 J = 1; K = 0; 
                       #5 Rst = 1;
                       #5 Q_P = Q; Qb_P = Qb; J = 1; K = 1; #5;
                   end
	        3: begin
                       Set = 0; Rst = 1; 
                       #5 J = 0; K = 1; 
                       #5 Set = 1;
                       #5 Q_P = Q; Qb_P = Qb; J = 1; K = 0; #5;
                   end
	        4: begin
                       Set = 1; Rst = 0; 
                       #5 J = 1; K = 0; 
                       #5 Rst = 1;
                       #5 Q_P = Q; Qb_P = Qb; J = 0; K = 1; #5;
                   end
	        5: begin
                       Set = 0; Rst = 1; 
                       #5 J = 0; K = 1; 
                       #5 Set = 1;
                       #5 Q_P = Q; Qb_P = Qb;  J = 0; K = 0; #5;
                   end
	        6: begin
                       Set = 0; Rst = 1; 
                       #5 J = 0; K = 1; 
                       #5 Set = 1;
                       #5 Q_P = Q; Qb_P = Qb;  J = 1; K = 1; #5;
                   end
	        7: begin
                       Set = 1; Rst = 0; 
                       #5 J = 1; K = 0; 
                       #5 Rst = 1;
                       #5 Q_P = Q; Qb_P = Qb;  J = 0; K = 0; #5;
                   end
                default: begin
			     $display("Bad testcase id %d", testid);
			     $finish();
			 end
	    endcase
            #5;
		if ( (testid == 0 && {Q,Qb} == 2'b01) || (testid == 1 && {Q,Qb} == 2'b10) ||
		(testid == 2 && {Q,Qb} == 2'b01) || (testid == 3 && {Q,Qb} == 2'b10) || 
		(testid == 4 && {Q,Qb} == 2'b01) || (testid == 5 && {Q,Qb} == 2'b01) ||
		(testid == 6 && {Q,Qb} == 2'b10) || (testid == 7 && {Q,Qb} == 2'b10))
			pass();
		else
			fail();
	end


	task fail; 	begin
			  $display("Fail: (Pstate(Q,Qb) = (%b, %b), J = %b, K = %b, Set = %b, Rst = %b) => (Nstate(Q,Qb) != (%b, %b))", Q_P, Qb_P, J, K, Set, Rst, Q, Qb);
			  $finish();
			end
	endtask

	task pass; 	begin
			  $display("Pass: (Pstate(Q,Qb) = (%b, %b), J = %b, K = %b, Set = %b, Rst = %b) => (Nstate(Q,Qb) = (%b, %b))", Q_P, Qb_P, J, K, Set, Rst, Q, Qb);
			  $finish();
			end
	endtask
endmodule