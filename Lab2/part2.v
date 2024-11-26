`timescale 1ns / 1ns
module v7404(pin1, pin3, pin5, pin9, pin11, pin13,
				 pin2, pin4, pin6, pin8, pin10, pin12);

input pin1, pin3, pin5, pin9, pin11, pin13;
output pin2, pin4, pin6, pin8, pin10, pin12;

assign pin2 = ~pin1;
assign pin4 = ~pin3;
assign pin6 = ~pin5;
assign pin8 = ~pin9;
assign pin10 = ~pin11;
assign pin12 = ~pin13;

endmodule

module v7408(pin1, pin2, pin3, pin4, pin5, pin6,
				 pin10, pin9, pin8, pin13, pin12, pin11);

input pin1, pin2, pin4, pin5, pin10, pin9, pin13, pin12;
output pin3, pin6, pin8, pin11;

assign pin3 = pin1 & pin2;
assign pin6 = pin4 & pin5;
assign pin8 = pin10 & pin9;
assign pin11 = pin13 & pin12;

endmodule

module v7432(pin1, pin2, pin3, pin4, pin5, pin6,
				 pin10, pin9, pin8, pin13, pin12, pin11);

input pin1, pin2, pin4, pin5, pin10, pin9, pin13, pin12;
output pin3, pin6, pin8, pin11;

assign pin3 = pin1 | pin2;
assign pin6 = pin4 | pin5;
assign pin8 = pin10 | pin9;
assign pin11 = pin13 | pin12;

endmodule

module mux2to1(x, y, s, m);
input x, y, s;
output m;
wire nots, xandnots, yands;

v7404 u1(.pin1(s), .pin2(nots));
v7408 u2(.pin1(nots), .pin2(x), .pin3(xandnots), .pin4(s), .pin5(y), .pin6(yands));
v7432 u3(.pin1(xandnots), .pin2(yands), .pin3(m));

endmodule
