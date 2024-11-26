`timescale 1ns / 1ns

module mux2to1(x, y, s, f);

	input x, y, s;
	output f;

	assign f = (~s & x) | (s & y);

endmodule


module sub_circuit(clock, reset, right, left, loadLeft, d, loadn, Q, ASRight, MostSigBit);

input clock, reset, right, left, loadLeft, d, loadn, ASRight, MostSigBit;
output reg Q;
wire f, D;

mux2to1 m1(right, left, loadLeft, f);
mux2to1 m2(d, f, loadn, D);

always@(posedge clock)
begin
	if(reset == 1'b1)
		Q <= 0;
	else if(loadLeft && loadn && ASRight && MostSigBit)
		Q <= Q;
	else
		Q <= D;
end

endmodule

module part3(clock, reset, ParallelLoadn, RotateRight, ASRight, Data_IN, Q);

	input clock, reset, ParallelLoadn, RotateRight, ASRight;
	input [7:0]Data_IN;
	output [7:0]Q;

	sub_circuit sc0(clock, reset, Q[7], Q[1], RotateRight, Data_IN[0], ParallelLoadn, Q[0], ASRight, 1'b0);
	sub_circuit sc1(clock, reset, Q[0], Q[2], RotateRight, Data_IN[1], ParallelLoadn, Q[1], ASRight, 1'b0);
	sub_circuit sc2(clock, reset, Q[1], Q[3], RotateRight, Data_IN[2], ParallelLoadn, Q[2], ASRight, 1'b0);
	sub_circuit sc3(clock, reset, Q[2], Q[4], RotateRight, Data_IN[3], ParallelLoadn, Q[3], ASRight, 1'b0);
	sub_circuit sc4(clock, reset, Q[3], Q[5], RotateRight, Data_IN[4], ParallelLoadn, Q[4], ASRight, 1'b0);
	sub_circuit sc5(clock, reset, Q[4], Q[6], RotateRight, Data_IN[5], ParallelLoadn, Q[5], ASRight, 1'b0);
	sub_circuit sc6(clock, reset, Q[5], Q[7], RotateRight, Data_IN[6], ParallelLoadn, Q[6], ASRight, 1'b0);
	sub_circuit sc7(clock, reset, Q[6], Q[0], RotateRight, Data_IN[7], ParallelLoadn, Q[7], ASRight, 1'b1);

endmodule