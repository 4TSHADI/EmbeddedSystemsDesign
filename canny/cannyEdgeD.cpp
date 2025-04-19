#include <ap_int.h>
#include <hls_math.h>

#define WIDTH 640            // Width of the input image
#define HEIGHT 480           // Height of the input image
#define KERNEL_SIZE 3        // Size of the kernel (3x3)

typedef ap_uint<24> pixel_t;   // RGB pixel type (24-bit)
typedef ap_int<8> gray_t;      // 8-bit grayscale pixel
typedef ap_int<16> gradient_t; // Gradient type for edge detection

// Gaussian filter kernel (3x3)
const int gaussian_kernel[KERNEL_SIZE][KERNEL_SIZE] = {
    {1, 2, 1},
    {2, 4, 2},
    {1, 2, 1}
};

// Function to convert RGB to grayscale
gray_t rgb_to_grayscale(pixel_t rgb) {
    ap_uint<8> r = rgb.range(23, 16);
    ap_uint<8> g = rgb.range(15, 8);
    ap_uint<8> b = rgb.range(7, 0);
    return (r * 76 + g * 150 + b * 25) >> 8;  // BT.601 coefficients
}

// Apply Gaussian filter
gray_t apply_gaussian_filter(pixel_t i_vid_data[3][3]) {
    int sum = 0;
    #pragma HLS PIPELINE
    for (int i = 0; i < KERNEL_SIZE; i++) {
        for (int j = 0; j < KERNEL_SIZE; j++) {
            sum += i_vid_data[i][j] * gaussian_kernel[i][j];
        }
    }
    return sum / 16;  // Normalize by dividing by sum of Gaussian kernel
}

// Main Canny edge detector function
void canny_edge_detector(
    pixel_t i_vid_data,  // Input video data (RGB pixel)
    bool i_vid_hsync,    // Horizontal sync signal
    bool i_vid_vsync,    // Vertical sync signal
    bool i_vid_vde,      // Video data enable
    pixel_t &o_vid_data, // Output video data (processed result)
    bool &o_vid_hsync,   // Output horizontal sync
    bool &o_vid_vsync,   // Output vertical sync
    bool &o_vid_vde,     // Output video data enable
    bool clk,            // Clock signal
    bool nrst            // Reset signal
) {
    // Interface pragmas for stability
    #pragma HLS INTERFACE stable port=i_vid_data
    #pragma HLS INTERFACE stable port=o_vid_data
    #pragma HLS INTERFACE stable port=i_vid_hsync
    #pragma HLS INTERFACE stable port=o_vid_hsync
    #pragma HLS INTERFACE stable port=i_vid_vsync
    #pragma HLS INTERFACE stable port=o_vid_vsync
    #pragma HLS INTERFACE stable port=i_vid_vde
    #pragma HLS INTERFACE stable port=o_vid_vde

    // Variables for processing
    gray_t gray_pixel;
    gray_t filtered_pixel;
    
    // Convert RGB to grayscale
    gray_pixel = rgb_to_grayscale(i_vid_data);
    
    // Apply Gaussian filter (3x3 kernel)
    pixel_t window[3][3] = {{i_vid_data, i_vid_data, i_vid_data},   // For simplicity, this should be a moving window of pixels
                            {i_vid_data, i_vid_data, i_vid_data},
                            {i_vid_data, i_vid_data, i_vid_data}};
    filtered_pixel = apply_gaussian_filter(window);
    
    // Output the processed pixel data (for now just pass it through)
    o_vid_data = filtered_pixel;  // Placeholder for actual edge detection output
    o_vid_hsync = i_vid_hsync;
    o_vid_vsync = i_vid_vsync;
    o_vid_vde = i_vid_vde;
}

