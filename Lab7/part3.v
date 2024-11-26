//
// This is the template for Part 3 of Lab 7.
//
// Paul Chow
// November 2021
//

// iColour is the colour for the box
//
// oX, oY, oColour and oPlot should be wired to the appropriate ports on the VGA controller
//

// Some constants are set as parameters to accommodate the different implementations
// X_SCREENSIZE, Y_SCREENSIZE are the dimensions of the screen
//       Default is 160 x 120, which is size for fake_fpga and baseline for the DE1_SoC vga controller
// CLOCKS_PER_SECOND should be the frequency of the clock being used.

module part3(iColour,iResetn,iClock,oX,oY,oColour,oPlot);
   input wire [2:0] iColour;
   input wire 	    iResetn;
   input wire 	    iClock;
   output wire [7:0] oX;         // VGA pixel coordinates
   output wire [6:0] oY;
   
   output wire [2:0] oColour;     // VGA pixel colour (0-7)
   output wire 	     oPlot;       // Pixel drawn enable

   parameter
     X_SCREENSIZE = 160,  // X screen width for starting resolution and fake_fpga
     Y_SCREENSIZE = 120,  // Y screen height for starting resolution and fake_fpga
     CLOCKS_PER_SECOND = 5000, // 5 KHZ for fake_fpga
     X_BOXSIZE = 8'd4,   // Box X dimension
     Y_BOXSIZE = 7'd4,   // Box Y dimension
     X_MAX = X_SCREENSIZE - 1 - X_BOXSIZE, // 0-based and account for box width
     Y_MAX = Y_SCREENSIZE - 1 - Y_BOXSIZE,
     PULSES_PER_SIXTIETH_SECOND = CLOCKS_PER_SECOND / 60
	       ;

   //
   // Your code goes here
   //


endmodule // part3