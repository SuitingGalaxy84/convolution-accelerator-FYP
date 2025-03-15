module bit_detector #(
    parameter N = 8  // 数据宽度，可配置
)(
    input wire clk,           // 时钟信号
    input wire rst,           // 复位信号
    input wire [N-1:0] data,  // 输入数据
    output reg out            // 输出信号
);

    // 寄存器保存上一周期的数据
    reg [N-1:0] data_prev;
    
    // 寄存器保存第一个置1的比特位置
    reg [$clog2(N)-1:0] first_bit_pos;
    
    // 寄存器记录是否已经找到第一个置1的比特
    reg found_first_bit;
    
    // 优先编码器输出和有效标志
    wire [$clog2(N)-1:0] priority_pos;
    wire priority_valid;
    
    // 优先编码器实例化
    priority_encoder #(
        .WIDTH(N)
    ) pe_inst (
        .data(data),
        .pos(priority_pos),
        .valid(priority_valid)
    );
    
    // 主逻辑
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // 复位所有寄存器
            data_prev <= {N{1'b0}};
            first_bit_pos <= {$clog2(N){1'b0}};
            found_first_bit <= 1'b0;
            out <= 1'b0;
        end else begin
            // 保存当前数据用于下一周期比较
            data_prev <= data;
            
            // 数据为零时，输出置0，重置状态
            if (!priority_valid) begin
                out <= 1'b0;
                found_first_bit <= 1'b0;
            end 
            // 数据非零
            else begin
                // 如果还没找到第一个置1的比特
                if (!found_first_bit) begin
                    // 设置输出为1（数据非零）
                    out <= 1'b1;
                    found_first_bit <= 1'b1;
                    
                    // 保存第一个置1的比特位置
                    first_bit_pos <= priority_pos;
                end 
                // 已经找到第一个置1的比特，检查它是否翻转
                else begin
                    // 检查第一个置1的比特是否从1变为0
                    if (data_prev[first_bit_pos] && !data[first_bit_pos]) begin
                        // 第一个置1的比特翻转为0，输出置0
                        out <= 1'b0;
                        found_first_bit <= 1'b0;
                    end
                end
            end
        end
    end

endmodule

// 优先编码器模块
module priority_encoder #(
    parameter WIDTH = 8
)(
    input wire [WIDTH-1:0] data,
    output reg [$clog2(WIDTH)-1:0] pos,
    output wire valid
);
    integer i;
    
    assign valid = |data;  // 如果数据中有任何一位为1，则valid为1
    
    always @(*) begin
        pos = {$clog2(WIDTH){1'b0}};
        for (i = 0; i < WIDTH; i = i + 1) begin
            if (data[i]) begin
                pos = i[$clog2(WIDTH)-1:0];
                // 找到第一个1后退出循环
                i = WIDTH;
            end
        end
    end
endmodule