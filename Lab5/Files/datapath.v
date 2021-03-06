module datapath(datapath_in, vsel, writenum, write, readnum, clk, loada, loadb, shift, asel, bsel, ALUop, loadc, loads, Z_out, datapath_out);

input[15:0] datapath_in;
input [2:0] writenum, readnum;
input [1:0] ALUop, shift;
input write, clk, asel, bsel, vsel, loada, loadb, loadc, loads;

output [15:0] datapath_out;
output Z_out;

reg[15:0] data_in;
wire [15:0] data_out, A_in, B_in, sout, Ain, Bin, out;
wire Z;

  // MUX at the beginning of datapath. 
  always @(*)begin
    case(vsel)
      1'b0 : data_in = datapath_out;
      1'b1 : data_in = datapath_in;
     endcase
  end

// Module Instanciation 
// Resister File.
regfile U0(data_in, writenum, write, readnum, clk, data_out);

// Load A & Load B.
vDFF_L A(clk, loada, data_out, A_in);
vDFF_L B(clk, loadb, data_out, B_in);

// Shifter after Load B.
shifter U1(B_in, shift, sout);

// MUX after Load A & Load B.
MUX_asel muxa(A_in, asel, Ain);
MUX_bsel muxb(sout, datapath_in, bsel, Bin);

// ALU after MUX's
ALU U2(Ain, Bin, ALUop, out, Z);
vDFF_L C(clk, loadc, out, datapath_out);	// Load C
vDFF_L #(1) status(clk, loads, Z, Z_out);	// Status
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












