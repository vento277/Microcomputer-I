module datapath(vsel, writenum, write, readnum, clk, loada, loadb, shift, asel, bsel, ALUop, loadc, loads, C, mdata, sximm8, sximm5, PC, status_out);

// After Lab6
input[15:0] mdata, sximm8, sximm5;
input [7:0] PC;
input [2:0] writenum, readnum;
input [1:0] ALUop, shift, vsel;
input write, clk, asel, bsel, loada, loadb, loadc, loads;

output [15:0] C;
output [2:0] status_out;

wire[2:0] status;
wire [15:0] data_in, data_out, A_in, B_in, sout, Ain, Bin, out;
wire[15:0] PC_0 = {8'b0, PC};


// MUX at the beginning of datapath. -> data_in
MUX_data_in datain(mdata, sximm8, PC_0, C, vsel, data_in);

// Module Instanciation 
// Resister File.
regfile REGFILE(data_in, writenum, write, readnum, clk, data_out);

// Load A & Load B.
vDFF_L A(clk, loada, data_out, A_in);
vDFF_L B(clk, loadb, data_out, B_in);

// Shifter after Load B.
shifter U1(B_in, shift, sout);

// MUX after Load A.
MUX_asel muxa(A_in, asel, Ain);

// MUX after Load B.
MUX_bsel muxb(sout, sximm5, bsel, Bin);

// ALU after MUX's.
alu U2(Ain, Bin, ALUop, out, status);

vDFF_L #(3) rstatus(clk, loads, status, status_out);	// Status
vDFF_L rC(clk, loadc, out, C);	// Load C


endmodule


// MUX after Load A
module MUX_asel(A_in, sel, Ain);
  input [15:0] A_in;
  input sel;
  output [15:0] Ain;

  reg [15:0]Ain;

  // selections
  always@(*) begin
    case(sel)
      1'b0: Ain = A_in;
      1'b1: Ain = 16'd0;
    endcase
  end
endmodule


module MUX_bsel(sout, datapath_in, sel, Bin);
  input [15:0] sout, datapath_in;
  input sel;
  output [15:0] Bin;

  reg [15:0] Bin;

  // selections
  always@(*) begin
    case(sel)
      1'b0: Bin = sout;
      1'b1: Bin = {11'd0, datapath_in[4:0]};
    endcase
  end
endmodule


// MUX for data_in
module MUX_data_in(mdata, sximm8, PC, Ci, vsel, out);
  input [15:0] mdata, sximm8, PC, Ci;
  input[1:0] vsel;
  output[15:0] out;
  reg[15:0] out;

  always@(*)begin
    case(vsel)
	2'b11: out = mdata; 
	2'b10: out = sximm8;
	2'b01: out = PC;
	2'b00: out = Ci;
    endcase
  end
endmodule










