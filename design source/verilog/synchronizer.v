module pulse_accumulator (
    input wire fast_clk,      // ???
    input wire slow_clk,      // ???
    input wire rstn,         // ????
    input wire fast_pulse,    // ?????????
    output reg slow_pulse     // ?????????
);

    // ???FIFO????????????????FIFO?
    parameter FIFO_DEPTH = 8;
    reg [FIFO_DEPTH-1:0] fifo;
    reg [2:0] write_ptr;  // 3????????7
    reg [2:0] read_ptr;   // 3????????7
    
    // ???????FIFO
    always @(posedge fast_clk or negedge rstn) begin
        if (~rstn) begin
            write_ptr <= 3'b0;
            fifo <= {FIFO_DEPTH{1'b0}};
        end else if (fast_pulse) begin
            fifo[write_ptr] <= 1'b1;
            write_ptr <= write_ptr + 1'b1;
        end
    end
    
    // ???????FIFO
    always @(posedge slow_clk or negedge rstn) begin
        if (~rstn) begin
            read_ptr <= 3'b0;
            slow_pulse <= 1'b0;
        end else begin
            slow_pulse <= fifo[read_ptr];
            if (fifo[read_ptr]) begin
                fifo[read_ptr] <= 1'b0;  // ????????
                read_ptr <= read_ptr + 1'b1;
            end
        end
    end

endmodule