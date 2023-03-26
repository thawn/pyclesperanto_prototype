__constant sampler_t sampler = CLK_NORMALIZED_COORDS_FALSE | CLK_ADDRESS_CLAMP_TO_EDGE | CLK_FILTER_NEAREST;

__kernel void mode_box_2d
(
  IMAGE_dst_TYPE dst,
  IMAGE_src_TYPE src,
  const int Nx,
  const int Ny
)
{
  const int i = get_global_id(0);
  const int j = get_global_id(1);
  const int2 coord = (int2){i,j};

  long histogram[256];
  for (int i = 0; i < 256; i++){
    histogram[i]=0;
  }

  const int4   e = (int4)  { (Nx-1)/2, (Ny-1)/2, 0, 0 };

  for (int x = -e.x; x <= e.x; x++) {
    for (int y = -e.y; y <= e.y; y++) {
      histogram[(int)READ_src_IMAGE(src,sampler,coord+((int2){x,y})).x]++;
    }
  }

  long max_value = 0;
  int max_pos = 0;
  for (int i = 0; i < 256; i++){
    if (max_value < histogram[i]){
      max_value = histogram[i];
      max_pos = i;
    }
  }

  WRITE_dst_IMAGE(dst, coord, CONVERT_dst_PIXEL_TYPE(max_pos));
}


