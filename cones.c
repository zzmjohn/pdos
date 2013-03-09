#include "cones.h"
#include <math.h>

/* in place projection (with branches) */
inline void projSelfDualCone(double *restrict x, Cone *restrict k)
{
  int i, j;
  int count;
  
  /* project onto positive orthant */
  for(i = k->f; i < k->f+k->l; ++i)
  {
    if(x[i] < 0.0) x[i] = 0.0;
  }
  count = k->l+k->f;
  /* project onto SOC */
  for(i = 0; i < k->qsize; ++i)
  {
    double v1 = x[count];
    double s = 0.0;
    double alpha;
    for(j = 0; j < k->q[i]-1; ++j)
    {   
      s += x[count+j+1]*x[count+j+1];
    }   
    s = sqrt(s);
    alpha = (s + v1)/2.0;

    if(s <= v1) { /* do nothing */ }
    else if (s <= - v1) {
      for(j = 0; j < k->q[i]; ++j)
        x[count+j] = 0.0;
    } else {    
      x[count] = alpha;
      for(j = 0; j < k->q[i]-1; ++j)
        x[count+j+1] = alpha*(x[count+j+1])/s;
    }           
    count += k->q[i];
    /* project onto OTHER cones */
  }
}

void projCone(double *restrict x, Cone *restrict k)
{
  projSelfDualCone(x,k);
}

void projDualCone(double *restrict x, Cone *restrict k)
{
  /* project zeros on zero cone */
  memset(x,0,(sizeof(double)*k->f));
  projSelfDualCone(x, k);
}
