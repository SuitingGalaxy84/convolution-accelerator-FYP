// File: interface.sv #updated inverface
`ifndef INTERFACE_SV
`define INTERFACE_SV

    interface PE_DATA #(parameter DATA_WIDTH = 16)();
        logic [DATA_WIDTH-1:0] ifmap;
        logic [DATA_WIDTH-1:0] fltr;
        logic [2*DATA_WIDTH-1:0] ipsum;
        logic [2*DATA_WIDTH-1:0] opsum;
    
        // Modports for PE and BUS roles
        modport PE (
            input ifmap, 
            input fltr,
            input ipsum,
            output opsum
        );
        modport BUS (
            output ifmap, 
            output fltr, 
            output ipsum,
            input opsum
        );
    endinterface // PE_DATA
    
    interface PE_CTRL(input logic clk);
        logic mult_seln;
        logic acc_seln;
    
        // Modports for PE and CU roles
        modport PE (
            input mult_seln,
            input acc_seln
        );
        modport CU (
            output mult_seln,
            output acc_seln
        );
    endinterface // PE_CTRL
    
    interface CASTER_IF #(
            parameter DATA_WIDTH = 16,
            parameter NUM_COL = 4
        )();
        // Interface signals
        logic [DATA_WIDTH-1:0] data_B2C;  // Data from BUS to CASTER
        logic [DATA_WIDTH-1:0] data_C2B;  // Data from CASTER to BUS
    
        logic [DATA_WIDTH-1:0] data_C2P;  // Data from CASTER to PE
        logic [DATA_WIDTH-1:0] data_P2C;  // Data from PE to CASTER
    
        logic [$clog2(NUM_COL)-1:0] ID;  // Column index
        logic [$clog2(NUM_COL)-1:0] TAG;  // Column tag
    
    
        logic PE_READY;                   // Indicates PE is ready to accept data
        logic PE_VALID;                   // Indicates PE is valid to send data
    
        logic CASTER_READY;               // Indicates CASTER is ready
        logic CASTER_VALID;               // Indicates CASTER is valid
    
        logic PE_EN;                      // Enable signal for PE
        logic CASTER_EN;                  // Enable signal for CASTER
    
    
        
    
    
        // CASTER modport: Used for the CASTER logic to interact with the BUS
        modport CASTER_port(
            input data_B2C,
            output data_C2B,
            input data_P2C,
            output data_C2P,
            input ID,
            input TAG,
            input PE_READY,
            input PE_VALID,
            output CASTER_READY,
            output CASTER_VALID,
            input CASTER_EN,
            output PE_EN     
        );
    endinterface // CASTER_IF
    
    
    interface BUS_IF #(
            parameter DATA_WIDTH = 16,
            parameter NUM_COL = 4
        )();
        logic [$clog2(NUM_COL)-1:0] ID;  // Column index
        logic [$clog2(NUM_COL)-1:0] TAG;  // Column tag
    
        logic [DATA_WIDTH-1:0] ifmap_data_B2M;  // IFMAP from BUS to MultiCaster
        logic [DATA_WIDTH-1:0] fltr_data_B2M;  // Filter from BUS to MultiCaster
        logic [2*DATA_WIDTH-1:0] psum_data_B2M;  // Partial sum from BUS to MultiCaster
    
        logic [DATA_WIDTH-1:0] ifmap_data_M2B;  // IFMAP from MultiCaster to BUS
        logic [DATA_WIDTH-1:0] fltr_data_M2B;  // Filter from MultiCaster to BUS
        logic [2*DATA_WIDTH-1:0] psum_data_M2B;  // Partial sum from MultiCaster to BUS
    
        logic [DATA_WIDTH-1:0] ifmap_data_M2P;  // IFMAP from BUS to PE
        logic [DATA_WIDTH-1:0] fltr_data_M2P;  // Filter from BUS to PE
        logic [2*DATA_WIDTH-1:0] psum_data_M2P;  // Partial sum from BUS to PE
    
        logic [DATA_WIDTH-1:0] ifmap_data_P2M;  // IFMAP from PE to BUS
        logic [DATA_WIDTH-1:0] fltr_data_P2M;  // Filter from PE to BUS
        logic [2*DATA_WIDTH-1:0] psum_data_P2M;  // Partial sum from PE to BUS
    
    
    
    
        logic [2:0] CASTER_EN;  // Enable signal for CASTER from BUS
        logic CASTER_READY;  // Indicates CASTER is ready
        logic CASTER_VALID;
    
        logic [2:0] PE_EN;
        logic PE_READY;
        logic PE_VALID;
    
    
    
    
        
    
        // Interface signals
        modport BUS_port(
            input ifmap_data_B2M,
            output ifmap_data_M2B,
    
            input fltr_data_B2M,
            output fltr_data_M2B,
    
            input psum_data_B2M,
            output psum_data_M2B,
    
            input ifmap_data_M2P,
            output ifmap_data_P2M,
    
            input fltr_data_M2P,
            output fltr_data_P2M,
    
            input psum_data_M2P,
            output psum_data_P2M,
            input CASTER_EN,
            output CASTER_READY,
            output CASTER_VALID,
    
    
            output PE_EN,
            input PE_READY,
            input PE_VALID,
    
            input ID,
            input TAG
        );

    
    endinterface

`endif


