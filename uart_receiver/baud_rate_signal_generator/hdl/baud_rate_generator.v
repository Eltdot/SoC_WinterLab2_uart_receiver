module baud_rate_generator(
  input wire clk_in,
  input wire rst,
  output reg baud_rate_signal  
);

//9600 buad rate --> BAUD_RATE_NUMBER = (1s/9600)/10ns = (1000000000/9600)/10 = 10416
localparam BAUD_RATE_NUMBER = 10416;
localparam ZERO = 1'b0;
localparam ONE = 1'b1;

reg state;
reg [13:0] counter; // assume BAUD_RATE_NUMBER not exceed 2^14

always @(posedge clk_in) begin
    if (rst) begin
      state <= ZERO;
      counter <= BAUD_RATE_NUMBER - 1;
      baud_rate_signal <= 1'b0;
    end else begin
      case (state)
        ZERO: begin
          if (counter == 1) begin
            counter <= counter - 1;
            state <= ONE;
          end else begin
            counter <= counter - 1;
            state <= ZERO;
          end
          baud_rate_signal <= 0;
        end

        ONE: begin
          counter <= BAUD_RATE_NUMBER - 1;
          state <= ZERO;
          baud_rate_signal <= 1;
        end

        default: begin
            counter <= BAUD_RATE_NUMBER - 1;
            state <= ZERO;
            baud_rate_signal <= 0;
        end
      endcase
    end
end

endmodule