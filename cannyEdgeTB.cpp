#include <iostream>
#include <fstream>
#include "canny.h"
#include "cannyEdge.cpp"

void generate_gradient(ap_uint<24> img[IMG_HEIGHT][IMG_WIDTH]) {
    for (int y = 0; y < IMG_HEIGHT; y++) {
        for (int x = 0; x < IMG_WIDTH; x++) {
            ap_uint<8> val = x % 256;
            img[y][x] = (val << 16) | (val << 8) | val;
        }
    }
}

void save_image(const char* filename, ap_uint<24> img[IMG_HEIGHT][IMG_WIDTH]) {
    std::ofstream out(filename, std::ios::binary);
    out << "P6\n" << IMG_WIDTH << " " << IMG_HEIGHT << "\n255\n";
    for (int y = 0; y < IMG_HEIGHT; y++) {
        for (int x = 0; x < IMG_WIDTH; x++) {
            out << (char)img[y][x].range(23, 16) 
                << (char)img[y][x].range(15, 8) 
                << (char)img[y][x].range(7, 0);
        }
    }
    out.close();
}

int main() {
    ap_uint<24> test_img[IMG_HEIGHT][IMG_WIDTH];
    ap_uint<24> output_img[IMG_HEIGHT][IMG_WIDTH];
    
    generate_gradient(test_img);
    save_image("input.ppm", test_img);
    
    // Initialize DUT
    ap_uint<24> o_vid_data;
    bool o_vid_hsync, o_vid_vsync, o_vid_vde;
    
    // Reset cycle
    canny_edge_detector(0, 0, 0, 0, o_vid_data, o_vid_hsync, o_vid_vsync, o_vid_vde, 1, 0);
    
    // Process frame
    for (int y = 0; y < IMG_HEIGHT; y++) {
        for (int x = 0; x < IMG_WIDTH; x++) {
            bool hsync = (x == IMG_WIDTH-1);
            bool vsync = (y == IMG_HEIGHT-1) && hsync;
            bool vde = (x < IMG_WIDTH) && (y < IMG_HEIGHT);
            
            canny_edge_detector(
                test_img[y][x], hsync, vsync, vde,
                o_vid_data, o_vid_hsync, o_vid_vsync, o_vid_vde,
                1, 1
            );
            
            if (vde) {
                output_img[y][x] = o_vid_data;
            }
        }
    }
    
    save_image("output.ppm", output_img);
    
    int edge_pixels = 0;
    for (int y = 0; y < IMG_HEIGHT; y++) {
        for (int x = 0; x < IMG_WIDTH; x++) {
            if (output_img[y][x].range(7,0) > 0) {
                edge_pixels++;
            }
        }
    }
    
    std::cout << "Detected " << edge_pixels << " edge pixels" << std::endl;
    return 0;
}