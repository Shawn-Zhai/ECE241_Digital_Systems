`timescale 1ns / 1ns

module rateDivider(ClockIn, Resetn, enable_halfSec);

	input ClockIn, Resetn;
	reg [9:0]q;
	output enable_halfSec;

	always@(posedge ClockIn) begin
		
		if(Resetn == 0)
			q <= 10'd499;
		else if(q == 10'b0)
			q <= 10'd249;
		else
			q <= q-1;
			
	end

	assign enable_halfSec = (q == 10'b0)? 1 : 0;

endmodule


module morseALU(ClockIn, Resetn, Start, Letter, ALUout);

	input ClockIn, Resetn, Start;
	input [2:0]Letter;
	output reg [11:0]ALUout;
	
	always@(posedge ClockIn, negedge Resetn) begin
	
		if(Resetn == 0)
			ALUout = 12'b0;
			
		else if(Start == 1) begin
			case(Letter)
				3'b000: ALUout = 12'b101110000000;
				3'b001: ALUout = 12'b111010101000;
				3'b010: ALUout = 12'b111010111010;
				3'b011: ALUout = 12'b111010100000;
				3'b100: ALUout = 12'b100000000000;
				3'b101: ALUout = 12'b101011101000;
				3'b110: ALUout = 12'b111011101000;
				3'b111: ALUout = 12'b101010100000;
				default: ALUout = 12'b0;
			endcase
		end
		
	end

endmodule


module shiftRegister(ClockIn, Resetn, Enable, load, DotDashOut);

	input ClockIn, Resetn, Enable;
	input [11:0]load;
	output reg DotDashOut;
	
	reg [11:0]Q;
	assign Q = (Resetn == 0) ? 0 : load;
	
	always@(posedge ClockIn) begin
			
		if(Enable == 1) begin
			Q[11] <= Q[10];
			Q[10] <= Q[9];
			Q[9] <= Q[8];
			Q[8] <= Q[7];
			Q[7] <= Q[6];
			Q[6] <= Q[5];
			Q[5] <= Q[4];
			Q[4] <= Q[3];
			Q[3] <= Q[2];
			Q[2] <= Q[1];
			Q[1] <= Q[0];
			Q[0] <= Q[11];
			DotDashOut <= Q[11];
		end
		
		else
			DotDashOut <= Q[11];
	
	end

endmodule


module part3(ClockIn, Resetn, Start, Letter, DotDashOut);

	input ClockIn, Resetn, Start;
	input [2:0]Letter;
	output DotDashOut;
	
	wire c1;
	wire [11:0]c2;
	
	rateDivider u1(ClockIn, Resetn, c1);
	morseALU u2(ClockIn, Resetn, Start, Letter, c2);
	shiftRegister u3(ClockIn, Resetn, c1, c2, DotDashOut);

endmodule