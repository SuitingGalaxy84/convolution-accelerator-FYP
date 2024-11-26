// File: interface.sv

interface PE_DATA #(parameter DATA_WIDTH = 16) (input logic clk);
    logic [DATA_WIDTH-1:0] ifmap;
    logic [DATA_WIDTH-1:0] fltr;
    logic [2*DATA_WIDTH-1:0] ipsum;
    logic [2*DATA_WIDTH-1:0] opsum;

    // Modports for PE and BUS roles
    modport PE (
        input ifmap, 
        input fltr
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

interface BUS_CASTER_X #(
    parameter DATA_WIDTH =16,
    parameter NUM_COL = 4
    ) (input logic clk);
    logic [DATA_WIDTH-1:0] ifmap;
    logic [DATA_WIDTH-1:0] fltr;
    logic [2*DATA_WIDTH-1:0] ipsum;
    logic [2*DATA_WIDTH-1:0] opsum;
    logic [$clog2(NUM_COL)-1:0] col;

    modport BUS(
        output ifmap,
        output fltr,
        output ipsum,
        input opsum,
        output col
    );   
    modport CASTER(
        input ifmap,
        input fltr,
        input ipsum,
        output opsum,
        input col
    );
endinterface // BUS_CASTER_X : determine the PE activation in the X direction



