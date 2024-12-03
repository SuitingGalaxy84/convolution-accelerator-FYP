module SV_PE_ctrl(
    input clk,
    input en,
    input rstn,
    output reg mult_seln,
    output reg acc_seln,
    output reg opsum_seln,
    input [7:0] kernel_size
);
    parameter [2:0] STATE_IDLE = 2'b00;
    parameter [2:0] STATE_IPSUM = 2'b01;
    parameter [2:0] STATE_OP = 2'b11;
    parameter [2:0] STATE_OPSUM = 2'b10;
    
    
    reg [1:0] current_state;
    reg [1:0] next_state;
    reg [7:0] MAC_counter = 8'b0000_0000; 

    always_ff @(posedge clk or negedge rstn) begin : MAC_cunter
        if (~rstn) begin
            MAC_counter <= 8'b0000_0000;
            mult_seln <= 1'b1;
            acc_seln <= 1'b1;
            opsum_seln <= 1'b1;
        end else begin
            if (current_state == STATE_OP) begin
                MAC_counter <= MAC_counter + 1;
            end
            else begin
                MAC_counter <= 8'b0000_0000;
            end
            mult_seln <= mult_seln;
            acc_seln <= acc_seln;
            opsum_seln <= opsum_seln;
        end
    end

    always_ff @(posedge clk or negedge rstn) begin : STATE_machine 
        if (~rstn) begin
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
                next_state = en ? STATE_IPSUM : STATE_IDLE;
            end

            STATE_IPSUM: begin
                mult_seln = 1; //pass ipsum to pip_reg_1
                acc_seln = 1; //pass 0 to pip_reg_2
                opsum_seln = 1; //output in valid
                next_state = STATE_OP;
            end 

            STATE_OP: begin
                mult_seln = 0; //pass mult result to adder
                acc_seln = 0; //pass psum to adder
                opsum_seln = 1;
                next_state = (MAC_counter==kernel_size-1) ? STATE_OPSUM : STATE_OP;
            end 

            STATE_OPSUM: begin
                mult_seln = 0; //pass mult result to adder
                acc_seln = 0;
                opsum_seln = 0;
                next_state = en ? STATE_IPSUM : STATE_IDLE;
            end 
            default : begin
                mult_seln = 1;
                acc_seln = 1;
                opsum_seln = 1;
                next_state = STATE_IDLE;
            end
        endcase
    end

endmodule
