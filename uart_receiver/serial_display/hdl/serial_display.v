module serial_display(
  input wire clk_in,
  input wire rst,
  input wire [7:0] ascii_data,
  input wire data_valid,
  output reg [7:0] seven_segment_data,
  output reg [3:0] seven_segment_enable
);

reg [7:0] seven_segment_code[0:16];

initial begin
  seven_segment_code[0]  = 8'b00111111; // 0
  seven_segment_code[1]  = 8'b00000110; // 1
  seven_segment_code[2]  = 8'b01011011; // 2
  seven_segment_code[3]  = 8'b01001111; // 3
  seven_segment_code[4]  = 8'b01100110; // 4
  seven_segment_code[5]  = 8'b01101101; // 5
  seven_segment_code[6]  = 8'b01111101; // 6
  seven_segment_code[7]  = 8'b00000111; // 7
  seven_segment_code[8]  = 8'b01111111; // 8
  seven_segment_code[9]  = 8'b01101111; // 9
  seven_segment_code[10] = 8'b01110111; // A
  seven_segment_code[11] = 8'b01111100; // B
  seven_segment_code[12] = 8'b00111001; // C
  seven_segment_code[13] = 8'b01011110; // D
  seven_segment_code[14] = 8'b01111001; // E
  seven_segment_code[15] = 8'b01110001; // F
  seven_segment_code[16] = 8'b00000000; // invalid
end

reg [7:0] ascii_data_local;
reg [7:0] data_index;

always @(posedge clk_in) begin
  if (rst) begin
    ascii_data_local <= 71;
    data_index <= 16;
    seven_segment_enable <= 4'b1111; //無效輸出
  end else begin
    if (data_valid == 1) begin
      ascii_data_local <= ascii_data;
      seven_segment_enable <= 4'b1110;
    end
  end

  if (ascii_data_local >= 48 && ascii_data_local <= 57) begin
    data_index <= ascii_data_local - 48;
  end else if (ascii_data_local >= 65 && ascii_data_local <= 70) begin
    data_index <= ascii_data_local - 55;
  end else begin
    data_index <= 16;
  end

  seven_segment_data <= seven_segment_code[data_index];
end

endmodule