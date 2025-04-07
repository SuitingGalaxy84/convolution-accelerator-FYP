module pulse_accumulator (
    input wire fast_clk,      // ???
    input wire slow_clk,      // ???
    input wire rstn,          // ????
    input wire fast_pulse,    // ????????
    output reg slow_pulse     // ????????
);

    // ?????????????FIFO
    parameter FIFO_DEPTH = 8;
    reg [2:0] write_ptr_fast;     // ???????
    reg [2:0] read_ptr_slow;      // ???????
    reg [2:0] read_ptr_fast;      // ???????????
    reg [2:0] write_ptr_slow;     // ???????????
    
    // ??????????
    always @(posedge fast_clk or negedge rstn) begin
        if (~rstn) begin
            write_ptr_fast <= 3'b0;
            read_ptr_fast <= 3'b0;
        end else begin
            // ??????????
            read_ptr_fast <= read_ptr_slow;
            
            // ???FIFO?????????
            if (fast_pulse && ((write_ptr_fast + 1'b1) != read_ptr_fast)) begin
                write_ptr_fast <= write_ptr_fast + 1'b1;
            end
        end
    end
    
    // ?????????????
    always @(posedge slow_clk or negedge rstn) begin
        if (~rstn) begin
            read_ptr_slow <= 3'b0;
            write_ptr_slow <= 3'b0;
            slow_pulse <= 1'b0;
        end else begin
            // ??????????
            write_ptr_slow <= write_ptr_fast;
            
            // ???????
            slow_pulse <= 1'b0;
            
            // ????????????????
            if (read_ptr_slow != write_ptr_slow) begin
                slow_pulse <= 1'b1;
                read_ptr_slow <= read_ptr_slow + 1'b1;
            end
        end
    end

endmodule