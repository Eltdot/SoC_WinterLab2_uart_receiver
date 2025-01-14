module uart_receiver(
    input wire clk_in,
    input wire rst,
    input wire uart_rx,
    input wire baud_rate_signal,
    output reg [7:0] data,
    output reg valid_data
);

localparam IDLE = 1'b0;
localparam RECEIVE = 1'b1;

reg state;
reg stop_bit;
reg [3:0] bit_counter;
reg [7:0] d;

always @(posedge clk_in) begin
  if (rst) begin
    state <= IDLE;
    bit_counter <= 0;
    d <= 8'b00000000;
    data <= 8'b00000000;
    valid_data <= 0;
  end else begin
    case (state) 
      IDLE: begin
        if (baud_rate_signal == 1 && uart_rx == 0) begin
          state <= RECEIVE;
        end else begin
          state <= IDLE;
        end
        valid_data <= 0;
        bit_counter <= 0;
      end

      RECEIVE: begin
        if (baud_rate_signal == 1) begin
          if (bit_counter == 8) begin
            if (uart_rx == 1) begin
              valid_data <= 1;
              data <= d;
            end else begin
              valid_data <= 0;
              data <= d;
            end
            bit_counter <= 0;
            state <= IDLE;
          end else begin
          d[bit_counter] <= uart_rx;
          bit_counter <= bit_counter + 1;
          state <= state;
          valid_data <= 0;
          end
        end else begin
          valid_data <= 0;
          state <= RECEIVE;
          bit_counter <= bit_counter;
        end
      end

      default: begin
        state <= IDLE;
        bit_counter <= 0;
        d <= 8'b00000000;
        data <= 8'b00000000;
        valid_data <= 0;
      end
    endcase
  end
end

endmodule