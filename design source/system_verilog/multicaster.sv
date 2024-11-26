module MultiCaster #(
    parameter DATA_WIDTH = 16,
    parameter NUM_COL = 4
)(
    input wire clk,

    input struct packed {
        ifmap_CASTER.CASTER.data_B2C;
        fltr_CASTER.CASTER.data_B2C;
        psum_CASTER.CASTER.data_B2C;
    } data_b2c,

    input struct packed {}
    output struct packed {
        ifmap_CASTER.CASTER.data_C2B;
        fltr_CASTER.CASTER.data_C2B;
        psum_CASTER.CASTER.data_C2B;
    } data_c2b,

    output struct packed {
        ifmap_CASTER.CASTER.CASTER_ready;
        fltr_CASTER.CASTER.CASTER_ready;
        psum_CASTER.CASTER.CASTER_ready;
    } CASTER_ready, // colloect the ready signals from all casters and send to bus
    

);
    BUS_CASTER_X #(DATA_WIDTH, NUM_COL) ifmap_CASTER(clk);
    BUS_CASTER_X #(DATA_WIDTH, NUM_COL) fltr_CASTER(clk);
    BUS_CASTER_X #(2*DATA_WIDTH, NUM_COL) psum_CASTER(clk);

    caster #(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_COL(4)
    ) ifmap_caster (
        .clk(clk),
        .rstn(rstn),
        .tag(tag),
        .PE_en(PE_en),
        .data_C2P(data_C2P),
        .CASTER(ifmap_CASTER.CASTER)
    );

    caster #(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_COL(4)
    ) fltr_caster (
        .clk(clk),
        .rstn(rstn),
        .tag(tag),
        .PE_en(PE_en),
        .data_C2P(data_C2P),
        .CASTER(fltr_CASTER.CASTER)
    );

    caster #(
        .DATA_WIDTH(2*DATA_WIDTH),
        .NUM_COL(4)
    ) psum_caster (
        .clk(clk),
        .rstn(rstn),
        .tag(tag),
        .PE_en(PE_en),
        .data_C2P(data_C2P),
        .CASTER(psum_CASTER.CASTER)
    );



endmodule