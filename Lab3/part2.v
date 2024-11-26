`timescale 1ns / 1ns

module FullAdder(x, y, Ci, S, Co);

input x, y, Ci;
output S, Co;

assign S = Ci ^ x ^ y;
assign Co = (x & y)|(x & Ci)|(y & Ci);

endmodule


module part2(a, b, c_in, s, c_out);

input [3:0]a, b;
input c_in;
output [3:0]s, c_out;

FullAdder bit0(a[0], b[0], c_in, s[0], c_out[0]);
FullAdder bit1(a[1], b[1], c_out[0], s[1], c_out[1]);
FullAdder bit2(a[2], b[2], c_out[1], s[2], c_out[2]);
FullAdder bit3(a[3], b[3], c_out[2], s[3], c_out[3]);

endmodule
