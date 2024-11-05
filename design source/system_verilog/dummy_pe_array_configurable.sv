module DummyPEArray_Config #(
    parameter DELAY_CYCLES = 10,           // 默认延迟周期
    parameter PE_WIDTH = 4,                // 数据位宽
    parameter NUM_ROWS = 3,                // 行数
    parameter NUM_COLS = 3                 // 列数
) (
    input wire clk,                        // 时钟信号
    input wire rst,                        // 复位信号

    // 拉平成一维数组的 ifmap 输入信号
    input wire [PE_WIDTH*(NUM_ROWS+NUM_COLS-1)-1:0] ifmap_conn_IN_flat, // 每行的第一个 ifmap 输入

    // 拉平成一维数组的 ifmap 和 psum 输出信号
    output wire [PE_WIDTH*(NUM_ROWS+NUM_COLS-1)-1:0] ifmap_conn_OUT_flat, // 每行的最后一个 ifmap 输出
    output wire [PE_WIDTH*NUM_COLS-1:0] psum_conn_OUT_flat   // 每行的最后一个 psum 输出
);

    // 中间连接线定义
    wire [PE_WIDTH-1:0] ifmap_conn [NUM_ROWS-1:0][NUM_COLS-1:0];
    wire [PE_WIDTH-1:0] psum_conn [NUM_ROWS-1:0][NUM_COLS-1:0];

    // 使用 generate 语句映射输入输出信号
    genvar row, col;
    generate
        for (row = 0; row < NUM_ROWS; row = row + 1) begin : gen_rows
            // 将一维输入 ifmap_conn_IN_flat 映射到多维数组 ifmap_conn 的第一列
            assign ifmap_conn[row][0] = ifmap_conn_IN_flat[PE_WIDTH*(row+1)-1 -: PE_WIDTH];
            // 将每行的最后一个 ifmap 和 psum 输出重新映射到一维输出信号
            assign ifmap_conn_OUT_flat[PE_WIDTH*(row+1)-1 -: PE_WIDTH] = ifmap_conn[row][NUM_COLS-1];

    
            for (col = 0; col < NUM_COLS; col = col + 1) begin : gen_cols


                // 将一维输入 ifmap_conn_IN_flat 映射到多维数组 ifmap_conn 的第一行
                assign ifmap_conn[0][col] = ifmap_conn_IN_flat[PE_WIDTH*(NUM_ROWS+col)-1 -: PE_WIDTH];
                // 将最后一行的每一个ifmap输出重新映射到一维输出信号
                assign ifmap_conn_OUT_flat[PE_WIDTH*(row+NUM_COLS)-1 -: PE_WIDTH] = ifmap_conn[NUM_ROWS-1][col];
                
                
                if (col == 0) begin
                    // 第一列，没有直接的 psum 输入，接地
                    SV_DummyPE #(
                        .DELAY_CYCLES(DELAY_CYCLES),
                        .PE_WIDTH(PE_WIDTH)
                    ) SV_DummyPE_inst (
                        .clk(clk),
                        .rst(rst),
                        .in_signals({
                            ifmap_conn[row][col],        // ifmap 输入
                            {PE_WIDTH{1'b0}}             // 没有 psum 输入，接地
                        }),
                        .out_signals({
                            ifmap_conn[row+1][col+1],      // 下一列的 ifmap 连接
                            psum_conn[row][col]          // 下一行的 psum 连接
                        })
                    );
                end else begin
                    // 中间或最后一列，接收前一个 PE 的 psum 输出
                    SV_DummyPE #(
                        .DELAY_CYCLES(DELAY_CYCLES),
                        .PE_WIDTH(PE_WIDTH)
                    ) SV_DummyPE_inst (
                        .clk(clk),
                        .rst(rst),
                        .in_signals({
                            ifmap_conn[row][col],        // ifmap 输入
                            psum_conn[row][col-1]        // 前一个 PE 的 psum 输出
                        }),
                        .out_signals({
                            ifmap_conn[row+1][col+1],      // 下一列的 ifmap 连接
                            psum_conn[row][col]          // 下一行的 psum 连接
                        })
                    );
                end
            end
            

            assign psum_conn_OUT_flat[PE_WIDTH*(row+1)-1 -: PE_WIDTH] = psum_conn[row][NUM_COLS-1];
        end
    endgenerate

endmodule