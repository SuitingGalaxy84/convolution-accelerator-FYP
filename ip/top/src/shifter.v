module shifter#(
    parameter DATA_WIDTH = 16,  // 数据位宽
    parameter SHIFT_DEPTH = 8 // 移位寄存器深�??
)(
    input wire clk,              // 时钟信号
    input wire rstn,              // 异步复位信号
    input wire [DATA_WIDTH-1:0] serial_in,   // 串行输入
    output wire [DATA_WIDTH-1:0 ]serial_out,     // 串行输出   
    input wire [$clog2(SHIFT_DEPTH)-1:0] output_depth, // 动�?��?�择输出深度�??
    output wire [DATA_WIDTH-1:0] depth_output // 指定深度位输�??
);

    // 移位寄存器存储器
    reg [DATA_WIDTH-1:0] shift_reg [SHIFT_DEPTH-1:0];
    integer i;

    // 移位操作
    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            for (i = 0; i < SHIFT_DEPTH; i=i+1) begin
                shift_reg[i] <= 0;
            end
        end else begin
            // 移位操作
            for(i=0; i<SHIFT_DEPTH-1; i=i+1) begin
                shift_reg[i+1] <= shift_reg[i];
            end 
            shift_reg[0] <= serial_in;
        end
    end

    // 串行输出
    assign serial_out = shift_reg[SHIFT_DEPTH-1];

    // 指定深度位输�??
    assign depth_output = shift_reg[output_depth];

endmodule
