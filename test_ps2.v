module test_ps2	(
	CLOCK_50,
	KEY,

	// Bidirectionals
	PS2_CLK,
	PS2_DAT,
	
	// Outputs
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,
	HEX6,
	HEX7
);

/*****************************************************************************
 *                           Parameter Declarations                          *
 *****************************************************************************/


/*****************************************************************************
 *                             Port Declarations                             *
 *****************************************************************************/

// Inputs
input				CLOCK_50;
input		[3:0]	KEY;

// Bidirectionals
inout				PS2_CLK;
inout				PS2_DAT;

// Outputs
output		[6:0]	HEX0;
output		[6:0]	HEX1;
output		[6:0]	HEX2;
output		[6:0]	HEX3;
output		[6:0]	HEX4;
output		[6:0]	HEX5;
output		[6:0]	HEX6;
output		[6:0]	HEX7;

/*****************************************************************************
 *                 Internal Wires and Registers Declarations                 *
 *****************************************************************************/

// Internal Wires
wire		[7:0]	ps2_key_data;
wire				ps2_key_pressed;

// Internal Registers
reg			[7:0]	last_data_received;


// State Machine Registers

/*****************************************************************************
 *                         Finite State Machine(s)                           *
 *****************************************************************************/


/*****************************************************************************
 *                             Sequential Logic                              *
 *****************************************************************************/

always @(posedge CLOCK_50)
begin
	if (KEY[0] == 1'b0)
		last_data_received <= 8'h00;
	else if (ps2_key_pressed == 1'b1)
		last_data_received <= ps2_key_data;
end

/*****************************************************************************
 *                            Combinational Logic                            *
 *****************************************************************************/

assign HEX2 = 7'h7F;
assign HEX3 = 7'h7F;
assign HEX4 = 7'h7F;
assign HEX5 = 7'h7F;
assign HEX6 = 7'h7F;
assign HEX7 = 7'h7F;

/*****************************************************************************
 *                              Internal Modules                             *
 *****************************************************************************/

ps2_controller PS2 (
	// Inputs
	.CLOCK_50				(CLOCK_50),
	.reset				(~KEY[0]),

	// Bidirectionals
	.PS2_CLK			(PS2_CLK),
 	.PS2_DAT			(PS2_DAT),

	// Outputs
	.received_data		(ps2_key_data),
	.received_data_en	(ps2_key_pressed)
);

Hexadecimal_To_Seven_Segment Segment0 (
	// Inputs
	.c			(last_data_received[3:0]),

	// Bidirectional

	// Outputs
	.led	(HEX0)
);

Hexadecimal_To_Seven_Segment Segment1 (
	// Inputs
	.c			(last_data_received[7:4]),

	// Bidirectional

	// Outputs
	.led	(HEX1)
);

	
endmodule

`timescale 1ns / 1ns // `timescale time_unit/time_precision

module Hexadecimal_To_Seven_Segment (input[3:0] c, output[0:6] led);

	assign led[0] = (~c[3]&~c[2]&~c[1]&c[0])|(~c[3]&c[2]&~c[1]&~c[0])|
						 (c[3]&~c[2]&c[1]&c[0])|(c[3]&c[2]&~c[1]&c[0]);
						  
	assign led[1] = (~c[3]&c[2]&~c[1]&c[0])|(~c[3]&c[2]&c[1]&~c[0])|
						 (c[3]&~c[2]&c[1]&c[0])|(c[3]&c[2]&~c[1]&~c[0])|
					    (c[3]&c[2]&c[1]&~c[0])|(c[3]&c[2]&c[1]&c[0]);
						  
	assign led[2] = (~c[3]&~c[2]&c[1]&~c[0])|(c[3]&c[2]&~c[1]&~c[0])|
						 (c[3]&c[2]&c[1]&~c[0])|(c[3]&c[2]&c[1]&c[0]);
	
	assign led[3] = (~c[3]&~c[2]&~c[1]&c[0])|(~c[3]&c[2]&~c[1]&~c[0])|
						 (~c[3]&c[2]&c[1]&c[0])|(c[3]&~c[2]&c[1]&~c[0])|
						 (c[3]&c[2]&c[1]&c[0]);
						  
	
	assign led[4] = (~c[3]&~c[2]&~c[1]&c[0])|(~c[3]&~c[2]&c[1]&c[0])|
						 (~c[3]&c[2]&~c[1]&~c[0])|(~c[3]&c[2]&~c[1]&c[0])|
						 (~c[3]&c[2]&c[1]&c[0])|(c[3]&~c[2]&~c[1]&c[0]);
						  
	
	assign led[5] = (~c[3]&~c[2]&~c[1]&c[0])|(~c[3]&~c[2]&c[1]&~c[0])|
						 (~c[3]&~c[2]&c[1]&c[0])|(~c[3]&c[2]&c[1]&c[0])|
						 (c[3]&c[2]&~c[1]&c[0]);
						  
	
	assign led[6] = (~c[3]&~c[2]&~c[1]&~c[0])|(~c[3]&~c[2]&~c[1]&c[0])|
						 (~c[3]&c[2]&c[1]&c[0])|(c[3]&c[2]&~c[1]&~c[0]);

endmodule
