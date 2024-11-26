`timescale 1ns / 1ns

module part2Enable(ClockIn, Reset, enable_1sec, Speed);

	input ClockIn, Reset;
	input [1:0]Speed;
	reg [10:0]q;
	output enable_1sec;

	always@(posedge ClockIn) begin
		
		if(Reset == 1)
			q <= 0;
		else if(q == 11'b0 && Speed == 2'b00)
			q <= 11'b0;
		else if(q == 11'b0 && Speed == 2'b01)
			q <= 11'd499;
		else if(q == 11'b0 && Speed == 2'b10)
			q <= 11'd999;
		else if(q == 11'b0 && Speed == 2'b11)
			q <= 11'd1999;
		else
			q <= q-1;
			
	end

	assign enable_1sec = (q == 11'b0)? 1 : 0;


endmodule


module part2(ClockIn, Reset, Speed, CounterValue);

	input ClockIn, Reset;
	input [1:0]Speed;
	output reg [3:0]CounterValue;

	wire enable;
	
	part2Enable u1(ClockIn, Reset, enable, Speed);
	
	always @(posedge ClockIn)
	begin
	if (Reset == 1'b1) 
	CounterValue <= 0;
	else if (CounterValue == 4'b1111)
	CounterValue <= 0;
	else if (enable == 1'b1)
	CounterValue <= CounterValue + 1;
	end

endmodule
