// set the timescale for the simulation
 `timescale 1ns/1ps 
module testbench;  // module of testbench
//  parameter defined
parameter CYCLE = 4; // use CYCLE to describe the clock period

// localparam
localparam BAUD_RATE_NUMBER= 10416;


// input signal use reg
reg clk_in;
reg rst;

// output signal use wire
wire baud_rate_signal;

// interger 
integer i, j, error;

///// instantiate  module /////
baud_rate_generator baud_rate_generator(
  .clk_in(clk_in),
  .rst(rst),
  .baud_rate_signal(baud_rate_signal)
);


// dump the waveform of the simulation for vcd//
initial begin
  $dumpfile("testbench.vcd");
  $dumpvars("+mda");
end

// there you can read data from the file,and store in the register.
/*reg [55:0] golden [0:N];
initial begin
  $readmemh("golden.dat",golden);
end*/



// generate clk 
always #(CYCLE/2) clk_in = ~clk_in; 

// System block set only clock,reset signal and the timeout finish. 
initial begin
  clk_in = 1;
  rst = 1;
  // system reset
  #(CYCLE) rst = 1;
  #(CYCLE) rst = 0;

  #(4 * CYCLE * BAUD_RATE_NUMBER) $finish;
end

// input signal setting, pattern feeding and set control signal blcok.

// output result checking block, control when to sample and verify the result.
integer  fp_w;
initial begin
  wait(rst==0);
  wait(rst==1);

  #(4 * CYCLE * BAUD_RATE_NUMBER) $finish;
end

endmodule