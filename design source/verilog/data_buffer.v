module DataBuff #(
    parameter NUM_COL = 4, 
    parameter DATA_WIDTH = 16
)(  
    input wire clk_w,
    input wire clk_r,
    input wire rstn,



    input wire wr_en,
    input wire [7:0] kernel_size,

    input PE_READY,
    input PE_VALID,

    input wire [DATA_WIDTH-1:0] wdata,
    output wire [DATA_WIDTH-1:0] rdata,


);
    reg rd_en;
    always @(posedge rd_clk or negedge rstn) begin
        if(~rstn) 
    end 
    
    AsyncFIFO #(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(NUM_COL)
    )(
        .wr_clk(clk_w),
        .rd_clk(clk_r),
        .rst_n(rstn),
        .wr_en(),
        .rd_en(),
        .data_in(wdata),
        .data_out(rdata),
        .full(),
        .empty()
    )


endmodule 