//
// This is the template for Part 2 of Lab 7.
//
// Paul Chow
// November 2021
//

module part2(iResetn,iPlotBox,iBlack,iColour,iLoadX,iXY_Coord,iClock,oX,oY,oColour,oPlot);
   parameter X_SCREEN_PIXELS = 8'd160;
   parameter Y_SCREEN_PIXELS = 7'd120;
   
   input wire iResetn, iPlotBox, iBlack, iLoadX;
   input wire [2:0] iColour;
   input wire [6:0] iXY_Coord;
   input wire 	    iClock;
   output wire [7:0] oX;         // VGA pixel coordinates
   output wire [6:0] oY;
   
   output wire [2:0] oColour;     // VGA pixel colour (0-7)
   output wire 	     oPlot;       // Pixel draw enable

   //
   // Your code goes here
   //
	
	wire ld_x, ld_y, ld_c, plotEn, blackEn;
	wire [3:0]counter;
	
	control c0(
    .clk(iClock),
    .resetn(iResetn),
    .iLoadX(iLoadX),
	 .plotBox(iPlotBox),
	 .iBlack(iBlack),
	 .counter(counter),
	 
	 .oPlot(oPlot),
    .ld_x(ld_x),
	 .ld_y(ld_y),
	 .ld_c(ld_c),
    .plotEn(plotEn),
    .blackEn(blackEn)
   );
	 
	datapath d0(
    .clk(iClock),
    .resetn(iResetn),
    .XYCoor(iXY_Coord),
    .colour(iColour), 
    .ld_x(ld_x),
    .ld_y(ld_y),
	 .ld_c(ld_c),
    .plotEn(plotEn),
	 .blackEn(blackEn),
	 
	 .counter(counter),
    .oX(oX),
	 .oY(oY),
	 .oColour(oColour)
   );
   
endmodule // part2

// Control Path
module control(
    input clk,
    input resetn,
    input iLoadX,
	 input plotBox,
	 input iBlack,
	 input [3:0] counter,
	 
	 output oPlot,
    output reg ld_x,
	 output reg ld_y,
	 output reg ld_c,
    output reg plotEn,
    output reg blackEn
    );

    reg [5:0] current_state, next_state; 
    
    localparam  loadX = 5'd0,
                loadXw8 = 5'd1,
                loadY = 5'd2,
                loadYw8 = 5'd3,
                plot = 5'd4,
					 black = 5'd5,
					 blackw8 = 5'd6;
					 
    
    // Next state logic aka our state table
    always@(*) begin
		  case(current_state)
				
				loadX: begin
						
						if(iLoadX)
							next_state = loadXw8;
						else
							next_state = loadX;
							
						if(iBlack)
							next_state = blackw8;
						
				end
				
				black: next_state = loadX;
				
				blackw8: next_state = black? blackw8 : black;
				
				loadXw8: begin
					   
						if(iLoadX)
							next_state = loadXw8;
						else
							next_state = loadY;
							
						if(iBlack)
							next_state = blackw8;
						
				end
				
				loadY: begin
					   
						if(plotBox)
							next_state = loadYw8;
						else
							next_state = loadY;
							
						if(iBlack)
							next_state = blackw8;
						
				end
				
				loadYw8: begin
					   
						if(plotBox)
							next_state = loadYw8;
						else
							next_state = plot;
							
						if(iBlack)
							next_state = blackw8;
						
				end
				
				plot: begin
					   
						if(counter == 4'b1111)
							next_state = loadX;
						else
							next_state = plot;
							
						if(iBlack)
							next_state = blackw8;
						
				end
				
				default: next_state = loadX;
				
        endcase
    end // state_table
   

    // Output logic aka all of our datapath control signals
    always@* begin
        // By default make all our signals 0
         ld_x = 0;
			ld_y = 0;
			ld_c = 0;
			plotEn = 0;
			blackEn = 0;

        case(current_state)
		  
				black: blackEn = 1;
		  
            loadX: ld_x = 1;
					 
            loadY: ld_y = 1;
					 
            plot: begin
					 ld_c = 1;
                plotEn = 1;
            end
            
				
        // default:    // don't need default since we already made sure all of our outputs were assigned a value at the start of the always block
        endcase
		  
    end // enable_signals
	 
	 assign oPlot = plotEn;
   
    // current_state registers
    always@(posedge clk) begin
        if(!resetn)
            current_state <= loadX;
        else
            current_state <= next_state;
    end // state_FFS
	 
endmodule


// Data Path
module datapath(
    input clk,
    input resetn,
    input [6:0] XYCoor,
    input [2:0] colour, 
    input ld_x,
    input ld_y,
	 input ld_c,
    input plotEn,
	 input blackEn,
	 
	 output reg [3:0] counter,
    output reg [7:0] oX,
	 output reg [6:0] oY,
	 output reg [2:0] oColour
    );
    
    // input registers
    reg [7:0] x;
	 reg [6:0] y;
    
    // Registers with respective input logic
    always@(posedge clk) begin
	 
        if(!resetn) begin
            x <= 8'b0; 
            y <= 7'b0;
        end
		  
        else begin
		  
            if(ld_x)
					x <= XYCoor;
            else if(ld_y)
               y <= XYCoor;
        end
		  
    end
	 
	 reg [3:0] Count;
	 reg [7:0] xCounter;
	 reg [6:0] yCounter;
 
    // Display
    always@(posedge clk) begin
	 
        if(!resetn)
				Count = 0;
				
        if(ld_c)
            Count = Count + 1;
				
    end
	 
	 assign counter = Count;

    // Black display
    always @(posedge clk) begin
	 
        if(!resetn) begin
				xCounter = 0;
				yCounter= 0;
		  end
		  
		  else if(xCounter == 8'd159 && blackEn) begin
				xCounter = 0;
				yCounter = yCounter + 1;
		  end
		  
		  else if(blackEn)
				xCounter = xCounter + 1;
		  
    end

	 
    // Output
    always@* begin
	 
        if(plotEn) begin
				
				oX <= x + Count[1:0];
				oY <= y + Count[3:2];
				oColour <= colour;
				
		  end
		  
		  else if(blackEn) begin
		  
				oX <= xCounter;
				oY <= yCounter;
				oColour <= 0;
		  
		  end
		  
		  else begin
		  
				oX <= 0;
				oY <= 0;
				oColour <= 0;
		  
		  end
		  
    end
    
endmodule