# Details

Date : 2025-02-09 15:25:51

Directory /Users/yucheng/Documents/FYP/convolution-accelerator-FYP

Total : 52 files,  2923 codes, 1029 comments, 727 blanks, all 4679 lines

[Summary](results.md) / Details / [Diff Summary](diff.md) / [Diff Details](diff-details.md)

## Files
| filename | language | code | comment | blank | total |
| :--- | :--- | ---: | ---: | ---: | ---: |
| [README.md](/README.md) | Markdown | 52 | 0 | 17 | 69 |
| [design source/spinalHDL/README.md](/design%20source/spinalHDL/README.md) | Markdown | 1 | 0 | 2 | 3 |
| [design source/system\_verilog/README.md](/design%20source/system_verilog/README.md) | Markdown | 1 | 0 | 2 | 3 |
| [design source/system\_verilog/bus\_interconnect.sv](/design%20source/system_verilog/bus_interconnect.sv) | System Verilog | 0 | 0 | 3 | 3 |
| [design source/system\_verilog/caster.sv](/design%20source/system_verilog/caster.sv) | System Verilog | 35 | 21 | 6 | 62 |
| [design source/system\_verilog/ccd\_wrapper.sv](/design%20source/system_verilog/ccd_wrapper.sv) | System Verilog | 88 | 21 | 15 | 124 |
| [design source/system\_verilog/data\_enc.sv](/design%20source/system_verilog/data_enc.sv) | System Verilog | 20 | 21 | 10 | 51 |
| [design source/system\_verilog/dummy\_pe/dummy\_array\_control.sv](/design%20source/system_verilog/dummy_pe/dummy_array_control.sv) | System Verilog | 3 | 20 | 1 | 24 |
| [design source/system\_verilog/dummy\_pe/dummy\_pe.sv](/design%20source/system_verilog/dummy_pe/dummy_pe.sv) | System Verilog | 60 | 34 | 23 | 117 |
| [design source/system\_verilog/dummy\_pe/dummy\_pe\_array.sv](/design%20source/system_verilog/dummy_pe/dummy_pe_array.sv) | System Verilog | 86 | 37 | 17 | 140 |
| [design source/system\_verilog/dummy\_pe/dummy\_pe\_array\_configurable.sv](/design%20source/system_verilog/dummy_pe/dummy_pe_array_configurable.sv) | System Verilog | 85 | 49 | 41 | 175 |
| [design source/system\_verilog/dummy\_pe/dummy\_pe\_kl.sv](/design%20source/system_verilog/dummy_pe/dummy_pe_kl.sv) | System Verilog | 39 | 23 | 12 | 74 |
| [design source/system\_verilog/glb\_buffer.sv](/design%20source/system_verilog/glb_buffer.sv) | System Verilog | 12 | 21 | 2 | 35 |
| [design source/system\_verilog/glb\_pe.sv](/design%20source/system_verilog/glb_pe.sv) | System Verilog | 36 | 22 | 7 | 65 |
| [design source/system\_verilog/global\_buffer.sv](/design%20source/system_verilog/global_buffer.sv) | System Verilog | 29 | 21 | 8 | 58 |
| [design source/system\_verilog/interface.sv](/design%20source/system_verilog/interface.sv) | System Verilog | 252 | 45 | 83 | 380 |
| [design source/system\_verilog/multicaster.sv](/design%20source/system_verilog/multicaster.sv) | System Verilog | 109 | 59 | 39 | 207 |
| [design source/system\_verilog/pe.sv](/design%20source/system_verilog/pe.sv) | System Verilog | 102 | 40 | 20 | 162 |
| [design source/system\_verilog/pe\_array\_configurable.sv](/design%20source/system_verilog/pe_array_configurable.sv) | System Verilog | 92 | 22 | 21 | 135 |
| [design source/system\_verilog/pe\_ctrl.sv](/design%20source/system_verilog/pe_ctrl.sv) | System Verilog | 79 | 0 | 12 | 91 |
| [design source/system\_verilog/xbus\_control.sv](/design%20source/system_verilog/xbus_control.sv) | System Verilog | 50 | 21 | 15 | 86 |
| [design source/verilog/README.md](/design%20source/verilog/README.md) | Markdown | 1 | 0 | 2 | 3 |
| [design source/verilog/async\_fifo.v](/design%20source/verilog/async_fifo.v) | Verilog | 77 | 11 | 16 | 104 |
| [design source/verilog/async\_fifo\_claude.v](/design%20source/verilog/async_fifo_claude.v) | Verilog | 127 | 18 | 22 | 167 |
| [design source/verilog/async\_fifo\_with\_prefill.v](/design%20source/verilog/async_fifo_with_prefill.v) | Verilog | 107 | 30 | 30 | 167 |
| [design source/verilog/axi\_example/sample\_generator/sample\_generator\_v1\_0.v](/design%20source/verilog/axi_example/sample_generator/sample_generator_v1_0.v) | Verilog | 53 | 14 | 17 | 84 |
| [design source/verilog/axi\_example/sample\_generator/sample\_generator\_v1\_0\_M\_AXIS.v](/design%20source/verilog/axi_example/sample_generator/sample_generator_v1_0_M_AXIS.v) | Verilog | 122 | 72 | 35 | 229 |
| [design source/verilog/axi\_example/sample\_generator/sample\_generator\_v1\_0\_S\_AXIS.v](/design%20source/verilog/axi_example/sample_generator/sample_generator_v1_0_S_AXIS.v) | Verilog | 97 | 51 | 20 | 168 |
| [design source/verilog/data\_buffer.v](/design%20source/verilog/data_buffer.v) | Verilog | 35 | 1 | 10 | 46 |
| [design source/verilog/shifter.v](/design%20source/verilog/shifter.v) | Verilog | 28 | 5 | 6 | 39 |
| [design source/verilog/tagAlloc.v](/design%20source/verilog/tagAlloc.v) | Verilog | 53 | 20 | 6 | 79 |
| [design source/verilog/tagBuff.v](/design%20source/verilog/tagBuff.v) | Verilog | 41 | 19 | 6 | 66 |
| [design source/verilog/weight\_buffer.v](/design%20source/verilog/weight_buffer.v) | Verilog | 83 | 21 | 25 | 129 |
| [hdl\_source.code-workspace](/hdl_source.code-workspace) | JSON with Comments | 12 | 0 | 0 | 12 |
| [simulation source/spinalHDL/README.md](/simulation%20source/spinalHDL/README.md) | Markdown | 1 | 0 | 2 | 3 |
| [simulation source/system\_verilog/README.md](/simulation%20source/system_verilog/README.md) | Markdown | 1 | 0 | 1 | 2 |
| [simulation source/system\_verilog/ccd\_fifo\_reader.sv](/simulation%20source/system_verilog/ccd_fifo_reader.sv) | System Verilog | 45 | 6 | 5 | 56 |
| [simulation source/system\_verilog/ccd\_fifo\_writer.sv](/simulation%20source/system_verilog/ccd_fifo_writer.sv) | System Verilog | 48 | 6 | 12 | 66 |
| [simulation source/system\_verilog/ccd\_pe\_driver.sv](/simulation%20source/system_verilog/ccd_pe_driver.sv) | System Verilog | 57 | 28 | 16 | 101 |
| [simulation source/system\_verilog/glb\_pe\_driver.sv](/simulation%20source/system_verilog/glb_pe_driver.sv) | System Verilog | 46 | 21 | 6 | 73 |
| [simulation source/system\_verilog/pe\_driver.sv](/simulation%20source/system_verilog/pe_driver.sv) | System Verilog | 39 | 16 | 5 | 60 |
| [simulation source/system\_verilog/tb\_async\_fifo.sv](/simulation%20source/system_verilog/tb_async_fifo.sv) | System Verilog | 78 | 24 | 22 | 124 |
| [simulation source/system\_verilog/tb\_async\_fifo\_with\_prefill.sv](/simulation%20source/system_verilog/tb_async_fifo_with_prefill.sv) | System Verilog | 91 | 24 | 21 | 136 |
| [simulation source/system\_verilog/tb\_ccd\_pe.sv](/simulation%20source/system_verilog/tb_ccd_pe.sv) | System Verilog | 95 | 21 | 15 | 131 |
| [simulation source/system\_verilog/tb\_dummpy\_pe\_array.sv](/simulation%20source/system_verilog/tb_dummpy_pe_array.sv) | System Verilog | 71 | 31 | 16 | 118 |
| [simulation source/system\_verilog/tb\_glb\_pe.sv](/simulation%20source/system_verilog/tb_glb_pe.sv) | System Verilog | 46 | 21 | 8 | 75 |
| [simulation source/system\_verilog/tb\_glb\_pe\_loop.sv](/simulation%20source/system_verilog/tb_glb_pe_loop.sv) | System Verilog | 78 | 21 | 11 | 110 |
| [simulation source/system\_verilog/tb\_pe.sv](/simulation%20source/system_verilog/tb_pe.sv) | System Verilog | 38 | 21 | 11 | 70 |
| [simulation source/system\_verilog/tb\_weight\_buffer.sv](/simulation%20source/system_verilog/tb_weight_buffer.sv) | System Verilog | 51 | 21 | 8 | 80 |
| [simulation source/system\_verilog/weight\_buffer\_driver.sv](/simulation%20source/system_verilog/weight_buffer_driver.sv) | System Verilog | 27 | 21 | 6 | 54 |
| [simulation source/verilog/README.md](/simulation%20source/verilog/README.md) | Markdown | 1 | 0 | 1 | 2 |
| [vis/pe\_ctrl\_viz.py](/vis/pe_ctrl_viz.py) | Python | 43 | 8 | 10 | 61 |

[Summary](results.md) / Details / [Diff Summary](diff.md) / [Diff Details](diff-details.md)