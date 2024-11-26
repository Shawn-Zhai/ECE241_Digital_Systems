module part3(Clock, Resetn, Go, Divisor, Dividend, Quotient, Remainder);

input Clock, Resetn, Go;
input [3:0] Divisor, Dividend;
output reg [3:0] Quotient, Remainder;

always@(posedge Clock) begin
	
	if(Resetn == 0) begin
		Quotient = 4'b0;
		Remainder = 4'b0;
	end
	
	else begin
		Quotient = Dividend / Divisor;
		Remainder = Dividend - Divisor * Quotient;
	end
	
end

endmodule
