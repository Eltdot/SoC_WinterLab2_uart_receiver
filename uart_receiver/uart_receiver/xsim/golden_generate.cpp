#include <iostream>
#include <fstream>
#include <bitset>

int main() {
    // 打開文件
    std::ofstream golden_file("golden.dat");

    if (!golden_file.is_open()) {
        std::cerr << "Failed to open golden.dat for writing." << std::endl;
        return 1;
    }

    // 遍歷所有可能的數據位 (0x00 - 0xFF)
    for (int data = 0; data <= 0xFF; ++data) {
        // 起始位 (0)
        std::string start_bit = "0";

        // 數據位 (8 位)
        std::string data_bits = std::bitset<8>(data).to_string();

        // 停止位 (1)
        std::string stop_bit = "1";

        // 組合完整的 UART 信號
        std::string uart_signal = start_bit + data_bits + stop_bit;

        // 寫入 golden.dat 文件
        // 格式: <Input Signal> <Expected Data> <Valid Flag>
        golden_file << uart_signal << " " << data_bits << " " << "1" << "\n";
    }

    // 增加非法數據測試用例（停止位錯誤）
    golden_file << "0101010100 01010101 0\n"; // 停止位為 0
    golden_file << "1111111110 11111111 0\n"; // 停止位為 0

    golden_file.close();
    std::cout << "golden.dat has been successfully generated with expected outputs!" << std::endl;
    return 0;
}