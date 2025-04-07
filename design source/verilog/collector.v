module pulse_collector (
    input wire fast_clk,      // 快时钟
    input wire slow_clk,      // 慢时钟
    input wire rstn,          // 复位信号
    input wire slow_pulse,    // 慢时钟域输入脉冲（修改后）
    output reg fast_pulse     // 快时钟域输出脉冲（修改后）
);

    // 定义跨时钟域FIFO
    parameter FIFO_DEPTH = 8;
    reg [2:0] write_ptr_slow;     // 慢时钟写指针
    reg [2:0] read_ptr_fast;      // 快时钟读指针
    reg [2:0] read_ptr_slow;      // 同步到慢时钟的读指针
    reg [2:0] write_ptr_fast;     // 同步到快时钟的写指针
    
    // 慢时钟域逻辑（现在是写入端）
    always @(posedge slow_clk or negedge rstn) begin
        if (~rstn) begin
            write_ptr_slow <= 3'b0;
            read_ptr_slow <= 3'b0;
        end else begin
            // 同步读指针到慢时钟域
            read_ptr_slow <= read_ptr_fast;
            
            // 当有脉冲且FIFO未满时写入
            if (slow_pulse && ((write_ptr_slow + 1'b1) != read_ptr_slow)) begin
                write_ptr_slow <= write_ptr_slow + 1'b1;
            end
        end
    end
    
    // 快时钟域逻辑（现在是读取端）
    always @(posedge fast_clk or negedge rstn) begin
        if (~rstn) begin
            read_ptr_fast <= 3'b0;
            write_ptr_fast <= 3'b0;
            fast_pulse <= 1'b0;
        end else begin
            // 同步写指针到快时钟域
            write_ptr_fast <= write_ptr_slow;
            
            // 默认不输出脉冲
            fast_pulse <= 1'b0;
            
            // 当FIFO非空时读取并产生脉冲
            if (read_ptr_fast != write_ptr_fast) begin
                fast_pulse <= 1'b1;
                read_ptr_fast <= read_ptr_fast + 1'b1;
            end
        end
    end

endmodule