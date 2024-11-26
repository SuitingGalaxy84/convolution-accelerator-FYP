`include "interface.sv"

module MultiCaster #(
    parameter DATA_WIDTH = 16,
    parameter NUM_COL = 4
)(
    input wire clk,
    input wire rstn,
    BUS_IF.BUS_data BUS_data,
    BUS_IF.BUS_ctrl BUS_ctrl
);

    CASTER_IF #(DATA_WIDTH, NUM_COL) ifmap_CASTER(clk);
    CASTER_IF #(DATA_WIDTH, NUM_COL) fltr_CASTER(clk);
    CASTER_IF #(2*DATA_WIDTH, NUM_COL) psum_CASTER(clk);

    caster #(DATA_WIDTH, NUM_COL) ifmap_caster(clk, rstn, ifmap_CASTER.CASTER_data, ifmap_CASTER.CASTER_ctrl);
    caster #(DATA_WIDTH, NUM_COL) fltr_caster(clk, rstn, fltr_CASTER.CASTER_data, fltr_CASTER.CASTER_ctrl);
    caster #(2*DATA_WIDTH, NUM_COL) psum_caster(clk, rstn, psum_CASTER.CASTER_data, psum_CASTER.CASTER_ctrl);

    /* Parsing Three Casters into One MultiCaster Begin */
        assign BUS_data.ifmap_data_B2M = ifmap_CASTER.CASTER_data.data_B2C;
        assign BUS_data.fltr_data_B2M = fltr_CASTER.CASTER_data.data_B2C;
        assign BUS_data.psum_data_B2M = psum_CASTER.CASTER_data.data_B2C;

        assign ifmap_CASTER.CASTER_data.data_C2B = BUS_data.ifmap_data_M2B;
        assign fltr_CASTER.CASTER_data.data_C2B = BUS_data.fltr_data_M2B;
        assign psum_CASTER.CASTER_data.data_C2B = BUS_data.psum_data_M2B;

        assign BUS_data.ifmap_data_M2P = ifmap_CASTER.CASTER_data.data_C2P;
        assign BUS_data.fltr_data_M2P = fltr_CASTER.CASTER_data.data_C2P;
        assign BUS_data.psum_data_M2P = psum_CASTER.CASTER_data.data_C2P;

        assign ifmap_CASTER.CASTER_data.data_B2C = BUS_data.ifmap_data_P2M;
        assign fltr_CASTER.CASTER_data.data_B2C = BUS_data.fltr_data_P2M;
        assign psum_CASTER.CASTER_data.data_B2C = BUS_data.psum_data_P2M;

        // Allocate the CASTER_EN signal to the corresponding CASTER
        assign ifmap_CASTER.CASTER_ctrl.CASTER_EN = BUS_ctrl.CASTER_EN[0]; // The BUS want to enable the ifmap_CASTER
        assign fltr_CASTER.CASTER_ctrl.CASTER_EN = BUS_ctrl.CASTER_EN[1]; // The BUS want to enable the fltr_CASTER
        assign psum_CASTER.CASTER_ctrl.CASTER_EN = BUS_ctrl.CASTER_EN[2]; // The BUS want to enable the psum_CASTER

        // READY (Output) signal notifies the BUS->BUFFER that the PE is ready to accept data ()
        assign BUS_ctrl.CASTER_READY = ifmap_CASTER.CASTER_ctrl.CASTER_READY & 
                                       fltr_CASTER.CASTER_ctrl.CASTER_READY & 
                                       psum_CASTER.CASTER_ctrl.CASTER_READY; 

        // VALID (Output) signal notifies the BUS that the calculation is done
        assign BUS_ctrl.CASTER_VALID = ifmap_CASTER.CASTER_ctrl.CASTER_VALID & 
                                      fltr_CASTER.CASTER_ctrl.CASTER_VALID & 
                                       psum_CASTER.CASTER_ctrl.CASTER_VALID; // VALID (Output) signal notifies the BUS that the calculation is done
    
        // PE_EN signal enables the PE from the CASTER to perform the calculation
        assign BUS_ctrl.PE_EN = ifmap_CASTER.CASTER_ctrl.PE_EN & 
                               fltr_CASTER.CASTER_ctrl.PE_EN & 
                               psum_CASTER.CASTER_ctrl.PE_EN; // PE_EN signal enables the PE from the CASTER to perform the calculation

    /* Parsing Three Casters into One MultiCaster End */
        





endmodule // MultiCaster