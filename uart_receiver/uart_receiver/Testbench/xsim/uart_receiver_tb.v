// set the timescale for the simulation
 `timescale 1ns/1ps 
module testbench;  // module of testbench
//  parameter defined
parameter CYCLE = 10; // use CYCLE to describe the clock period
parameter BAUD_RATE_NUMBER = 20;

// localparam
localparam N = 258;


// input signal use reg
reg clk_in;
reg rst;
reg uart_rx;

// output signal use wire
wire [7:0] data;
wire valid_data;
wire baud_rate_signal;

// interger 
integer i, error;

///// instantiate  module /////
uart_receiver uart_receiver(
.clk_in(clk_in),
.rst(rst),
.uart_rx(uart_rx),
.baud_rate_signal(baud_rate_signal),
.data(data),
.valid_data(valid_data)
);

// No need to change
baud_rate_generator baud_rate_generator(
  .clk_in(clk_in),
  .rst(rst),
  .baud_rate_signal(baud_rate_signal)
);

//  dump the waveform of the simulation for fsdb//
/*initial begin
 $fsdbDumpfile("testbench.fsdb"); 
 $fsdbDumpvars;              
end*/

// dump the waveform of the simulation for vcd//
initial begin
  $dumpfile("testbench.vcd");
  $dumpvars("+mda");
end

// there you can read data from the file,and store in the register.
reg [18:0] golden [0:N];
initial begin
  $readmemb("golden.dat",golden);
end



// generate clk 
always #(CYCLE/2) clk_in = ~clk_in; 

//generate baud_rate_signal


// System block set only clock,reset signal and the timeout finish. 
initial begin
  clk_in = 1;
  rst = 0;
  // system reset
  #(CYCLE) rst = 1;
  #(CYCLE) rst = 0;
end

// input signal setting, pattern feeding and set control signal blcok.
integer k;
task send_uartrx (input reg [9:0] pattern_in);
  begin
    for(k = 9; k >= 0; k = k - 1) begin
      @(posedge baud_rate_signal);
      uart_rx = pattern_in[k];
    end
  end
endtask

integer fp_w;
reg [9:0] signal_in; // 10 bits uart_rx signal, from left to right
reg [7:0] correct_data; // 8 bits correct data
reg correct_valid; // 1 bit correvt valid_data
reg debug; // Observe data comparison time

initial begin
  debug = 1;
  uart_rx = 1; // initial idle
  error = 0; 
  fp_w = $fopen("answer.txt");
  wait(rst == 1);
  wait(rst == 0);

  for(i=0; i<N; i=i+1) begin
    @(negedge clk_in);
      signal_in = golden[i][18:9];
      correct_data = golden[i][8:1];
      correct_valid = golden[i][0];
      send_uartrx(signal_in);
      #(CYCLE + CYCLE / 2); 
      debug = ~debug;
      if({data, valid_data} !== {correct_data, correct_valid}) begin
        error = error + 1;
        $display("************* Pattern No.%d is wrong at %t ************", i,$time);
        $display("uart_rx = %b, correct data and correct valid_data is %b and %b,", signal_in, correct_data, correct_valid);
        $display("but your data and valid_data are %b and %b !!", data, valid_data);
      end
      $fdisplay(fp_w, "%b_%b_%b_%b_%b", signal_in, data, valid_data, correct_data, correct_valid);
  end

  $fclose(fp_w);

  if(error == 0) begin
    $display("Congratulations!! The functionality of your uart_receiver is correct!!");
  end
  else begin
    $display("error !!");
  end 
  #(CYCLE) $finish; 

end

endmodule