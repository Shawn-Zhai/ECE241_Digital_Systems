module part1(Clock, Enable, Clear_b, CounterValue);

input Clock, Enable, Clear_b;
output reg [7:0]CounterValue;

always@(negedge Clear_b, posedge Clock)
	if(Clear_b == 0)
		CounterValue <= 0;
	else if(Enable == 1)
		CounterValue <= CounterValue + 1;

endmodule
