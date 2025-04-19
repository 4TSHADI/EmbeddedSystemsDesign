#ifndef CANNY_EDGE_D_H
#define CANNY_EDGE_D_H

#include <ap_int.h>
#include <hls_stream.h>

#define IMG_WIDTH  640
#define IMG_HEIGHT 480

typedef ap_uint<24> pixel_t;
typedef ap_uint<8> gray_t;

void canny_edge_detector(
    pixel_t i_vid_data,
    bool i_vid_hsync,
    bool i_vid_vsync,
    bool i_vid_vde,
    pixel_t &o_vid_data,
    bool &o_vid_hsync,
    bool &o_vid_vsync,
    bool &o_vid_vde,
    bool clk,
    bool nrst
);

#endif
