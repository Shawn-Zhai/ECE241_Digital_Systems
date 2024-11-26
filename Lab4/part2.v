`timescale 1ns / 1ns

module FullAdder(x, y, Ci, S, Co);

input x, y, Ci;
output S, Co;

assign S = Ci ^ x ^ y;
assign Co = (x & y)|(x & Ci)|(y & Ci);

endmodule


module AdderFourBit(a, b, c_in, s, c_out);

input [3:0]a, b;
input c_in;
output [3:0]s, c_out;

FullAdder bit0(a[0], b[0], c_in, s[0], c_out[0]);
FullAdder bit1(a[1], b[1], c_out[0], s[1], c_out[1]);
FullAdder bit2(a[2], b[2], c_out[1], s[2], c_out[2]);
FullAdder bit3(a[3], b[3], c_out[2], s[3], c_out[3]);

endmodule





module ALU(A, B, Function, ALUout);

	input [3:0]A, B;
	input [2:0]Function;
	output reg [7:0]ALUout;
	wire [7:0]c;
	
	AdderFourBit ivBitAdder(A, B, 1'b0, c[3:0], c[7:4]);
	
	always @*
		begin
			case(Function)
				3'b000: ALUout = {3'b0, c[7], c[3:0]};
				3'b001: ALUout = A + B;
				3'b010: ALUout = {{4{B[3]}}, B};
				3'b011: ALUout = {7'b0, |{A,B}};
				3'b100: ALUout = {7'b0, &{A,B}};
				3'b101: ALUout = B << A;
				3'b110: ALUout = A * B;
				3'b111: ;
				default: ALUout = 8'b0;
			endcase
		end
	
endmodule

module part2(Clock, Reset_b, Data, Function, ALUout);

input Clock, Reset_b;
input [2:0]Function;
input [3:0]Data;
output reg [7:0]ALUout;

wire [7:0]C;

ALU u0(Data, ALUout[3:0], Function, C);

always@(posedge Clock)
	begin
		if(Reset_b == 1'b0)
			ALUout <= 8'b0;
		else if(Reset_b == 1'b1 && Function == 3'b111)
			ALUout <= ALUout;
		else
			ALUout <= C;
	end

endmodule
