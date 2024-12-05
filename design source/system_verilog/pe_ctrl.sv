module SV_PE_ctrl(
    input clk,
    input READY,
    input rstn,
    output reg mult_seln,
    output reg acc_seln,
    output reg opsum_seln,
    output reg ipsum_seln,
    input [7:0] kernel_size,
    output hold_psum
);
    parameter [2:0] STATE_IDLE = 2'b00;
    parameter [2:0] STATE_IPSUM = 2'b01;
    parameter [2:0] STATE_OP = 2'b10;
    parameter [2:0] STATE_OPSUM = 2'b11;
    
    reg [1:0] current_state;
    reg [1:0] next_state;
    reg [7:0] MAC_counter = 8'b0; 
    reg out_valid;
    
    assign hold_psum = (current_state == STATE_OP && MAC_counter == 0) ? 1'b1 : 1'b0;
    
    
    always_ff @(posedge clk) begin : MAC_counting
        if(current_state != STATE_OP) begin
            MAC_counter <= 8'b0;
        end else begin
            MAC_counter <= MAC_counter + 1;
        end
        if(MAC_counter == kernel_size*kernel_size-2) begin
            out_valid <= 1'b1;
        end else begin
            out_valid <= 1'b0;
        end 
    end 

    always_ff @(posedge clk or negedge rstn) begin : STATE_machine 
        if (~rstn || kernel_size == 8'b0) begin
            current_state <= STATE_IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    always_comb begin : STATE_definition
        case (current_state)
            STATE_IDLE: begin 
                mult_seln =1; //ipsum
                acc_seln = 1; //pass 0 to pip_reg_2
                opsum_seln = 1; //output in valid
                ipsum_seln = 1;
                next_state = READY ? STATE_IPSUM : STATE_IDLE;
            end

            STATE_IPSUM: begin
                mult_seln = 1; //pass ipsum to pip_reg_1
                acc_seln = 1; //pass MAC_result to pip_reg_2
                opsum_seln = 1; //output in valid
                ipsum_seln = 0; //ipsum_valid
                next_state = STATE_OP;
            end 

            STATE_OP: begin
                mult_seln = 0; //pass mult result to adder
                acc_seln = 0; //pass psum to adder
                opsum_seln = 1;
                ipsum_seln = 1; //ipsum invalid
                next_state = out_valid ? STATE_OPSUM : STATE_OP; //  (MAC_counter==kernel_size*kernel_size-1) ? STATE_OPSUM :
            end 

            STATE_OPSUM: begin
                mult_seln = 0; //pass mult result to adder
                acc_seln = 0;
                opsum_seln = 0;
                ipsum_seln = 1; 
                next_state = PE_IF.READY ? STATE_IPSUM : STATE_IDLE;
            end 
            
            default : begin
                mult_seln = 1;
                acc_seln = 1;
                opsum_seln = 1;
                ipsum_seln = 1;
                next_state = STATE_IDLE;
            end
        endcase
    end

endmodule
