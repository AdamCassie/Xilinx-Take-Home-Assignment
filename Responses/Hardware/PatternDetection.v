/*
 * Design
 */


// Verilog module for pattern detection block
 module pattern_detector(
    input CLK,                  // 100MHz ref clock
    input RST,                  // Assume active high reset (asynchronous)
    input DIN,                  // 1-bit input (changes on posedge CLK)

    output reg  DETECT         // 1-bit indicator (1'b1 if pattern detected, else 1'b0)
    );

    reg [1:0] current_state, next_state;        // State registers

    // Define FSM states and encoding
    localparam  A       = 2'd0,                 // Seen '0' only
                B       = 2'd1,                 // Seen first '1' for required pattern
                C       = 2'd2,                 // Seen '10' pattern so far
                D		= 2'd3;                 // Seen '101' pattern so far

    // Next state logic (aka state table)
    always@(posedge CLK)
    begin: state_table 
            case (current_state)
                A:          next_state = DIN ? B : A;
                B:          next_state = DIN ? B : C;
                C:          next_state = DIN ? D : A;
                D:          next_state = DIN ? B : C;
            default:        next_state = A;
        endcase
    end // state_table

    // Output logic
    always@(posedge CLK)
    begin: output_logic 
            case (current_state)
                A:          DETECT = DIN ? 1'b0 : 1'b0;
                B:          DETECT = DIN ? 1'b0 : 1'b0;
                C:          DETECT = DIN ? 1'b0 : 1'b0;
                D:          DETECT = DIN ? 1'b1 : 1'b0;
            default:        DETECT = 1'b0;
        endcase
    end // output_logic

    // current_state registers
    always@(posedge CLK, posedge RST)           // Asynchronous active high reset signal
    begin: state_FFs
        if(RST)
            current_state <= A;
        else
            current_state <= next_state;
    end // state_FFS
endmodule


/*
 * Verification
 */

// Verilog test bench for pattern detection block
module pattern_detector_tb();

    reg CLK, RST, DIN;
	 wire DETECT;

    // Instantiate pattern detector
    pattern_detector DUT(
        .CLK(CLK),
        .RST(RST),
        .DIN(DIN),
        .DETECT(DETECT)
    );

    // Generate 100MHz clock
    initial begin
        CLK = 1'b0;
        RST = 1'b1;
        repeat(4) #10 CLK = ~CLK;
        RST = 1'b0;
        forever #10 CLK = ~CLK;     
    end

    // Test all state transitions
    initial begin
        
        // Stay in State A here
        @(negedge RST);
        DIN = 1'b0;
        @(posedge CLK);
        DIN = 1'b0;
        @(posedge CLK);
        DIN = 1'b0;

        // Change from State A to State B
        @(posedge CLK);
        DIN = 1'b1;

        // Stay in State B
        @(posedge CLK);
        DIN = 1'b1;

        // Change from State B to State C
        @(posedge CLK);
        DIN = 1'b0;

        // Change from State C to State A
        @(posedge CLK);
        DIN = 1'b0;

        // Change from State A to State B
        @(posedge CLK);
        DIN = 1'b1;

        // Change from State B to State C
        @(posedge CLK);
        DIN = 1'b0;

        // Change from State C to State D
        @(posedge CLK);
        DIN = 1'b1;

        // Change from State D to State C
        @(posedge CLK);
        DIN = 1'b0;

        // Change from State C to State D
        @(posedge CLK);
        DIN = 1'b1;

        // Change from State D to State B
        @(posedge CLK);
        DIN = 1'b1;
        @(posedge CLK);
        DIN = 1'b1;

        $finish;
    end

endmodule