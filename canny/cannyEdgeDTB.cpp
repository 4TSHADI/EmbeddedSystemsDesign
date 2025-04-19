#include "cannyEdgeD.h"

void test_canny_edge_detector() {
    // Create a sample input image (single pixel)
    pixel_t test_pixel = 0x123456;  // A sample RGB color
    
    bool i_vid_hsync = true;
    bool i_vid_vsync = true;
    bool i_vid_vde = true;
    pixel_t o_vid_data;
    bool o_vid_hsync;
    bool o_vid_vsync;
    bool o_vid_vde;
    bool clk = true;
    bool nrst = true;
    
    // Call the canny edge detector function
    canny_edge_detector(test_pixel, i_vid_hsync, i_vid_vsync, i_vid_vde, 
                        o_vid_data, o_vid_hsync, o_vid_vsync, o_vid_vde, clk, nrst);
    
    // Output results
    std::cout << "Output Video Data: " << o_vid_data << std::endl;
}

int main() {
    test_canny_edge_detector();
    return 0;
}
