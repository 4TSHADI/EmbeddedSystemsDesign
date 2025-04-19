#include <ap_int.h>
#include <ap_fixed.h>

#define IMG_WIDTH 640
#define IMG_HEIGHT 480
#define KERNEL_SIZE 5

typedef ap_uint<24> pixel_t;
typedef ap_uint<8> gray_t;
typedef ap_fixed<16,8> gradient_t;

// Gaussian blur kernel (5x5, sigma=1.4)
const int gaussian_kernel[KERNEL_SIZE][KERNEL_SIZE] = {
    {2, 4, 5, 4, 2},
    {4, 9, 12, 9, 4},
    {5, 12, 15, 12, 5},
    {4, 9, 12, 9, 4},
    {2, 4, 5, 4, 2}
};

void canny_edge_detector(
    ap_uint<24> i_vid_data,
    bool i_vid_hsync,
    bool i_vid_vsync,
    bool i_vid_vde,
    ap_uint<24> &o_vid_data,
    bool &o_vid_hsync,
    bool &o_vid_vsync,
    bool &o_vid_vde,
    bool clk,
    bool nrst
);