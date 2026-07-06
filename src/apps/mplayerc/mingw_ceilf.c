#pragma function(ceilf)

float ceilf(float x)
{
    int i = (int)x;
    float r = (float)i;
    if (r < x) r += 1.0f;
    return r;
}
